import 'package:hive/hive.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';

part 'user_settings.g.dart';

@HiveType(typeId: HiveTypeIds.userSettings)
class UserSettings with HiveObjectMixin {
  @HiveField(0)
  bool isBiometricAuthenticationEnabled;

  @HiveField(1)
  DocumentFilter currentDocumentFilter;

  UserSettings({
    this.isBiometricAuthenticationEnabled = false,
    required this.currentDocumentFilter,
  });
}
