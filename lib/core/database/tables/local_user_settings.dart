import 'package:hive/hive.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';

part 'local_user_settings.g.dart';

@HiveType(typeId: HiveTypeIds.localUserSettings)
class LocalUserSettings with HiveObjectMixin {
  @HiveField(0)
  bool isBiometricAuthenticationEnabled;

  LocalUserSettings({
    this.isBiometricAuthenticationEnabled = false,
  });
}
