import 'package:dio/dio.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_api/src/modules/user_api/paperless_user_api.dart';
import 'package:paperless_api/src/modules/user_api/paperless_user_api_v3.dart';

class PaperlessUserApiV3Impl implements PaperlessUserApi, PaperlessUserApiV3 {
  final Dio dio;

  PaperlessUserApiV3Impl(this.dio);

  @override
  Future<UserModel> find(int id) async {
    final response = await dio.get("/api/users/$id/");
    if (response.statusCode == 200) {
      return UserModelV3.fromJson(response.data);
    }
    throw const PaperlessServerException.unknown();
  }

  @override
  Future<Iterable<UserModel>> findWhere({
    String startsWith = '',
    String endsWith = '',
    String contains = '',
    String username = '',
  }) async {
    final response = await dio.get("/api/users/", queryParameters: {
      "username__istartswith": startsWith,
      "username__iendswith": endsWith,
      "username__icontains": contains,
      "username__iexact": username,
    });
    if (response.statusCode == 200) {
      return PagedSearchResult<UserModel>.fromJson(
        response.data,
        UserModelV3.fromJson as UserModel Function(Object?),
      ).results;
    }
    throw const PaperlessServerException.unknown();
  }

  @override
  Future<int> findCurrentUserId() async {
    final response = await dio.get("/api/ui_settings/");
    if (response.statusCode == 200) {
      return response.data['user_id'];
    }
    throw const PaperlessServerException.unknown();
  }
}
