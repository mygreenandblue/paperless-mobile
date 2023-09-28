import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/user_repository.dart';
import 'package:paperless_mobile/features/document_bulk_action/cubit/document_bulk_action_cubit.dart';
import 'package:paperless_mobile/features/document_bulk_action/view/widgets/fullscreen_bulk_edit_label_page.dart';
import 'package:paperless_mobile/features/document_bulk_action/view/widgets/fullscreen_bulk_edit_tags_widget.dart';
import 'package:paperless_mobile/features/home/view/model/api_version.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:paperless_mobile/features/saved_view_details/cubit/saved_view_details_cubit.dart';
import 'package:paperless_mobile/features/saved_view_details/view/saved_view_details_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Future<void> pushSavedViewDetailsRoute(
  BuildContext context, {
  required SavedView savedView,
}) {
  final apiVersion = context.read<ApiVersion>();
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MultiProvider(
        providers: [
          Provider.value(value: apiVersion),
          if (context.watch<LocalUserAccount>().hasMultiUserSupport)
            Provider.value(value: context.read<UserRepository>()),
          Provider.value(value: context.read<LabelRepository>()),
          Provider.value(value: context.read<DocumentChangedNotifier>()),
          Provider.value(value: context.read<PaperlessDocumentsApi>()),
          Provider.value(value: context.read<CacheManager>()),
          Provider.value(value: context.read<ConnectivityCubit>()),
        ],
        builder: (_, child) {
          return BlocProvider(
            create: (context) => SavedViewDetailsCubit(
              context.read(),
              context.read(),
              context.read(),
              LocalUserAppState.current,
              context.read(),
              savedView: savedView,
            ),
            child: SavedViewDetailsPage(
              onDelete: context.read<SavedViewCubit>().remove,
            ),
          );
        },
      ),
    ),
  );
}

Future<void> pushBulkEditCorrespondentRoute(
  BuildContext context, {
  required List<DocumentModel> selection,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MultiProvider(
        providers: [
          ..._getRequiredBulkEditProviders(context),
        ],
        builder: (_, __) => BlocProvider(
          create: (_) => DocumentBulkActionCubit(
            context.read(),
            context.read(),
            context.read(),
            selection: selection,
          ),
          child: BlocBuilder<DocumentBulkActionCubit, DocumentBulkActionState>(
            builder: (context, state) {
              return FullscreenBulkEditLabelPage(
                options: state.correspondents,
                selection: state.selection,
                labelMapper: (document) => document.correspondent,
                leadingIcon: const Icon(Icons.person_outline),
                hintText: S.of(context)!.startTyping,
                onSubmit: context
                    .read<DocumentBulkActionCubit>()
                    .bulkModifyCorrespondent,
                assignMessageBuilder: (int count, String name) {
                  return S.of(context)!.bulkEditCorrespondentAssignMessage(
                        name,
                        count,
                      );
                },
                removeMessageBuilder: (int count) {
                  return S
                      .of(context)!
                      .bulkEditCorrespondentRemoveMessage(count);
                },
              );
            },
          ),
        ),
      ),
    ),
  );
}

Future<void> pushBulkEditStoragePathRoute(
  BuildContext context, {
  required List<DocumentModel> selection,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MultiProvider(
        providers: [
          ..._getRequiredBulkEditProviders(context),
        ],
        builder: (_, __) => BlocProvider(
          create: (_) => DocumentBulkActionCubit(
            context.read(),
            context.read(),
            context.read(),
            selection: selection,
          ),
          child: BlocBuilder<DocumentBulkActionCubit, DocumentBulkActionState>(
            builder: (context, state) {
              return FullscreenBulkEditLabelPage(
                options: state.storagePaths,
                selection: state.selection,
                labelMapper: (document) => document.storagePath,
                leadingIcon: const Icon(Icons.folder_outlined),
                hintText: S.of(context)!.startTyping,
                onSubmit: context
                    .read<DocumentBulkActionCubit>()
                    .bulkModifyStoragePath,
                assignMessageBuilder: (int count, String name) {
                  return S.of(context)!.bulkEditStoragePathAssignMessage(
                        count,
                        name,
                      );
                },
                removeMessageBuilder: (int count) {
                  return S.of(context)!.bulkEditStoragePathRemoveMessage(count);
                },
              );
            },
          ),
        ),
      ),
    ),
  );
}

Future<void> pushBulkEditTagsRoute(
  BuildContext context, {
  required List<DocumentModel> selection,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MultiProvider(
        providers: [
          ..._getRequiredBulkEditProviders(context),
        ],
        builder: (_, __) => BlocProvider(
          create: (_) => DocumentBulkActionCubit(
            context.read(),
            context.read(),
            context.read(),
            selection: selection,
          ),
          child: Builder(builder: (context) {
            return const FullscreenBulkEditTagsWidget();
          }),
        ),
      ),
    ),
  );
}

Future<void> pushBulkEditDocumentTypeRoute(BuildContext context,
    {required List<DocumentModel> selection}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MultiProvider(
        providers: [
          ..._getRequiredBulkEditProviders(context),
        ],
        builder: (_, __) => BlocProvider(
          create: (_) => DocumentBulkActionCubit(
            context.read(),
            context.read(),
            context.read(),
            selection: selection,
          ),
          child: BlocBuilder<DocumentBulkActionCubit, DocumentBulkActionState>(
            builder: (context, state) {
              return FullscreenBulkEditLabelPage(
                options: state.documentTypes,
                selection: state.selection,
                labelMapper: (document) => document.documentType,
                leadingIcon: const Icon(Icons.description_outlined),
                hintText: S.of(context)!.startTyping,
                onSubmit: context
                    .read<DocumentBulkActionCubit>()
                    .bulkModifyDocumentType,
                assignMessageBuilder: (int count, String name) {
                  return S.of(context)!.bulkEditDocumentTypeAssignMessage(
                        count,
                        name,
                      );
                },
                removeMessageBuilder: (int count) {
                  return S
                      .of(context)!
                      .bulkEditDocumentTypeRemoveMessage(count);
                },
              );
            },
          ),
        ),
      ),
    ),
  );
}

List<Provider> _getRequiredBulkEditProviders(BuildContext context) {
  return [
    Provider.value(value: context.read<PaperlessDocumentsApi>()),
    Provider.value(value: context.read<LabelRepository>()),
    Provider.value(value: context.read<DocumentChangedNotifier>()),
  ];
}
