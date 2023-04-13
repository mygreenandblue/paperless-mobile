import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';

part 'global_app_settings.g.dart';

@HiveType(typeId: HiveTypeIds.globalSettings)
class GlobalAppSettings with ChangeNotifier, HiveObjectMixin {
  @HiveField(0)
  String preferredLocaleSubtag;

  @HiveField(1)
  ThemeMode preferredThemeMode;

  @HiveField(2)
  ColorSchemeOption preferredColorSchemeOption;

  @HiveField(3)
  bool showOnboarding;

  @HiveField(4)
  String? currentLoggedInUser;

  GlobalAppSettings({
    required this.preferredLocaleSubtag,
    this.preferredThemeMode = ThemeMode.system,
    this.preferredColorSchemeOption = ColorSchemeOption.classic,
    this.showOnboarding = true,
    this.currentLoggedInUser,
  });

  static GlobalAppSettings get boxedValue =>
      Hive.box<GlobalAppSettings>(HiveBoxes.globalSettings)
          .get(HiveBoxSingleValueKey.value)!;
}
