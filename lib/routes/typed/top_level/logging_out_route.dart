import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/routes/navigation_keys.dart';
import 'package:paperless_mobile/routes/routes.dart';

part 'logging_out_route.g.dart';

@TypedGoRoute<LoggingOutRoute>(
  path: "/logging-out",
  name: R.loggingOut,
)
class LoggingOutRoute extends GoRouteData {
  static final $parentNavigatorKey = rootNavigatorKey;
  const LoggingOutRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      child: Scaffold(
        body: Center(
          child: Text("Logging out..."), //TODO: INTL
        ),
      ),
    );
  }
}
