import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';

part 'user_app_settings.g.dart';

@HiveType(typeId: HiveTypeIds.userSettings)
class UserAppSettings with HiveObjectMixin {
  @HiveField(0)
  bool isBiometricAuthenticationEnabled;

  UserAppSettings({
    this.isBiometricAuthenticationEnabled = false,
  });
}
