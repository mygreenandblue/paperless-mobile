import 'dart:io';

import 'package:dio/dio.dart';
import 'package:paperless_api/src/extensions/dio_exception_extension.dart';
import 'package:paperless_api/src/models/paperless_api_exception.dart';
import 'package:paperless_api/src/models/saved_view_model.dart';
import 'package:paperless_api/src/request_utils.dart';

import 'paperless_saved_views_api.dart';

class PaperlessSavedViewsApiImpl implements PaperlessSavedViewsApi {
  final Dio _client;

  PaperlessSavedViewsApiImpl(this._client);

  @override
  Future<Iterable<SavedView>> findAll([Iterable<int>? ids]) async {
    final result = await getCollection(
      "/api/saved_views/",
      SavedView.fromJson,
      ErrorCode.loadSavedViewsError,
      client: _client,
    );

    return result.where((view) => ids?.contains(view.id!) ?? true);
  }

  @override
  Future<SavedView> save(SavedView view) async {
    try {
      final response = await _client.post(
        "/api/saved_views/",
        data: view.toJson(),
        options: Options(validateStatus: (status) => status == 201),
      );
      return SavedView.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.createSavedViewError),
      );
    }
  }

  @override
  Future<SavedView> update(SavedView view) async {
    try {
      final response = await _client.patch(
        "/api/saved_views/${view.id}/",
        data: view.toJson(),
        options: Options(validateStatus: (status) => status == 200),
      );
      return SavedView.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.updateSavedViewError),
      );
    }
  }

  @override
  Future<int> delete(SavedView view) async {
    try {
      await _client.delete(
        "/api/saved_views/${view.id}/",
        options: Options(validateStatus: (status) => status == 204),
      );
      return view.id!;
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.deleteSavedViewError),
      );
    }
  }

  @override
  Future<SavedView?> find(int id) {
    return getSingleResult(
      "/api/saved_views/$id/",
      SavedView.fromJson,
      ErrorCode.loadSavedViewsError,
      client: _client,
    );
  }
}
