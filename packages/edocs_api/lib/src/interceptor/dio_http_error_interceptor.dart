import 'package:dio/dio.dart';
import 'package:edocs_api/edocs_api.dart';

class DioHttpErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 400) {
      final data = err.response!.data;
      if (EdocsServerMessageException.canParse(data)) {
        final exception = EdocsServerMessageException.fromJson(data);
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
      } else if (edocsFormValidationException.canParse(data)) {
        final exception = edocsFormValidationException.fromJson(data);
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: exception,
            response: err.response,
            type: DioExceptionType.badResponse,
          ),
        );
      } else if (data is String) {
        if (data.contains("No required SSL certificate was sent")) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
              error:
                  const EdocsApiException(ErrorCode.missingClientCertificate),
            ),
          );
        } else {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              message: data,
              error: EdocsApiException(
                ErrorCode.documentLoadFailed,
                details: data,
              ),
              response: err.response,
              stackTrace: err.stackTrace,
              type: DioExceptionType.badResponse,
            ),
          );
        }
      } else {
        handler.reject(err);
      }
    }
  }
}
