import 'package:dio/dio.dart';

extension DioExceptionUnravelExtension on DioException {
  Object unravel({Object? orElse}) {
    return error ?? orElse ?? Exception("Unknown");
  }
}
