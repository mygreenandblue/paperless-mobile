import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';
import 'package:paperless_mobile/features/document_edit/cubit/document_edit_cubit.dart';
import 'package:paperless_mobile/features/document_edit/view/document_edit_page.dart';
import 'package:paperless_mobile/features/documents/view/pages/document_view.dart';
import 'package:paperless_mobile/features/documents/view/pages/documents_page.dart';
import 'package:paperless_mobile/routes/navigation_keys.dart';
import 'package:paperless_mobile/routes/routes.dart';

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
    )
  ],
)
class DocumentsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DocumentsPage();
  }
}

class DocumentDetailsRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

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
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  final DocumentModel $extra;

  const EditDocumentRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (context) => DocumentEditCubit(
        context.read(),
        context.read(),
        context.read(),
        document: $extra,
      )..loadFieldSuggestions(),
      child: const DocumentEditPage(),
    );
  }
}

class DocumentPreviewRoute extends GoRouteData {
  final DocumentModel $extra;
  const DocumentPreviewRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DocumentView(
      documentBytes: context.read<PaperlessDocumentsApi>().download($extra),
    );
  }
}
