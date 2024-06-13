import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:edocs_api/edocs_api.dart';

void main() {
  group('AuthenticationApi with DioHttpErrorIncerceptor', () {
    late EdocsAuthenticationApi authenticationApi;
    late DioAdapter mockAdapter;
    const token = "abcde";
    const invalidCredentialsServerMessage =
        "Unable to log in with provided credentials.";

    setUp(() {
      final dio = Dio()..interceptors.add(DioHttpErrorInterceptor());
      authenticationApi = EdocsAuthenticationApiImpl(dio);
      mockAdapter = DioAdapter(dio: dio);
      // Valid credentials
      mockAdapter.onPost(
        "/api/token/",
        data: {
          "username": "username",
          "password": "password",
        },
        (server) => server.reply(200, {"token": token}),
      );
      // Invalid credentials
      mockAdapter.onPost(
        "/api/token/",
        data: {
          "username": "wrongUsername",
          "password": "wrongPassword",
        },
        (server) => server.reply(400, {
          "non_field_errors": [invalidCredentialsServerMessage]
        }),
      );
    });

    // tearDown(() {});
    test(
      'should return a valid token when logging in with valid credentials',
      () {
        expect(
          authenticationApi.login(
            username: "username",
            password: "password",
          ),
          completion(token),
        );
      },
    );

    test(
      'should throw a edocsFormValidationException containing a reason '
      'when logging in with invalid credentials',
      () {
        expect(
          authenticationApi.login(
            username: "wrongUsername",
            password: "wrongPassword",
          ),
          throwsA(isA<edocsFormValidationException>().having(
            (e) => e.unspecificErrorMessage(),
            "non-field specific error message",
            equals(invalidCredentialsServerMessage),
          )),
        );
      },
    );

    test(
      'should return an error when logging in with invalid credentials',
      () {
        expect(
          authenticationApi.login(
            username: "wrongUsername",
            password: "wrongPassword",
          ),
          throwsA(isA<edocsFormValidationException>().having(
            (e) => e.unspecificErrorMessage(),
            "non-field specific error message",
            equals(invalidCredentialsServerMessage),
          )),
        );
      },
    );
  });
}
