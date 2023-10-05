import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/routes/routes.dart';

part 'logging_out_route.g.dart';

@TypedGoRoute<LoggingOutRoute>(
  path: "/logging-out",
  name: R.loggingOut,
)
class LoggingOutRoute extends GoRouteData {
  const LoggingOutRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Text("Logging out..."),
      ),
    );
  }
}
