import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/features/settings/model/global_settings.dart';
import 'package:paperless_mobile/features/settings/model/user_settings.dart';

class UserSettingsBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    UserSettings? settings,
  ) builder;

  const UserSettingsBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<UserSettings>>(
      valueListenable: Hive.box<UserSettings>(HiveBoxes.userSettings).listenable(),
      builder: (context, value, _) {
        final currentUser =
            Hive.box<GlobalSettings>(HiveBoxes.globalSettings).getValue()!.currentLoggedInUser;
        if (currentUser != null) {
          final settings = value.get(currentUser);
          return builder(context, settings);
        } else {
          return builder(context, null);
        }
      },
    );
  }
}
