import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/user_account.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/user_settings.dart';

class UserAccountBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    UserAccount? settings,
  ) builder;

  const UserAccountBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<UserAccount>>(
      valueListenable: Hive.box<UserAccount>(HiveBoxes.userAccount).listenable(),
      builder: (context, accountBox, _) {
        final currentUser =
            Hive.box<GlobalSettings>(HiveBoxes.globalSettings).getValue()!.currentLoggedInUser;
        if (currentUser != null) {
          final account = accountBox.get(currentUser);
          return builder(context, account);
        } else {
          return builder(context, null);
        }
      },
    );
  }
}
