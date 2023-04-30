import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/server_information_cubit.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/core/factory/paperless_api_factory.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/core/service/dio_file_service.dart';
import 'package:paperless_mobile/features/document_scan/cubit/document_scanner_cubit.dart';
import 'package:paperless_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:paperless_mobile/features/home/view/home_page.dart';
import 'package:paperless_mobile/features/inbox/cubit/inbox_cubit.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/features/tasks/cubit/task_status_cubit.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatelessWidget {
  final String localUserId;
  final int paperlessApiVersion;
  final PaperlessApiFactory paperlessProviderFactory;

  const HomeRoute({
    super.key,
    required this.paperlessApiVersion,
    required this.paperlessProviderFactory,
    required this.localUserId,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        final currentLocalUserId = settings.currentLoggedInUser!;
        return MultiProvider(
          providers: [
            Provider<CacheManager>(
              create: (context) => CacheManager(
                Config(
                  localUserId,
                  fileService: DioFileService(context.read<SessionManager>().client),
                ),
              ),
            ),
            ProxyProvider<SessionManager, PaperlessDocumentsApi>(
              update: (context, value, previous) => paperlessProviderFactory.createDocumentsApi(
                value.client,
                apiVersion: paperlessApiVersion,
              ),
            ),
            ProxyProvider<SessionManager, PaperlessLabelsApi>(
              update: (context, value, previous) => paperlessProviderFactory.createLabelsApi(
                value.client,
                apiVersion: paperlessApiVersion,
              ),
            ),
            ProxyProvider<SessionManager, PaperlessSavedViewsApi>(
              update: (context, value, previous) => paperlessProviderFactory.createSavedViewsApi(
                value.client,
                apiVersion: paperlessApiVersion,
              ),
            ),
            ProxyProvider<SessionManager, PaperlessServerStatsApi>(
              update: (context, value, previous) => paperlessProviderFactory.createServerStatsApi(
                value.client,
                apiVersion: paperlessApiVersion,
              ),
            ),
            ProxyProvider<SessionManager, PaperlessTasksApi>(
              update: (context, value, previous) => paperlessProviderFactory.createTasksApi(
                value.client,
                apiVersion: paperlessApiVersion,
              ),
            ),
          ],
          builder: (context, child) {
            return MultiProvider(
              providers: [
                ProxyProvider<PaperlessLabelsApi, LabelRepository>(
                  update: (context, value, previous) => LabelRepository(value)..initialize(),
                ),
                ProxyProvider<PaperlessSavedViewsApi, SavedViewRepository>(
                  update: (context, value, previous) => SavedViewRepository(value)..initialize(),
                ),
              ],
              builder: (context, child) {
                return MultiBlocProvider(
                  providers: [
                    ProxyProvider3<PaperlessDocumentsApi, DocumentChangedNotifier, LabelRepository,
                        DocumentsCubit>(
                      update: (context, docApi, notifier, labelRepo, previous) => DocumentsCubit(
                        docApi,
                        notifier,
                        labelRepo,
                        Hive.box<LocalUserAppState>(HiveBoxes.localUserAppState)
                            .get(currentLocalUserId)!,
                      )..reload(),
                    ),
                    Provider(create: (context) => DocumentScannerCubit()),
                    ProxyProvider4<PaperlessDocumentsApi, PaperlessServerStatsApi, LabelRepository,
                        DocumentChangedNotifier, InboxCubit>(
                      update: (context, docApi, statsApi, labelRepo, notifier, previous) =>
                          InboxCubit(
                        docApi,
                        statsApi,
                        labelRepo,
                        notifier,
                      )..initialize(),
                    ),
                    ProxyProvider2<SavedViewRepository, LabelRepository, SavedViewCubit>(
                      update: (context, savedViewRepo, labelRepo, previous) => SavedViewCubit(
                        savedViewRepo,
                        labelRepo,
                      )..initialize(),
                    ),
                    ProxyProvider<PaperlessServerStatsApi, ServerInformationCubit>(
                      update: (context, value, previous) => ServerInformationCubit(value),
                    ),
                    ProxyProvider<LabelRepository, LabelCubit>(
                      update: (context, value, previous) => LabelCubit(value),
                    ),
                  ],
                  child: const HomePage(),
                );
              },
            );
          },
        );
      },
    );
  }
}
