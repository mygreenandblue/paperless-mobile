import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:paperless_api/src/converters/warehouse_model_json_converter.dart';
import 'package:paperless_api/src/extensions/dio_exception_extension.dart';
import 'package:paperless_api/src/models/models.dart';
import 'package:paperless_api/src/modules/physical_warehouse_api/physical_warehouse_api.dart';
import 'package:paperless_api/src/request_utils.dart';

//Notes:
// Removed content type json header
class PhysicalWarehouseApiImpl implements PhysicalWarehouseApi {
  final Dio _client;

  PhysicalWarehouseApiImpl(this._client);

  @override
  Future<int> deleteWarehouse(WarehouseModel warehouse) async {
    assert(warehouse.id != null);

    try {
      await _client.delete(
        '/api/warehouses/${warehouse.id}/',
        options: Options(validateStatus: (status) => status == 204),
      );
      return warehouse.id!;
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(
          ErrorCode.warehouseDeleteFailed,
        ),
      );
    }
  }

  @override
  Future<WarehouseModel?> getWarehouse(int id) {
    return getSingleResult(
      "/api/warehouses/$id&type__iexact=Warehouse/",
      WarehouseModel.fromJson,
      ErrorCode.warehouseLoadFailed,
      client: _client,
    );
  }

  @override
  Future<List<WarehouseModel>> getWarehouses([Iterable<int>? ids]) async {
    final results = await getCollection(
      "/api/warehouses/?page=1&page_size=100000&type__iexact=Warehouse",
      WarehouseModel.fromJson,
      ErrorCode.storagePathLoadFailed,
      client: _client,
    );

    return results
        .where((element) => ids?.contains(element.id) ?? true)
        .toList();
  }

  @override
  Future<String?> createWarehouse(
      {String? name, String? type, int? parentWarehouse}) async {
    final formData = FormData();

    if (type != null) {
      formData.fields.add(
        MapEntry('type', type),
      );
    }

    if (name != null) {
      formData.fields.add(
        MapEntry('name', name),
      );
    }
    if (parentWarehouse != null) {
      formData.fields
          .add(MapEntry('parent_warehouse', jsonEncode(parentWarehouse)));
    }
    try {
      final response = await _client.post(
        '/api/warehouses/',
        data: formData,
        options: Options(validateStatus: (status) => status == 201),
      );
      if (response.data != "OK") {
        return response.data.toString();
      } else {
        return null;
      }
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.documentUploadFailed),
      );
    }
  }

  @override
  Future<WarehouseModel> updateWarehouse(
      {String? name, String? type, int? parentWarehouse, int? id}) async {
    final formData = FormData();

    if (type != null) {
      formData.fields.add(
        MapEntry('type', type),
      );
    }

    if (name != null) {
      formData.fields.add(
        MapEntry('name', name),
      );
    }
    if (parentWarehouse != null) {
      formData.fields
          .add(MapEntry('parent_warehouse', jsonEncode(parentWarehouse)));
    }
    assert(id != null);
    try {
      final response = await _client.patch(
        "/api/warehouses/$id/",
        data: formData,
        options: Options(validateStatus: (status) => status == 200),
      );
      return WarehouseModel.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.documentUpdateFailed),
      );
    }
  }

  @override
  Future<WarehouseModel?> getBriefcase(int id) {
    return getSingleResult(
      "/api/warehouses/$id&type__iexact=Boxcase",
      WarehouseModel.fromJson,
      ErrorCode.warehouseLoadFailed,
      client: _client,
    );
  }

  @override
  Future<List<WarehouseModel>> getBriefcases([Iterable<int>? ids]) async {
    final results = await getCollection(
      "/api/warehouses/?page=1&page_size=100000&type__iexact=Boxcase",
      WarehouseModel.fromJson,
      ErrorCode.storagePathLoadFailed,
      client: _client,
    );

    return results
        .where((element) => ids?.contains(element.id) ?? true)
        .toList();
  }

  @override
  Future<WarehouseModel?> getShelf(int id) {
    return getSingleResult(
      "/api/warehouses/$id&type__iexact=Shelf/",
      WarehouseModel.fromJson,
      ErrorCode.warehouseLoadFailed,
      client: _client,
    );
  }

  @override
  Future<List<WarehouseModel>> getShelfs([Iterable<int>? ids]) async {
    final results = await getCollection(
      "/api/warehouses/?page=1&page_size=100000&type__iexact=Shelf",
      WarehouseModel.fromJson,
      ErrorCode.storagePathLoadFailed,
      client: _client,
    );

    return results
        .where((element) => ids?.contains(element.id) ?? true)
        .toList();
  }

  @override
  Future<PagedSearchResult<WarehouseModel>> findAll(
      WarehouseFilter filter) async {
    final filterParams = filter.toQueryParameters()
      ..addAll({'truncate_content': "true"});
    try {
      final response = await _client.get(
        "/api/warehouses/",
        queryParameters: filterParams,
        options: Options(validateStatus: (status) => status == 200),
      );
      return compute(
        PagedSearchResult.fromJsonSingleParam,
        PagedSearchResultJsonSerializer<WarehouseModel>(
          response.data,
          WarehouseModelJsonConverter(),
        ),
      );
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: PaperlessApiException(
          ErrorCode.documentLoadFailed,
          details: exception.message,
        ),
      );
    }
  }
}
