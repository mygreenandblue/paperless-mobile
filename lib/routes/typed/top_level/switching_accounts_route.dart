import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/features/settings/view/pages/switching_accounts_page.dart';
import 'package:paperless_mobile/routes/routes.dart';

part 'switching_accounts_route.g.dart';

@TypedGoRoute<SwitchingAccountsRoute>(
  path: '/switching-accounts',
  name: R.switchingAccounts,
)
class SwitchingAccountsRoute extends GoRouteData {
  const SwitchingAccountsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SwitchingAccountsPage();
  }
}
