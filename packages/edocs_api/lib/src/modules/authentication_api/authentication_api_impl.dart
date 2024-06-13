import 'package:dio/dio.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_api/src/extensions/dio_exception_extension.dart';

class EdocsAuthenticationApiImpl implements EdocsAuthenticationApi {
  final Dio client;

  EdocsAuthenticationApiImpl(this.client);

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
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          followRedirects: false,
          headers: {
            "Accept": "application/json",
          },
          // validateStatus: (status) {
          //   return status! == 200;
          // },
        ),
      );
      return response.data['token'];
      // } else if (response.statusCode == 302) {
      // final redirectUrl = response.headers.value("location");
      // return AuthenticationTemporaryRedirect(redirectUrl!);
    } on DioException catch (exception) {
      throw exception.unravel();
    } catch (error, stackTrace) {
      throw EdocsApiException.unknown(
        details: error.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}
