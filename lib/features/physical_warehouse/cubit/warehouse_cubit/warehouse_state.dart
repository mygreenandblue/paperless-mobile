part of 'warehouse_cubit.dart';

@freezed
class WarehouseState with _$WarehouseState {
  const factory WarehouseState({
    @Default({}) Map<int, WarehouseModel> warehouses,
    @Default({}) Map<int, WarehouseModel> shelfs,
    @Default({}) Map<int, WarehouseModel> briefcases,
  }) = _WarehouseState;
}
