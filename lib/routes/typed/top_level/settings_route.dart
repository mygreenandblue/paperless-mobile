import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/features/settings/view/settings_page.dart';
import 'package:paperless_mobile/routes/navigation_keys.dart';
import 'package:paperless_mobile/routes/routes.dart';
import 'package:paperless_mobile/theme.dart';

part 'settings_route.g.dart';

@TypedGoRoute<SettingsRoute>(
  path: "/settings",
  name: R.settings,
)
class SettingsRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = outerShellNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: buildOverlayStyle(
        Theme.of(context),
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
      ),
      child: const SettingsPage(),
    );
  }
}
