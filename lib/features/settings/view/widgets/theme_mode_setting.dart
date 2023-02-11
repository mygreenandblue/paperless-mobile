import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/features/settings/cubit/application_settings_cubit.dart';
import 'package:paperless_mobile/features/settings/view/widgets/radio_settings_dialog.dart';
import 'package:paperless_mobile/generated/l10n.dart';

class ThemeModeSetting extends StatelessWidget {
  const ThemeModeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationSettingsCubit, ApplicationSettingsState>(
      builder: (context, settings) {
        return ListTile(
          title: Text(S.of(context).settingsPageAppearanceSettingTitle),
          subtitle: Text(_mapThemeModeToLocalizedString(
              settings.preferredThemeMode, context)),
          onTap: () => showDialog<ThemeMode>(
            context: context,
            builder: (_) => RadioSettingsDialog<ThemeMode>(
              titleText: S.of(context).settingsPageAppearanceSettingTitle,
              initialValue: context
                  .read<ApplicationSettingsCubit>()
                  .state
                  .preferredThemeMode,
              options: [
                RadioOption(
                  value: ThemeMode.system,
                  label: S
                      .of(context)
                      .settingsPageAppearanceSettingSystemThemeLabel,
                ),
                RadioOption(
                  value: ThemeMode.light,
                  label: S
                      .of(context)
                      .settingsPageAppearanceSettingLightThemeLabel,
                ),
                RadioOption(
                  value: ThemeMode.dark,
                  label:
                      S.of(context).settingsPageAppearanceSettingDarkThemeLabel,
                )
              ],
            ),
          ).then((value) {
            if (value != null) {
              context.read<ApplicationSettingsCubit>().setThemeMode(value);
            }
          }),
        );
      },
    );
  }

  String _mapThemeModeToLocalizedString(ThemeMode theme, BuildContext context) {
    switch (theme) {
      case ThemeMode.system:
        return S.of(context).settingsThemeModeSystemLabel;
      case ThemeMode.light:
        return S.of(context).settingsThemeModeLightLabel;
      case ThemeMode.dark:
        return S.of(context).settingsThemeModeDarkLabel;
    }
  }
}
