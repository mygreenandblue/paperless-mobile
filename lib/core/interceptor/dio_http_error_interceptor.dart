import 'package:dio/dio.dart';
import 'package:paperless_api/paperless_api.dart';

class DioHttpErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 400) {
      final data = err.response!.data;
      if (PaperlessServerMessageException.canParse(data)) {
        final exception = PaperlessServerMessageException.fromJson(data);
        final message = exception.detail;
        handler.reject(
          DioException(
            message: message,
            requestOptions: err.requestOptions,
            error: exception,
            response: err.response,
            type: DioExceptionType.badResponse,
          ),
        );
      } else if (PaperlessFormValidationException.canParse(data)) {
        final exception = PaperlessFormValidationException.fromJson(data);
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: exception,
            response: err.response,
            type: DioExceptionType.badResponse,
          ),
        );
      } else if (data is String &&
          data.contains("No required SSL certificate was sent")) {
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            type: DioExceptionType.badResponse,
            error:
                const PaperlessApiException(ErrorCode.missingClientCertificate),
          ),
        );
      }
    } else {
      return handler.next(err);
    }
  }
}
