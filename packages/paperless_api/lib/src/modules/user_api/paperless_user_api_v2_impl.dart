import 'package:dio/dio.dart';
import 'package:paperless_api/paperless_api.dart';

class PaperlessUserApiV2Impl implements PaperlessUserApi {
  final Dio client;

  PaperlessUserApiV2Impl(this.client);

  @override
  Future<int> findCurrentUserId() async {
    final response = await client.get("/api/ui_settings/");
    if (response.statusCode == 200) {
      return response.data['user_id'];
    }
    throw const PaperlessServerException.unknown();
  }

  @override
  Future<UserModel> findCurrentUser() async {
    final response = await client.get("/api/ui_settings/");
    if (response.statusCode == 200) {
      return UserModelV2.fromJson(response.data);
    }
    throw const PaperlessServerException.unknown();
  }
}
