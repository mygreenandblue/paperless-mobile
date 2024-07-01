import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/features/folder_management/view/pages/folder_view.dart';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:edocs_mobile/features/folder_management/view/pages/folder_page.dart';
import 'package:edocs_mobile/routing/navigation_keys.dart';

class FolderBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = folderNavigatorKey;

  const FolderBranch();
}

class FolderViewRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FolderView();
  }
}

class FolderRoute extends GoRouteData {
  final int folderId;
  final String folderName;
  final Folder $extra;

  FolderRoute(
    this.$extra, {
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FolderPage(
      id: folderId,
      name: folderName,
      folder: $extra,
    );
  }
}
