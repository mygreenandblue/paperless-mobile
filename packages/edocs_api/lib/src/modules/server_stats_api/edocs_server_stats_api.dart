import 'package:edocs_api/src/models/edocs_server_information_model.dart';
import 'package:edocs_api/src/models/edocs_server_statistics_model.dart';
import 'package:edocs_api/src/models/edocs_ui_settings_model.dart';

abstract class EdocsServerStatsApi {
  Future<EdocsServerInformationModel> getServerInformation();
  Future<EdocsServerStatisticsModel> getServerStatistics();
  Future<EdocsUiSettingsModel> getUiSettings();
}
