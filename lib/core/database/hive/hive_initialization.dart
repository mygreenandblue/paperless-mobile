import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';
import 'package:edocs_mobile/core/database/tables/global_settings.dart';
import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/core/database/tables/local_user_app_state.dart';

Future<void> initHive(Directory directory, String defaultLocale) async {
  Hive.init(directory.path);
  registerHiveAdapters();
  await Hive.openBox<LocalUserAccount>(HiveBoxes.localUserAccount);
  await Hive.openBox<LocalUserAppState>(HiveBoxes.localUserAppState);
  await Hive.openBox<bool>(HiveBoxes.hintStateBox);
  await Hive.openBox<String>(HiveBoxes.hosts);
  final globalSettingsBox =
      await Hive.openBox<GlobalSettings>(HiveBoxes.globalSettings);

  if (!globalSettingsBox.hasValue) {
    await globalSettingsBox.setValue(
      GlobalSettings(preferredLocaleSubtag: defaultLocale),
    );
  }
}
