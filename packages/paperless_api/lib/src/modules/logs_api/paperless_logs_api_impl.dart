import 'package:dio/dio.dart';
import 'package:paperless_api/src/models/paperless_server_exception.dart';
import 'package:paperless_api/src/modules/logs_api/paperless_logs_api.dart';

class PaperlessLogsApiImpl implements PaperlessLogsApi {
  final Dio _dio;

  PaperlessLogsApiImpl(this._dio);

  @override
  Future<List<String>> fetchLog(String logType) async {
    final response = await _dio.get('/api/logs/$logType/');
    if (response.statusCode == 200) {
      return (response.data as List).cast<String>();
    } else if (response.statusCode == 404) {
      throw PaperlessServerException(
        ErrorCode.logNotFound,
        httpStatusCode: response.statusCode,
      );
    }
    throw PaperlessServerException(
      ErrorCode.unknown, //TODO: Own error type
      httpStatusCode: response.statusCode,
    );
  }

  @override
  Future<List<String>> findLogTypes() async {
    final response = await _dio.get('/api/logs/');
    if (response.statusCode == 200) {
      return (response.data as List).cast<String>();
    }
    throw PaperlessServerException(
      ErrorCode.unknown, //TODO: Own error type.
      httpStatusCode: response.statusCode,
    );
  }
}
