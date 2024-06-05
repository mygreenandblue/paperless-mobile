part of 'label_cubit.dart';

@freezed
class LabelState with _$LabelState {
  const factory LabelState({
    @Default({}) Map<int, Correspondent> correspondents,
    @Default({}) Map<int, DocumentType> documentTypes,
    @Default({}) Map<int, Tag> tags,
    @Default({}) Map<int, StoragePath> storagePaths,
    @Default({}) Map<int, Warehouse> warehouses,
    @Default({}) Map<int, Warehouse> shelfs,
    @Default({}) Map<int, Warehouse> boxcases,
    @Default('') String selectedShelf,
    @Default('') String selectedWarehouse,
    @Default(-1) int idShelf,
    @Default(-1) int idWarehouse,
    @Default(false) bool isLoading,
    Warehouse? warehouse,
  }) = _LabelState;
}
