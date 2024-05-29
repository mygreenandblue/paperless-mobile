import 'package:collection/collection.dart';
import 'package:paperless_api/paperless_api.dart';

extension WarehouseModelIterableExtension on Iterable<WarehouseModel> {
  Iterable<int> get ids => map((e) => e.id!);

  Iterable<WarehouseModel> withWarehousereplaced(WarehouseModel warehouse) {
    return map((e) => e.id == warehouse.id ? warehouse : e);
  }

  bool containsWarehouse(WarehouseModel warehouse) {
    return ids.contains(warehouse.id);
  }

  Iterable<WarehouseModel> withWarehouseRemoved(WarehouseModel warehouse) {
    return whereNot((element) => element.id == warehouse.id);
  }
}
