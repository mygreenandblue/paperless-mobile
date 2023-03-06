import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/settings/view/widgets/radio_settings_dialog.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class SelectFileTypeDialog extends StatelessWidget {
  const SelectFileTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return RadioSettingsDialog(
      titleText: S.of(context)!.chooseFiletype,
      options: [
        RadioOption(
          value: true,
          label: S.of(context)!.original,
        ),
        RadioOption(
          value: false,
          label: S.of(context)!.archivedPdf,
        ),
      ],
      initialValue: false,
    );
  }
}
