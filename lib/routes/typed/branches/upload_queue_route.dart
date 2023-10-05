import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/features/sharing/view/consumption_queue_view.dart';
import 'package:paperless_mobile/routes/navigation_keys.dart';
import 'package:paperless_mobile/routes/routes.dart';

part 'upload_queue_route.g.dart';

@TypedGoRoute<UploadQueueRoute>(
  path: "/upload-queue",
  name: R.uploadQueue,
)
class UploadQueueRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConsumptionQueueView();
  }
}
