import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/features/settings/global_app_settings.dart';

class GlobalSettingsBuilder extends StatelessWidget {

  final Widget Function(BuildContext context, GlobalAppSettings settings)
      builder;
  const GlobalSettingsBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<GlobalAppSettings>(HiveBoxes.globalSettings).listenable(),
      builder: (context, value, _) {
        final settings = value.get(HiveBoxSingleValueKey.value)!;
        return builder(context, settings);
      },
    );
  }
}
