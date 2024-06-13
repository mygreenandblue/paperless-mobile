import 'package:dio/dio.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_api/src/extensions/dio_exception_extension.dart';
import 'package:edocs_api/src/models/custom_field_model.dart';
import 'package:edocs_api/src/modules/custom_fields/custom_fields_api.dart';
import 'package:edocs_api/src/request_utils.dart';

class CustomFieldsApiImpl implements CustomFieldsApi {
  final Dio _dio;

  const CustomFieldsApiImpl(this._dio);

  @override
  Future<CustomFieldModel> createCustomField(
      CustomFieldModel customField) async {
    try {
      final response = await _dio.post(
        "/api/custom_fields/",
        data: customField.toJson(),
        options: Options(
          validateStatus: (status) => status == 201,
        ),
      );
      return CustomFieldModel.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const EdocsApiException(
          ErrorCode.customFieldCreateFailed,
        ),
      );
    }
  }

  @override
  Future<int> deleteCustomField(CustomFieldModel customField) async {
    try {
      await _dio.delete(
        "/api/custom_fields/${customField.id}/",
        options: Options(
          validateStatus: (status) => status == 204,
        ),
      );
      return customField.id!;
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const EdocsApiException(
          ErrorCode.customFieldDeleteFailed,
        ),
      );
    }
  }

  @override
  Future<CustomFieldModel?> getCustomField(int id) {
    return getSingleResult(
      '/api/custom_fields/$id/',
      CustomFieldModel.fromJson,
      ErrorCode.customFieldLoadFailed,
      client: _dio,
    );
  }

  @override
  Future<List<CustomFieldModel>> getCustomFields() {
    return getCollection(
      '/api/custom_fields/?page=1&page_size=100000',
      CustomFieldModel.fromJson,
      ErrorCode.customFieldLoadFailed,
      client: _dio,
    );
  }
}
