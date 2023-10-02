import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';

class SkipDocumentPreprationOnShareSetting extends StatelessWidget {
  const SkipDocumentPreprationOnShareSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        return SwitchListTile(
          title: Text("Direct share"),
          subtitle:
              Text("Always directly upload when sharing files with the app."),
          value: settings.skipDocumentPreprarationOnUpload,
          onChanged: (value) {
            settings.skipDocumentPreprarationOnUpload = value;
            settings.save();
          },
        );
      },
    );
  }
}
