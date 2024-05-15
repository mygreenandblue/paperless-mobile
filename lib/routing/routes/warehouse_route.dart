// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:paperless_mobile/features/physical_warehouse/view/pages/create_warehouse_page.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/warehouse_view.dart';
import 'package:paperless_mobile/routing/navigation_keys.dart';
import 'package:paperless_mobile/theme.dart';

class WarehouseRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: buildOverlayStyle(
        Theme.of(context),
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
      ),
      child: const WarehouseView(),
    );
  }
}

class CreateWarehouseRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;
  final String? action;
  final String? name;
  CreateWarehouseRoute({
    this.action,
    this.name,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateWarehousePage(
      action: action!,
      name: name,
    );
  }
}
