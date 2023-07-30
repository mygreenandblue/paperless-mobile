import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/features/inbox/view/pages/inbox_page.dart';
import 'package:paperless_mobile/routes/routes.dart';

part 'inbox_route.g.dart';

@TypedGoRoute<InboxRoute>(
  path: "/inbox",
  name: R.inbox,
)
class InboxRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InboxPage();
  }
}
