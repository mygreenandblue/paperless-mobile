import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/features/changelogs/view/changelog_dialog.dart';
import 'package:paperless_mobile/routes/navigation_keys.dart';
import 'package:paperless_mobile/routes/utils/dialog_page.dart';

part 'changelog_route.g.dart';

@TypedGoRoute<ChangelogRoute>(path: '/changelogs')
class ChangelogRoute extends GoRouteData {
  static final $parentNavigatorKey = rootNavigatorKey;
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return DialogPage(
      builder: (context) => const ChangelogDialog(),
    );
  }
}
