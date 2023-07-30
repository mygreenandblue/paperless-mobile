import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/view/login_page.dart';
import 'package:paperless_mobile/routes/routes.dart';

part 'login_route.g.dart';

@TypedGoRoute<LoginRoute>(
  path: "/login",
  name: R.login,
)
class LoginRoute extends GoRouteData {
  const LoginRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (context.read<AuthenticationCubit>().state.isAuthenticated) {
      return "/landing";
    }
    return null;
  }
}
