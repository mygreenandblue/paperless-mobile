import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
import 'package:paperless_mobile/features/home/view/widget/verify_identity_page.dart';
import 'package:paperless_mobile/routes/routes.dart';

part 'verify_identity_route.g.dart';

@TypedGoRoute<VerifyIdentityRoute>(
  path: '/verify-identity',
  name: R.verifyIdentity,
)
class VerifyIdentityRoute extends GoRouteData {
  const VerifyIdentityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const VerifyIdentityPage();
  }
}
