import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/core/factory/paperless_api_factory.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository.dart';
import 'package:paperless_mobile/core/repository/user_repository.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/core/service/dio_file_service.dart';
import 'package:paperless_mobile/features/document_scan/cubit/document_scanner_cubit.dart';
import 'package:paperless_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:paperless_mobile/features/home/view/model/api_version.dart';
import 'package:paperless_mobile/features/inbox/cubit/inbox_cubit.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/features/tasks/model/pending_tasks_notifier.dart';
import 'package:paperless_mobile/routes/typed/branches/landing_route.dart';
import 'package:paperless_mobile/routes/typed/top_level/login_route.dart';
import 'package:paperless_mobile/routes/typed/top_level/switching_accounts_route.dart';
import 'package:paperless_mobile/routes/typed/top_level/verify_identity_route.dart';
import 'package:provider/provider.dart';

class HomeShellWidget extends StatelessWidget {
  /// The id of the currently authenticated user (e.g. demo@paperless.example.com)
  final String localUserId;

  /// The Paperless API version of the currently connected instance
  final int paperlessApiVersion;

  // A factory providing the API implementations given an API version
  final PaperlessApiFactory paperlessProviderFactory;

  final Widget child;

  const HomeShellWidget({
    super.key,
    required this.paperlessApiVersion,
    required this.paperlessProviderFactory,
    required this.localUserId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        final currentUserId = settings.loggedInUserId;
        if (currentUserId == null) {
          // This is currently the case (only for a few ms) when the current user logs out of the app.
          return const SizedBox.shrink();
        }
        final apiVersion = ApiVersion(paperlessApiVersion);
        return ValueListenableBuilder(
          valueListenable:
              Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount)
                  .listenable(keys: [currentUserId]),
          builder: (context, box, _) {
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
                  create: (context) =>
                      paperlessProviderFactory.createDocumentsApi(
                    context.read<SessionManager>().client,
                    apiVersion: paperlessApiVersion,
                  ),
                ),
                Provider(
                  create: (context) => paperlessProviderFactory.createLabelsApi(
                    context.read<SessionManager>().client,
                    apiVersion: paperlessApiVersion,
                  ),
                ),
                Provider(
                  create: (context) =>
                      paperlessProviderFactory.createSavedViewsApi(
                    context.read<SessionManager>().client,
                    apiVersion: paperlessApiVersion,
                  ),
                ),
                Provider(
                  create: (context) =>
                      paperlessProviderFactory.createServerStatsApi(
                    context.read<SessionManager>().client,
                    apiVersion: paperlessApiVersion,
                  ),
                ),
                Provider(
                  create: (context) => paperlessProviderFactory.createTasksApi(
                    context.read<SessionManager>().client,
                    apiVersion: paperlessApiVersion,
                  ),
                ),
                if (currentLocalUser.hasMultiUserSupport)
                  Provider(
                    create: (context) => PaperlessUserApiV3Impl(
                      context.read<SessionManager>().client,
                    ),
                  ),
              ],
              builder: (context, _) {
                return MultiProvider(
                  providers: [
                    Provider(
                      create: (context) {
                        final repo = LabelRepository(context.read());
                        if (currentLocalUser
                            .paperlessUser.canViewCorrespondents) {
                          repo.findAllCorrespondents();
                        }
                        if (currentLocalUser
                            .paperlessUser.canViewDocumentTypes) {
                          repo.findAllDocumentTypes();
                        }
                        if (currentLocalUser.paperlessUser.canViewTags) {
                          repo.findAllTags();
                        }
                        if (currentLocalUser
                            .paperlessUser.canViewStoragePaths) {
                          repo.findAllStoragePaths();
                        }
                        return repo;
                      },
                    ),
                    Provider(
                      create: (context) {
                        final repo = SavedViewRepository(context.read());
                        if (currentLocalUser.paperlessUser.canViewSavedViews) {
                          repo.initialize();
                        }
                        return repo;
                      },
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
                            if (currentLocalUser
                                    .paperlessUser.canViewDocuments &&
                                currentLocalUser.paperlessUser.canViewTags) {
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
                        if (currentLocalUser.hasMultiUserSupport)
                          Provider(
                            create: (context) => UserRepository(
                              context.read(),
                            )..initialize(),
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
