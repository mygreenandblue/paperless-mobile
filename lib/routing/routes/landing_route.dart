import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:edocs_mobile/features/landing/view/landing_page.dart';
import 'package:edocs_mobile/routing/navigation_keys.dart';

class LandingBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = landingNavigatorKey;

  const LandingBranch();
}

class LandingRoute extends GoRouteData {
  const LandingRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LandingPage();
  }
}
