import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/routes/routes.dart';

part 'logging_out_route.g.dart';

@TypedGoRoute<LogginOutRoute>(
  path: "/logging-out",
  name: R.loggingOut,
)
class LogginOutRoute extends GoRouteData {
  const LogginOutRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Text("Logging out..."),
      ),
    );
  }
}
