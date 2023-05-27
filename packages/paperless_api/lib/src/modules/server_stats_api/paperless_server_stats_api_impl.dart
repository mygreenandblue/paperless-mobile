import 'package:dio/dio.dart';
import 'package:paperless_api/src/models/paperless_server_exception.dart';
import 'package:paperless_api/src/models/paperless_server_information_model.dart';
import 'package:paperless_api/src/models/paperless_server_statistics_model.dart';
import 'package:paperless_api/src/models/paperless_ui_settings_model.dart';

import 'paperless_server_stats_api.dart';

///
/// API for retrieving information about paperless server state,
/// such as version number, and statistics including documents in
/// inbox and total number of documents.
///
class PaperlessServerStatsApiImpl implements PaperlessServerStatsApi {
  final Dio client;

  PaperlessServerStatsApiImpl(this.client);

  @override
  Future<PaperlessServerInformationModel> getServerInformation() async {
    final response = await client.get("/api/remote_version/");
    if (response.statusCode == 200) {
      final version = response.data["version"] as String;
      final updateAvailable = response.data["update_available"] as bool;
      return PaperlessServerInformationModel(
        apiVersion: int.parse(response.headers.value('x-api-version')!),
        version: version,
        isUpdateAvailable: updateAvailable,
      );
    }
    throw const PaperlessServerException.unknown();
  }

  @override
  Future<PaperlessServerStatisticsModel> getServerStatistics() async {
    final response = await client.get('/api/statistics/');
    if (response.statusCode == 200) {
      return PaperlessServerStatisticsModel.fromJson(response.data);
    }
    throw const PaperlessServerException.unknown();
  }

  @override
  Future<PaperlessUiSettingsModel> getUiSettings() async {
    final response = await client.get("/api/ui_settings/");
    if (response.statusCode == 200) {
      return PaperlessUiSettingsModel.fromJson(response.data);
    }
    throw const PaperlessServerException.unknown();
  }
}
