import 'package:flutter/material.dart';
import 'package:edocs_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class SkipDocumentPreprationOnShareSetting extends StatelessWidget {
  const SkipDocumentPreprationOnShareSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        return SwitchListTile(
          title: Text(S.of(context)!.skipEditingReceivedFiles),
          subtitle: Text(S.of(context)!.uploadWithoutPromptingUploadForm),
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
