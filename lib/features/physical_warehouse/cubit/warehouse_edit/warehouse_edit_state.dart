part of 'warehouse_edit_cubit.dart';

class WarehouseEditState extends WarehousePagingState {
  final List<WarehouseModel> selection;

  const WarehouseEditState({
    this.selection = const [],
    super.value = const [],
    super.filter = const WarehouseFilter(),
    super.hasLoaded = false,
    super.isLoading = false,
  });

  List<int> get selectedIds => selection.map((e) => e.id!).toList();

  WarehouseEditState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    List<PagedSearchResult<WarehouseModel>>? value,
    WarehouseFilter? filter,
    List<WarehouseModel>? selection,
    ViewType? viewType,
  }) {
    return WarehouseEditState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      value: value ?? this.value,
      filter: filter ?? this.filter,
      selection: selection ?? this.selection,
    );
  }

  @override
  List<Object?> get props => [
        selection,
        super.filter,
        super.hasLoaded,
        super.isLoading,
        super.value,
      ];

  @override
  WarehouseEditState copyWithPaged({
    bool? hasLoaded,
    bool? isLoading,
    List<PagedSearchResult<WarehouseModel>>? value,
    WarehouseFilter? filter,
  }) {
    return copyWith(
      filter: filter,
      hasLoaded: hasLoaded,
      isLoading: isLoading,
      value: value,
    );
  }
}
