import 'package:flutter/material.dart';
import 'package:edocs_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class EnforcePdfUploadSetting extends StatelessWidget {
  const EnforcePdfUploadSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(builder: (context, settings) {
      return SwitchListTile(
        title: Text(S.of(context)!.uploadScansAsPdf),
        subtitle: Text(S.of(context)!.convertSinglePageScanToPdf),
        value: settings.enforceSinglePagePdfUpload,
        onChanged: (value) {
          settings.enforceSinglePagePdfUpload = value;
          settings.save();
        },
      );
    });
  }
}
