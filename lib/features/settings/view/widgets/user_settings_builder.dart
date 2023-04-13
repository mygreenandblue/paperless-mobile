import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/features/settings/global_app_settings.dart';
import 'package:paperless_mobile/features/settings/user_app_settings.dart';

class UserSettingsBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    UserAppSettings? settings,
  ) builder;

  const UserSettingsBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<UserAppSettings>>(
      valueListenable:
          Hive.box<UserAppSettings>(HiveBoxes.userSettings).listenable(),
      builder: (context, value, _) {
        final currentUser =
            Hive.box<GlobalAppSettings>(HiveBoxes.globalSettings)
                .get(HiveBoxSingleValueKey.value)
                ?.currentLoggedInUser;
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
