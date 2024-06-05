// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';

import 'package:paperless_mobile/features/labels/view/pages/physical_warehouse_page.dart';

import 'package:paperless_mobile/routing/navigation_keys.dart';

class PhysicalWarehouseBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey =
      physicalWarehouseNavigatorKey;
  const PhysicalWarehouseBranch();
}

class PhysicalWarehouseRoute extends GoRouteData {
  final String type;
  final String initialName;
  final Warehouse $extra;
  PhysicalWarehouseRoute(this.$extra,
      {required this.type, required this.initialName});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PhysicalWarehouseView(
      warehouse: $extra,
      type: type,
      name: initialName,
    );
  }
}
