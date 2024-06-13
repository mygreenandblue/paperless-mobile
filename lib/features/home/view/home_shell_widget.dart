import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';
import 'package:edocs_mobile/core/database/hive/hive_extensions.dart';
import 'package:edocs_mobile/core/database/tables/local_user_app_state.dart';
import 'package:edocs_mobile/core/factory/edocs_api_factory.dart';
import 'package:edocs_mobile/core/repository/label_repository.dart';
import 'package:edocs_mobile/core/repository/saved_view_repository.dart';
import 'package:edocs_mobile/core/repository/user_repository.dart';
import 'package:edocs_mobile/core/security/session_manager.dart';
import 'package:edocs_mobile/core/service/dio_file_service.dart';
import 'package:edocs_mobile/features/document_scan/cubit/document_scanner_cubit.dart';
import 'package:edocs_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:edocs_mobile/features/home/view/model/api_version.dart';
import 'package:edocs_mobile/features/inbox/cubit/inbox_cubit.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:edocs_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:edocs_mobile/features/tasks/model/pending_tasks_notifier.dart';
import 'package:provider/provider.dart';

class HomeShellWidget extends StatelessWidget {
  /// The id of the currently authenticated user (e.g. demo@edocs.example.com)
  final String localUserId;

  /// The edocs API version of the currently connected instance
  final int edocsApiVersion;

  // A factory providing the API implementations given an API version
  final EdocsApiFactory edocsProviderFactory;

  final Widget child;

  const HomeShellWidget({
    super.key,
    required this.edocsApiVersion,
    required this.edocsProviderFactory,
    required this.localUserId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        final currentUserId = settings.loggedInUserId;
        final apiVersion = ApiVersion(edocsApiVersion);
        return ValueListenableBuilder(
          valueListenable:
              Hive.localUserAccountBox.listenable(keys: [currentUserId]),
          builder: (context, box, _) {
            if (currentUserId == null) {
              //This only happens during logout...
              //FIXME: Find way so this does not occur anymore
              return const SizedBox.shrink();
            }
            final currentLocalUser = box.get(currentUserId)!;
            return MultiProvider(
              key: ValueKey(currentUserId),
              providers: [
                Provider.value(value: currentLocalUser),
                Provider.value(value: apiVersion),
                Provider(
                  create: (context) => CacheManager(
                    Config(
                      // Isolated cache per user.
                      localUserId,
                      fileService:
                          DioFileService(context.read<SessionManager>().client),
                    ),
                  ),
                ),
                Provider(
                  create: (context) => edocsProviderFactory.createDocumentsApi(
                    context.read<SessionManager>().client,
                    apiVersion: edocsApiVersion,
                  ),
                ),
                Provider(
                  create: (context) => edocsProviderFactory.createLabelsApi(
                    context.read<SessionManager>().client,
                    apiVersion: edocsApiVersion,
                  ),
                ),
                Provider(
                  create: (context) => edocsProviderFactory.createSavedViewsApi(
                    context.read<SessionManager>().client,
                    apiVersion: edocsApiVersion,
                  ),
                ),
                Provider(
                  create: (context) =>
                      edocsProviderFactory.createServerStatsApi(
                    context.read<SessionManager>().client,
                    apiVersion: edocsApiVersion,
                  ),
                ),
                Provider(
                  create: (context) => edocsProviderFactory.createTasksApi(
                    context.read<SessionManager>().client,
                    apiVersion: edocsApiVersion,
                  ),
                ),
                if (currentLocalUser.hasMultiUserSupport)
                  Provider(
                    create: (context) => edocsProviderFactory.createUserApi(
                      context.read<SessionManager>().client,
                      apiVersion: edocsApiVersion,
                    ),
                  ),
              ],
              builder: (context, _) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) {
                        return LabelRepository(context.read())
                          ..initialize(
                            loadCorrespondents: currentLocalUser
                                .edocsUser.canViewCorrespondents,
                            loadDocumentTypes:
                                currentLocalUser.edocsUser.canViewDocumentTypes,
                            loadStoragePaths:
                                currentLocalUser.edocsUser.canViewStoragePaths,
                            loadTags: currentLocalUser.edocsUser.canViewTags,
                            loadWarehouses:
                                currentLocalUser.edocsUser.canViewWarehouse,
                            loadFolders:
                                currentLocalUser.edocsUser.canViewFolder,
                          );
                      },
                    ),
                    ChangeNotifierProvider(
                      create: (context) {
                        final repo = SavedViewRepository(context.read());
                        if (currentLocalUser.edocsUser.canViewSavedViews) {
                          repo.initialize();
                        }
                        return repo;
                      },
                    ),
                    if (currentLocalUser.hasMultiUserSupport)
                      Provider(
                        create: (context) => UserRepository(
                          context.read(),
                        )..initialize(),
                      ),
                  ],
                  builder: (context, _) {
                    return MultiProvider(
                      providers: [
                        Provider(
                          lazy: false,
                          create: (context) => DocumentsCubit(
                            context.read(),
                            context.read(),
                            Hive.box<LocalUserAppState>(
                                    HiveBoxes.localUserAppState)
                                .get(currentUserId)!,
                            context.read(),
                          )..initialize(),
                        ),
                        Provider(
                          create: (context) =>
                              DocumentScannerCubit(context.read())
                                ..initialize(),
                        ),
                        Provider(
                          create: (context) {
                            final inboxCubit = InboxCubit(
                              context.read(),
                              context.read(),
                              context.read(),
                              context.read(),
                              context.read(),
                            );
                            if (currentLocalUser.edocsUser.canViewInbox) {
                              inboxCubit.initialize();
                            }
                            return inboxCubit;
                          },
                        ),
                        Provider(
                          create: (context) => SavedViewCubit(
                            context.read(),
                          ),
                        ),
                        Provider(
                          create: (context) => LabelCubit(
                            context.read(),
                          ),
                        ),
                        ChangeNotifierProvider(
                          create: (context) => PendingTasksNotifier(
                            context.read(),
                          ),
                        ),
                      ],
                      child: child,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
