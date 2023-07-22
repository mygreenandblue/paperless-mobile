import 'package:paperless_api/src/models/exception/exceptions.dart';

abstract class PaperlessAuthenticationApi {
  ///
  /// @throws [PaperlessUnauthorizedException]
  ///
  Future<String> login({
    required String username,
    required String password,
  });
}
