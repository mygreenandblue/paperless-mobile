import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/custpm_adapters/theme_mode_adapter.dart';
import 'package:paperless_mobile/features/login/model/authentication_information.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/user_account.dart';
import 'package:paperless_mobile/features/login/model/user_credentials.dart';
import 'package:paperless_mobile/features/settings/model/global_settings.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';
import 'package:paperless_mobile/features/settings/model/user_settings.dart';

class HiveBoxes {
  HiveBoxes._();
  static const globalSettings = 'globalSettings';
  static const userSettings = 'userSettings';
  static const authentication = 'authentication';
  static const userCredentials = 'userCredentials';
  static const userAccount = 'userAccount';
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
}

void registerHiveAdapters() {
  Hive.registerAdapter(ColorSchemeOptionAdapter());
  Hive.registerAdapter(ThemeModeAdapter());
  Hive.registerAdapter(GlobalSettingsAdapter());
  Hive.registerAdapter(AuthenticationInformationAdapter());
  Hive.registerAdapter(ClientCertificateAdapter());
  Hive.registerAdapter(UserSettingsAdapter());
  Hive.registerAdapter(UserCredentialsAdapter());
  Hive.registerAdapter(UserAccountAdapter());
}

extension HiveSingleValueBox<T> on Box<T> {
  static const _valueKey = 'SINGLE_VALUE';
  bool get hasValue => containsKey(_valueKey);

  T? getValue() => get(_valueKey);

  Future<void> setValue(T value) => put(_valueKey, value);
}
