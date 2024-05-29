// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/paperless_api.dart';

import 'package:paperless_mobile/core/bloc/transient_error.dart';
import 'package:paperless_mobile/core/repository/warehouse_repository.dart';
import 'package:paperless_mobile/features/tasks/model/pending_tasks_notifier.dart';

part 'warehouse_cubit.freezed.dart';
part 'warehouse_state.dart';

class WarehouseCubit extends Cubit<WarehouseState> {
  final PhysicalWarehouseApi _warehouseApi;
  final WarehouseRepository warehouseRepository;
  final PendingTasksNotifier _tasksNotifier;

  WarehouseCubit(
    this._warehouseApi,
    this.warehouseRepository,
    this._tasksNotifier,
  ) : super(const WarehouseState()) {
    warehouseRepository.addListener(_updateStateListener);
  }

  void _updateStateListener() {
    emit(state.copyWith(
      warehouses: warehouseRepository.warehouses,
      shelfs: warehouseRepository.shelfs,
      briefcases: warehouseRepository.briefcases,
    ));
  }

  Future<void> reload({
    required bool loadWarehouse,
    required bool loadShelf,
    required bool loadBriefcase,
  }) {
    return warehouseRepository.initialize(
      loadWarehouse: loadWarehouse,
      loadShelf: loadShelf,
      loadBriefcase: loadBriefcase,
    );
  }

  Future<String?> addWarehouse({
    required String name,
    String? type,
    int? parentWarehouse,
  }) async {
    try {
      final taskId = await _warehouseApi.createWarehouse(
        type: type,
        name: name,
        parentWarehouse: parentWarehouse,
      );

      // if (taskId != null) {
      //   _tasksNotifier.listenToTaskChanges(taskId);
      // }
      type == 'Warehouse'
          ? warehouseRepository.findAllWarehouses()
          : type == 'Shelf'
              ? warehouseRepository.findAllShelfs()
              : warehouseRepository.findAllBriefcases();
      return taskId;
    } on PaperlessApiException catch (error) {
      addError(TransientPaperlessApiError(
        code: error.code,
        details: error.details,
      ));
    }
    return null;
  }

  Future<void> reloadWarehouse() {
    return warehouseRepository.findAllWarehouses();
  }

  Future<void> reloadShelf() {
    return warehouseRepository.findAllShelfs();
  }

  Future<void> reloadBriefcase() {
    return warehouseRepository.findAllBriefcases();
  }

  Future<void> removeWarehouse(WarehouseModel item, String? type) async {
    assert(item.id != null);
    final warehouse = type == 'Warehouse'
        ? warehouseRepository.warehouses
        : type == 'Shelf'
            ? warehouseRepository.shelfs
            : warehouseRepository.briefcases;
    if (warehouse.containsKey(item.id)) {
      await warehouseRepository.deleteWarehouse(item, type);
    }
  }

  @override
  Future<void> close() {
    warehouseRepository.removeListener(_updateStateListener);
    return super.close();
  }
}
