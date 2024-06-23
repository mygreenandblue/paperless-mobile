import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:edocs_mobile/features/document_scan/view/scanner_page.dart';
import 'package:edocs_mobile/features/document_upload/cubit/document_upload_cubit.dart';
import 'package:edocs_mobile/features/document_upload/view/document_upload_preparation_page.dart';
import 'package:edocs_mobile/routing/navigation_keys.dart';

class ScannerBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = scannerNavigatorKey;

  const ScannerBranch();
}

class ScannerRoute extends GoRouteData {
  const ScannerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ScannerPage();
  }
}

class DocumentUploadRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;
  final FutureOr<Uint8List> $extra;
  final String? title;
  final String? filename;
  final String? fileExtension;
  final int? initFolderID;

  const DocumentUploadRoute({
    required this.$extra,
    this.title,
    this.filename,
    this.fileExtension,
    this.initFolderID,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => DocumentUploadCubit(
        context.read(),
        context.read(),
        context.read(),
        context.read(),
      ),
      child: DocumentUploadPreparationPage(
        title: title,
        fileExtension: fileExtension,
        filename: filename,
        fileBytes: $extra,
        initFolderId: initFolderID,
      ),
    );
  }
}
