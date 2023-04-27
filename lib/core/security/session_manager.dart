import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/interceptor/retry_on_connection_change_interceptor.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Manages the security context, authentication and base request URL for
/// an underlying [Dio] client which is injected into all services
/// requiring authenticated access to the Paperless HTTP API.
class SessionManager {
  final Dio _client;
  PaperlessServerInformationModel _serverInformation;

  Dio get client => _client;

  SessionManager([List<Interceptor> interceptors = const []])
      : _client = _initDio(interceptors),
        _serverInformation = PaperlessServerInformationModel();

  static Dio _initDio(List<Interceptor> interceptors) {
    //en- and decoded by utf8 by default
    final Dio dio = Dio(
      BaseOptions(contentType: Headers.jsonContentType),
    );
    dio.options.receiveTimeout = const Duration(seconds: 25);
    dio.options.responseType = ResponseType.json;
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) => client..badCertificateCallback = (cert, host, port) => true;
    dio.interceptors.addAll([
      ...interceptors,
      PrettyDioLogger(
        compact: true,
        responseBody: false,
        responseHeader: false,
        request: false,
        requestBody: false,
        requestHeader: false,
      ),
      RetryOnConnectionChangeInterceptor(dio: dio)
    ]);
    return dio;
  }

  void updateSettings({
    String? baseUrl,
    String? authToken,
    ClientCertificate? clientCertificate,
    PaperlessServerInformationModel? serverInformation,
  }) {
    if (clientCertificate != null) {
      final context = SecurityContext()
        ..usePrivateKeyBytes(
          clientCertificate.bytes,
          password: clientCertificate.passphrase,
        )
        ..useCertificateChainBytes(
          clientCertificate.bytes,
          password: clientCertificate.passphrase,
        )
        ..setTrustedCertificatesBytes(
          clientCertificate.bytes,
          password: clientCertificate.passphrase,
        );
      final adapter = IOHttpClientAdapter()
        ..onHttpClientCreate = (client) => HttpClient(context: context)
          ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      client.httpClientAdapter = adapter;
    }

    if (baseUrl != null) {
      client.options.baseUrl = baseUrl;
    }

    if (authToken != null) {
      client.options.headers.addAll({
        HttpHeaders.authorizationHeader: 'Token $authToken',
      });
    }

    if (serverInformation != null) {
      _serverInformation = serverInformation;
    }
  }

  void resetSettings() {
    client.httpClientAdapter = IOHttpClientAdapter();
    client.options.baseUrl = '';
    client.options.headers.remove(HttpHeaders.authorizationHeader);
    _serverInformation = PaperlessServerInformationModel();
  }
}
