import 'package:dio/dio.dart';
import 'package:edocs_api/src/extensions/dio_exception_extension.dart';
import 'package:edocs_api/src/models/edocs_api_exception.dart';
import 'package:edocs_api/src/models/edocs_server_information_model.dart';
import 'package:edocs_api/src/models/edocs_server_statistics_model.dart';
import 'package:edocs_api/src/models/edocs_ui_settings_model.dart';

import 'edocs_server_stats_api.dart';

///
/// API for retrieving information about edocs server state,
/// such as version number, and statistics including documents in
/// inbox and total number of documents.
///
class EdocsServerStatsApiImpl implements EdocsServerStatsApi {
  final Dio client;
  static const _fallbackVersion = '0.0.0';
  EdocsServerStatsApiImpl(this.client);

  @override
  Future<EdocsServerInformationModel> getServerInformation() async {
    try {
      final response = await client.get(
        "/api/remote_version/",
        options: Options(validateStatus: (status) => status == 200),
      );
      final latestVersion = response.data["version"] as String;
      final version =
          response.headers.value(EdocsServerInformationModel.versionHeader) ??
              _fallbackVersion;
      final updateAvailable = response.data["update_available"] as bool;
      return EdocsServerInformationModel(
        apiVersion: int.parse(response.headers
            .value(EdocsServerInformationModel.apiVersionHeader)!),
        latestVersion: latestVersion,
        version: version,
        isUpdateAvailable: updateAvailable,
      );
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const EdocsApiException(
          ErrorCode.serverInformationLoadFailed,
        ),
      );
    }
  }

  @override
  Future<EdocsServerStatisticsModel> getServerStatistics() async {
    try {
      final response = await client.get(
        '/api/statistics/',
        options: Options(validateStatus: (status) => status == 200),
      );
      return EdocsServerStatisticsModel.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const EdocsApiException(
          ErrorCode.serverStatisticsLoadFailed,
        ),
      );
    }
  }

  @override
  Future<EdocsUiSettingsModel> getUiSettings() async {
    try {
      final response = await client.get(
        "/api/ui_settings/",
        options: Options(validateStatus: (status) => status == 200),
      );
      return EdocsUiSettingsModel.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const EdocsApiException(ErrorCode.uiSettingsLoadFailed),
      );
    }
  }
}
