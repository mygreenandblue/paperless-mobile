import 'package:paperless_api/paperless_api.dart';

abstract class PaperlessUserApi {
  Future<int> findCurrentUserId();
  Future<UserModel> find(int id);
}
