import 'package:paperless_api/src/models/user_model.dart';

abstract class PaperlessUserApiV3 {
  Future<Iterable<UserModel>> findWhere({
    String startsWith,
    String endsWith,
    String contains,
    String username,
  });
}
