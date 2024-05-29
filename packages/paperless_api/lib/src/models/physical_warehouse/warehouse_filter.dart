import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:paperless_api/paperless_api.dart';

part 'warehouse_filter.g.dart';

@HiveType(typeId: PaperlessApiHiveTypeIds.physicalWarehouseFilter)
class WarehouseFilter extends Equatable {
  static const WarehouseFilter initial = WarehouseFilter();

  static const WarehouseFilter latestWarehouse = WarehouseFilter(
    type: 'Warehouse',
    pageSize: 1,
    page: 1,
  );

  @HiveField(0)
  final int pageSize;

  @HiveField(1)
  final int page;

  @HiveField(2)
  final String? type;

  @HiveField(3)
  final TextQuery query;

  @HiveField(4)
  final IdQueryParameter warehousesId;

  const WarehouseFilter({
    this.type = 'Warehouse',
    this.page = 1,
    this.pageSize = 25,
    this.query = const TextQuery(),
    this.warehousesId = const UnsetIdQueryParameter(),
  });

  Map<String, dynamic> toQueryParameters() {
    List<MapEntry<String, dynamic>> params = [
      MapEntry('page', '$page'),
      MapEntry('type__iexact', '$type'),
      MapEntry('page_size', '$pageSize'),
      ...query.toQueryParameter().entries,
      ...warehousesId.toQueryParameter('parent_warehouse').entries,
    ];

    // Reverse ordering can also be encoded using &reverse=1
    // Merge query params
    final queryParams = groupBy(params, (e) => e.key).map(
      (key, entries) => MapEntry(
        key,
        entries.length == 1
            ? entries.first.value
            : entries.map((e) => e.value).join(","),
      ),
    );
    return queryParams;
  }

  // @override
  // String toString() => toQueryParameters().toString();

  WarehouseFilter copyWith({
    int? pageSize,
    int? page,
    String? type,
    TextQuery? query,
    IdQueryParameter? warehousesId,
  }) {
    final newFilter = WarehouseFilter(
      pageSize: pageSize ?? this.pageSize,
      page: page ?? this.page,
      type: type ?? this.type,
      query: query ?? this.query,
      warehousesId: warehousesId ?? this.warehousesId,
    );
    if (query?.queryType != QueryType.extended) {
      //Prevents infinite recursion
      return newFilter.copyWith(
        query: newFilter.query.copyWith(queryType: QueryType.extended),
      );
    }
    return newFilter;
  }

  ///
  /// Checks whether the properties of [warehouse] match the current filter criteria.
  ///
  bool matches(WarehouseModel warehouse) {
    return query.matches(
          title: warehouse.name!,
        ) &&
        warehousesId.matches(warehouse.parentWarehouse!.id);
  }

  int get appliedFiltersCount => [
        switch (warehousesId) {
          UnsetIdQueryParameter() => 0,
          _ => 1,
        },
        (query.queryText?.isNotEmpty ?? false) ? 1 : 0,
      ].fold(0, (previousValue, element) => previousValue + element);

  @override
  List<Object?> get props => [pageSize, page, type, query, warehousesId];
}
