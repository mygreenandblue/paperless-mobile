import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/features/settings/cubit/application_settings_cubit.dart';
import 'package:paperless_mobile/generated/l10n.dart';

class BiometricAuthenticationSetting extends StatelessWidget {
  const BiometricAuthenticationSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationSettingsCubit, ApplicationSettingsState>(
      builder: (context, settings) {
        return SwitchListTile(
          value: settings.isLocalAuthenticationEnabled,
          title: Text(S.of(context).appSettingsBiometricAuthenticationLabel),
          subtitle: Text(
              S.of(context).appSettingsBiometricAuthenticationDescriptionText),
          onChanged: (val) async {
            final String localizedReason = val
                ? S
                    .of(context)
                    .appSettingsEnableBiometricAuthenticationReasonText
                : S
                    .of(context)
                    .appSettingsDisableBiometricAuthenticationReasonText;
            await context
                .read<ApplicationSettingsCubit>()
                .setIsBiometricAuthenticationEnabled(val,
                    localizedReason: localizedReason);
          },
        );
      },
    );
  }
}
