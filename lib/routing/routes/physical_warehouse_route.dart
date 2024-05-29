// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';

import 'package:paperless_mobile/features/physical_warehouse/view/impl/pages/add_briefcase_page.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/impl/pages/add_shelf_page.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/impl/pages/add_warehouse_page.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/impl/pages/edit_briefcase_page.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/impl/pages/edit_shelf_page.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/impl/pages/edit_warehouse_page.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/physical_warehouse_view.dart';
import 'package:paperless_mobile/routing/navigation_keys.dart';

class PhysicalWarehouseBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey =
      physicalWarehouseNavigatorKey;
  const PhysicalWarehouseBranch();
}

class PhysicalWarehouseRoute extends GoRouteData {
  final String type;
  PhysicalWarehouseRoute({
    required this.type,
  });
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PhysicalWarehouseView(
      type: type,
    );
  }
}

class EditPhysicalWarehouseRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  final WarehouseModel $extra;
  final String type;

  const EditPhysicalWarehouseRoute(this.$extra, {required this.type});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return type == 'Warehouse'
        ? EditWarehousePage(warehouseModel: $extra, type: type)
        : type == 'Shelf'
            ? EditShelfPage(warehouseModel: $extra, type: type)
            : EditBriefcasePage(warehouseModel: $extra, type: 'Boxcase');
  }
}

class CreatePhysicalWarehouseRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  final String? type;
  final String? name;

  CreatePhysicalWarehouseRoute({this.type, this.name});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return type == 'Warehouse'
        ? AddWarehousePage(type: type!)
        : type == 'Shelf'
            ? AddShelfPage(type: type!)
            : AddBriefcasePage(
                type: 'Boxcase',
                initialName: name,
              );
  }
}
