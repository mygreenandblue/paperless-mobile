import 'package:edocs_api/edocs_api.dart';

abstract class EdocsUserApi {
  Future<int> findCurrentUserId();
  Future<UserModel> findCurrentUser();
}
