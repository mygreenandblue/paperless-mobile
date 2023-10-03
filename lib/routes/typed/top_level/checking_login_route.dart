import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/routes/routes.dart';

part 'checking_login_route.g.dart';

@TypedGoRoute<CheckingLoginRoute>(
  path: "/checking-login",
  name: R.checkingLogin,
)
class CheckingLoginRoute extends GoRouteData {
  const CheckingLoginRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Text("Logging in..."),
      ),
    );
  }
}
