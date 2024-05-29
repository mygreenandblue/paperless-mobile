import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:paperless_api/paperless_api.dart';

class WarehouseRepository extends ChangeNotifier {
  final PhysicalWarehouseApi _api;

  Map<int, WarehouseModel> warehouses = {};
  Map<int, WarehouseModel> shelfs = {};
  Map<int, WarehouseModel> briefcases = {};

  WarehouseRepository(this._api);

  // Resets the repository to its initial state and loads all data from the API.
  Future<void> initialize({
    required bool loadWarehouse,
    required bool loadShelf,
    required bool loadBriefcase,
  }) async {
    warehouses = {};
    shelfs = {};
    briefcases = {};
    await Future.wait([
      findAllWarehouses(),
      findAllShelfs(),
      findAllBriefcases(),
    ]);
  }

  Future<int> deleteWarehouse(WarehouseModel warehouse, String? type) async {
    await _api.deleteWarehouse(warehouse);
    type == 'Warehouse'
        ? warehouses.remove(warehouse.id)
        : type == 'Shelf'
            ? shelfs.remove(warehouse.id)
            : briefcases.remove(warehouse.id);

    notifyListeners();
    return warehouse.id!;
  }

  Future<WarehouseModel?> findWarehouse(int id) async {
    final warehouse = await _api.getWarehouse(id);
    if (warehouse != null) {
      warehouses = {...warehouses, id: warehouse};
      notifyListeners();
      return warehouse;
    }
    return null;
  }

  Future<Iterable<WarehouseModel>> findAllWarehouses() async {
    final data = await _api.getWarehouses();
    warehouses = {for (var element in data) element.id!: element};
    notifyListeners();
    return data;
  }

  Future<WarehouseModel?> findShelf(int id) async {
    final warehouse = await _api.getShelf(id);
    if (warehouse != null) {
      shelfs = {...shelfs, id: warehouse};
      notifyListeners();
      return warehouse;
    }
    return null;
  }

  Future<Iterable<WarehouseModel>> findAllShelfs() async {
    final data = await _api.getShelfs();
    shelfs = {for (var element in data) element.id!: element};
    notifyListeners();
    return data;
  }

  Future<WarehouseModel?> findBriefcase(int id) async {
    final warehouse = await _api.getBriefcase(id);
    if (warehouse != null) {
      briefcases = {...briefcases, id: warehouse};
      notifyListeners();
      return warehouse;
    }
    return null;
  }

  Future<Iterable<WarehouseModel>> findAllBriefcases() async {
    final data = await _api.getBriefcases();
    briefcases = {for (var element in data) element.id!: element};
    notifyListeners();
    return data;
  }
}
