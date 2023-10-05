import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/document_bulk_action/cubit/document_bulk_action_cubit.dart';
import 'package:paperless_mobile/features/document_bulk_action/view/widgets/fullscreen_bulk_edit_label_page.dart';
import 'package:paperless_mobile/features/document_bulk_action/view/widgets/fullscreen_bulk_edit_tags_widget.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';
import 'package:paperless_mobile/features/document_edit/cubit/document_edit_cubit.dart';
import 'package:paperless_mobile/features/document_edit/view/document_edit_page.dart';
import 'package:paperless_mobile/features/documents/view/pages/document_view.dart';
import 'package:paperless_mobile/features/documents/view/pages/documents_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routes/navigation_keys.dart';
import 'package:paperless_mobile/routes/routes.dart';
import 'package:paperless_mobile/theme.dart';

part 'documents_route.g.dart';

class DocumentsBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = documentsNavigatorKey;
  const DocumentsBranch();
}

@TypedGoRoute<DocumentsRoute>(
  path: "/documents",
  name: R.documents,
  routes: [
    TypedGoRoute<EditDocumentRoute>(
      path: "edit",
      name: R.editDocument,
    ),
    TypedGoRoute<DocumentDetailsRoute>(
      path: "details",
      name: R.documentDetails,
    ),
    TypedGoRoute<DocumentPreviewRoute>(
      path: "preview",
      name: R.documentPreview,
    ),
    TypedGoRoute<BulkEditDocumentsRoute>(
      path: "bulk-edit",
      name: R.bulkEditDocuments,
    ),
  ],
)
class DocumentsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DocumentsPage();
  }
}

class DocumentDetailsRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  final bool isLabelClickable;
  final DocumentModel $extra;
  final String? queryString;

  const DocumentDetailsRoute({
    required this.$extra,
    this.isLabelClickable = true,
    this.queryString,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => DocumentDetailsCubit(
        context.read(),
        context.read(),
        context.read(),
        context.read(),
        initialDocument: $extra,
      ),
      lazy: false,
      child: DocumentDetailsPage(
        isLabelClickable: isLabelClickable,
        titleAndContentQueryString: queryString,
      ),
    );
  }
}

class EditDocumentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  final DocumentModel $extra;

  const EditDocumentRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: buildOverlayStyle(
        theme,
        systemNavigationBarColor: theme.colorScheme.background,
      ),
      child: BlocProvider(
        create: (context) => DocumentEditCubit(
          context.read(),
          context.read(),
          context.read(),
          document: $extra,
        )..loadFieldSuggestions(),
        child: const DocumentEditPage(),
      ),
    );
  }
}

class DocumentPreviewRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  final DocumentModel $extra;
  final String? title;

  const DocumentPreviewRoute({
    required this.$extra,
    this.title,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DocumentView(
      documentBytes: context.read<PaperlessDocumentsApi>().download($extra),
      title: title ?? $extra.title,
    );
  }
}

class BulkEditExtraWrapper {
  final List<DocumentModel> selection;
  final LabelType type;

  const BulkEditExtraWrapper(this.selection, this.type);
}

class BulkEditDocumentsRoute extends GoRouteData {
  /// Selection
  final BulkEditExtraWrapper $extra;
  BulkEditDocumentsRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => DocumentBulkActionCubit(
        context.read(),
        context.read(),
        context.read(),
        selection: $extra.selection,
      ),
      child: BlocBuilder<DocumentBulkActionCubit, DocumentBulkActionState>(
        builder: (context, state) {
          return switch ($extra.type) {
            LabelType.tag => const FullscreenBulkEditTagsWidget(),
            _ => FullscreenBulkEditLabelPage(
                options: switch ($extra.type) {
                  LabelType.correspondent => state.correspondents,
                  LabelType.documentType => state.documentTypes,
                  LabelType.storagePath => state.storagePaths,
                  _ => throw Exception("Parameter not allowed here."),
                },
                selection: state.selection,
                labelMapper: (document) {
                  return switch ($extra.type) {
                    LabelType.correspondent => document.correspondent,
                    LabelType.documentType => document.documentType,
                    LabelType.storagePath => document.storagePath,
                    _ => throw Exception("Parameter not allowed here."),
                  };
                },
                leadingIcon: switch ($extra.type) {
                  LabelType.correspondent => const Icon(Icons.person_outline),
                  LabelType.documentType =>
                    const Icon(Icons.description_outlined),
                  LabelType.storagePath => const Icon(Icons.folder_outlined),
                  _ => throw Exception("Parameter not allowed here."),
                },
                hintText: S.of(context)!.startTyping,
                onSubmit: switch ($extra.type) {
                  LabelType.correspondent => context
                      .read<DocumentBulkActionCubit>()
                      .bulkModifyCorrespondent,
                  LabelType.documentType => context
                      .read<DocumentBulkActionCubit>()
                      .bulkModifyDocumentType,
                  LabelType.storagePath => context
                      .read<DocumentBulkActionCubit>()
                      .bulkModifyStoragePath,
                  _ => throw Exception("Parameter not allowed here."),
                },
                assignMessageBuilder: (int count, String name) {
                  return switch ($extra.type) {
                    LabelType.correspondent => S
                        .of(context)!
                        .bulkEditCorrespondentAssignMessage(name, count),
                    LabelType.documentType => S
                        .of(context)!
                        .bulkEditDocumentTypeAssignMessage(count, name),
                    LabelType.storagePath => S
                        .of(context)!
                        .bulkEditDocumentTypeAssignMessage(count, name),
                    _ => throw Exception("Parameter not allowed here."),
                  };
                },
                removeMessageBuilder: (int count) {
                  return switch ($extra.type) {
                    LabelType.correspondent =>
                      S.of(context)!.bulkEditCorrespondentRemoveMessage(count),
                    LabelType.documentType =>
                      S.of(context)!.bulkEditDocumentTypeRemoveMessage(count),
                    LabelType.storagePath =>
                      S.of(context)!.bulkEditStoragePathRemoveMessage(count),
                    _ => throw Exception("Parameter not allowed here."),
                  };
                },
              ),
          };
        },
      ),
    );
  }
}
