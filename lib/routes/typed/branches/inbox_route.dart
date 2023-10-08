import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/features/inbox/view/pages/inbox_page.dart';
import 'package:paperless_mobile/routes/navigation_keys.dart';

class InboxBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = inboxNavigatorKey;

  const InboxBranch();
}

class InboxRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InboxPage();
  }
}
