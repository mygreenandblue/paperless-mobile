import 'package:dio/dio.dart';
import 'package:edocs_api/edocs_api.dart';

class DioUnauthorizedInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 403) {
      final data = err.response!.data;
      String? message;
      if (EdocsServerMessageException.canParse(data)) {
        final exception = EdocsServerMessageException.fromJson(data);
        message = exception.detail;
      }
      handler.reject(
        DioException(
          message: message,
          requestOptions: err.requestOptions,
          error: edocsUnauthorizedException(message),
          response: err.response,
          type: DioExceptionType.badResponse,
        ),
      );
    } else {
      handler.next(err);
    }
  }
}
