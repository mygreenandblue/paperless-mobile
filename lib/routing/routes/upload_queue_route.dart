import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:edocs_mobile/features/sharing/view/consumption_queue_view.dart';
import 'package:edocs_mobile/routing/navigation_keys.dart';
import 'package:edocs_mobile/routing/routes.dart';

class UploadQueueRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConsumptionQueueView();
  }
}
