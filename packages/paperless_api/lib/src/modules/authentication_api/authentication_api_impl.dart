import 'package:dio/dio.dart';
import 'package:paperless_api/src/extensions/dio_exception_extension.dart';
import 'package:paperless_api/src/modules/authentication_api/authentication_api.dart';

class PaperlessAuthenticationApiImpl implements PaperlessAuthenticationApi {
  final Dio client;

  PaperlessAuthenticationApiImpl(this.client);

  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await client.post(
        "/api/token/",
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          validateStatus: (status) => status == 200,
        ),
      );
      return response.data['token'];
    } on DioException catch (exception) {
      throw exception.unravel();
    }
  }
}
