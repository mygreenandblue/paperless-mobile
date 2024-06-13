import 'package:dio/dio.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_api/src/extensions/dio_exception_extension.dart';
import 'package:edocs_api/src/models/edocs_api_exception.dart';

class EdocsUserApiV2Impl implements EdocsUserApi {
  final Dio client;

  EdocsUserApiV2Impl(this.client);

  @override
  Future<int> findCurrentUserId() async {
    try {
      final response = await client.get(
        "/api/ui_settings/",
        options: Options(
          validateStatus: (status) => status == 200,
        ),
      );
      return response.data['user_id'];
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const EdocsApiException(ErrorCode.userNotFound),
      );
    }
  }

  @override
  Future<UserModel> findCurrentUser() async {
    try {
      final response = await client.get(
        "/api/ui_settings/",
        options: Options(validateStatus: (status) => status == 200),
      );
      return UserModelV2.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const EdocsApiException(ErrorCode.userNotFound),
      );
    }
  }
}
