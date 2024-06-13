import 'dart:io';

import 'package:dio/dio.dart';
import 'package:edocs_api/src/extensions/dio_exception_extension.dart';
import 'package:edocs_api/src/models/edocs_api_exception.dart';
import 'package:edocs_api/src/models/saved_view_model.dart';
import 'package:edocs_api/src/request_utils.dart';

import 'edocs_saved_views_api.dart';

class EdocsSavedViewsApiImpl implements EdocsSavedViewsApi {
  final Dio _client;

  EdocsSavedViewsApiImpl(this._client);

  @override
  Future<Iterable<SavedView>> findAll([Iterable<int>? ids]) async {
    final result = await getCollection(
      "/api/saved_views/?page_size=100000",
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
        orElse: const EdocsApiException(ErrorCode.createSavedViewError),
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
        orElse: const EdocsApiException(ErrorCode.updateSavedViewError),
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
        orElse: const EdocsApiException(ErrorCode.deleteSavedViewError),
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
