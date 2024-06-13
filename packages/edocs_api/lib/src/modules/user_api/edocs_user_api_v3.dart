import 'package:edocs_api/src/models/user_model.dart';

abstract class EdocsUserApiV3 {
  Future<UserModelV3> find(int id);
  Future<Iterable<UserModelV3>> findAll();
  Future<Iterable<UserModelV3>> findWhere({
    String startsWith,
    String endsWith,
    String contains,
    String username,
  });
}
