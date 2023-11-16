import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class DisableAnimationsSetting extends StatelessWidget {
  const DisableAnimationsSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(builder: (context, settings) {
      return SwitchListTile(
        value: settings.disableAnimations,
        title: Text('Disable animations'),
        subtitle: Text('Disables page transitions and most animations.'
            ' Temporary workaround until system accessibility settings can be used.'),
        onChanged: (val) async {
          settings.disableAnimations = val;
          settings.save();
        },
      );
    });
  }
}
