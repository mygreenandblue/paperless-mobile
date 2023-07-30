import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/features/settings/view/settings_page.dart';
import 'package:paperless_mobile/routes/routes.dart';

part 'settings_route.g.dart';

@TypedGoRoute<SettingsRoute>(
  path: "/settings",
  name: R.settings,
)
class SettingsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}
