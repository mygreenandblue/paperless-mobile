import 'package:paperless_api/src/models/models.dart';

abstract class PhysicalWarehouseApi {
  Future<WarehouseModel?> getWarehouse(int id);
  Future<List<WarehouseModel>> getWarehouses([Iterable<int>? ids]);
  Future<String?> createWarehouse(
      {String? name, String? type, int? parentWarehouse});
  Future<WarehouseModel> updateWarehouse(
      {String? name, String? type, int? parentWarehouse, int? id});
  Future<int> deleteWarehouse(WarehouseModel warehouseModel);
  Future<WarehouseModel?> getShelf(int id);
  Future<List<WarehouseModel>> getShelfs([Iterable<int>? ids]);
  Future<WarehouseModel?> getBriefcase(int id);
  Future<List<WarehouseModel>> getBriefcases([Iterable<int>? ids]);
  Future<PagedSearchResult<WarehouseModel>> findAll(WarehouseFilter filter);
}
