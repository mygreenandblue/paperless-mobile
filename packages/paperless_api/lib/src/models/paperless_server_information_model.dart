import 'package:paperless_api/src/request_utils.dart';

class PaperlessServerInformationModel {
  static const String versionHeader = 'x-version';
  static const String apiVersionHeader = 'x-api-version';
  final String version;
  final int apiVersion;
  final bool isUpdateAvailable;

  PaperlessServerInformationModel({
    required this.version,
    required this.apiVersion,
    required this.isUpdateAvailable,
  });

  int compareToOtherVersion(String other) {
    return getExtendedVersionNumber(version).compareTo(getExtendedVersionNumber(other));
  }
}
