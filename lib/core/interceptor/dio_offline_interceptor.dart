import 'dart:io';

import 'package:dio/dio.dart';
import 'package:edocs_api/edocs_api.dart';

class DioOfflineInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.error is SocketException) {
      final ex = err.error as SocketException;
      if (ex.osError?.errorCode == _OsErrorCodes.serverUnreachable.code) {
        handler.reject(
          DioException(
            message: "The host could not be reached. Is your device offline?",
            error: const EdocsApiException(ErrorCode.deviceOffline),
            requestOptions: err.requestOptions,
            type: DioExceptionType.connectionTimeout,
          ),
        );
      }
    } else {
      handler.next(err);
    }
  }
}

enum _OsErrorCodes {
  serverUnreachable(101);

  const _OsErrorCodes(this.code);
  final int code;
}
