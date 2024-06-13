import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/routing/navigation_keys.dart';
import 'package:edocs_mobile/routing/routes.dart';

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
    return NoTransitionPage(
      child: Scaffold(
        body: Center(
          child: Text(S.of(context)!.loggingOut),
        ),
      ),
    );
  }
}
