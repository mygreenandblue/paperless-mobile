import 'package:dio/dio.dart';
import 'package:paperless_api/paperless_api.dart';

class PaperlessUserApiV3Impl implements PaperlessUserApi, PaperlessUserApiV3 {
  final Dio dio;

  PaperlessUserApiV3Impl(this.dio);

  @override
  Future<UserModelV3> find(int id) async {
    final response = await dio.get("/api/users/$id/");
    if (response.statusCode == 200) {
      return UserModelV3.fromJson(response.data);
    }
    throw const PaperlessServerException.unknown();
  }

  @override
  Future<Iterable<UserModelV3>> findWhere({
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
      return PagedSearchResult<UserModelV3>.fromJson(
        response.data,
        UserModelV3.fromJson as UserModelV3 Function(Object?),
      ).results;
    }
    throw const PaperlessServerException.unknown();
  }

  @override
  Future<int> findCurrentUserId() async {
    final response = await dio.get("/api/ui_settings/");
    if (response.statusCode == 200) {
      return response.data['user']['id'];
    }
    throw const PaperlessServerException.unknown();
  }

  @override
  Future<Iterable<UserModelV3>> findAll() async {
    final response = await dio.get("/api/users/");
    if (response.statusCode == 200) {
      return PagedSearchResult<UserModelV3>.fromJson(
        response.data,
        (json) => UserModelV3.fromJson(json as dynamic),
      ).results;
    }
    throw const PaperlessServerException.unknown();
  }

  @override
  Future<UserModel> findCurrentUser() async {
    final id = await findCurrentUserId();
    return find(id);
  }
}
