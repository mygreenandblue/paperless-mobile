// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:edocs_api/edocs_api.dart';

import 'package:edocs_mobile/features/labels/view/pages/physical_warehouse_page.dart';

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
