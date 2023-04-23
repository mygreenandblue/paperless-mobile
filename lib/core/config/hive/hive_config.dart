import 'package:hive_flutter/adapters.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/custom_adapters/theme_mode_adapter.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/user_app_state.dart';
import 'package:paperless_mobile/core/database/tables/user_credentials.dart';
import 'package:paperless_mobile/features/login/model/authentication_information.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/core/database/tables/user_account.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';
import 'package:paperless_mobile/core/database/tables/user_settings.dart';

class HiveBoxes {
  HiveBoxes._();
  static const globalSettings = 'globalSettings';
  static const authentication = 'authentication';
  static const userCredentials = 'userCredentials';
  static const userAccount = 'userAccount';
  static const userAppState = 'userAppState';
  static const userSettings = 'userSettings';
}

class HiveTypeIds {
  HiveTypeIds._();
  static const globalSettings = 0;
  static const userSettings = 1;
  static const themeMode = 2;
  static const colorSchemeOption = 3;
  static const authentication = 4;
  static const clientCertificate = 5;
  static const userCredentials = 6;
  static const userAccount = 7;
  static const userAppState = 8;
}

void registerHiveAdapters() {
  registerPaperlessApiHiveTypeAdapters();
  Hive.registerAdapter(ColorSchemeOptionAdapter());
  Hive.registerAdapter(ThemeModeAdapter());
  Hive.registerAdapter(GlobalSettingsAdapter());
  Hive.registerAdapter(AuthenticationInformationAdapter());
  Hive.registerAdapter(ClientCertificateAdapter());
  Hive.registerAdapter(UserSettingsAdapter());
  Hive.registerAdapter(UserCredentialsAdapter());
  Hive.registerAdapter(UserAccountAdapter());
  Hive.registerAdapter(UserAppStateAdapter());
}

extension HiveSingleValueBox<T> on Box<T> {
  static const _valueKey = 'SINGLE_VALUE';
  bool get hasValue => containsKey(_valueKey);

  T? getValue() => get(_valueKey);

  Future<void> setValue(T value) => put(_valueKey, value);
}
