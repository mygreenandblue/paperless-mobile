import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/custpm_adapters/theme_mode_adapter.dart';
import 'package:paperless_mobile/features/login/model/authentication_information.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/settings/global_app_settings.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';
import 'package:paperless_mobile/features/settings/user_app_settings.dart';

class HiveBoxes {
  HiveBoxes._();
  static const globalSettings = 'globalSettings';
  static const userSettings = 'userSettings';
  static const authentication = 'authentication';
  static const vault = 'vault';
}

class HiveTypeIds {
  HiveTypeIds._();
  static const globalSettings = 0;
  static const userSettings = 1;
  static const themeMode = 2;
  static const colorSchemeOption = 3;
  static const authentication = 4;
  static const clientCertificate = 5;
}

class HiveBoxSingleValueKey {
  HiveBoxSingleValueKey._();
  static const value = 'value';
}

void registerHiveAdapters() {
  Hive.registerAdapter(ColorSchemeOptionAdapter());
  Hive.registerAdapter(ThemeModeAdapter());
  Hive.registerAdapter(GlobalAppSettingsAdapter());
  Hive.registerAdapter(UserAppSettingsAdapter());
  Hive.registerAdapter(AuthenticationInformationAdapter());
  Hive.registerAdapter(ClientCertificateAdapter());
}
