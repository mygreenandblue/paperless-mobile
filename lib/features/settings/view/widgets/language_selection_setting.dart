import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/features/settings/cubit/application_settings_cubit.dart';
import 'package:paperless_mobile/features/settings/view/widgets/radio_settings_dialog.dart';
import 'package:paperless_mobile/generated/l10n.dart';

class LanguageSelectionSetting extends StatefulWidget {
  const LanguageSelectionSetting({super.key});

  @override
  State<LanguageSelectionSetting> createState() =>
      _LanguageSelectionSettingState();
}

class _LanguageSelectionSettingState extends State<LanguageSelectionSetting> {
  static const _languageOptions = {
    'en': 'English',
    'de': 'Deutsch',
    'cs': 'Česky',
    'tr': 'Türkçe',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationSettingsCubit, ApplicationSettingsState>(
      builder: (context, settings) {
        return ListTile(
          title: Text(S.of(context).settingsPageLanguageSettingLabel),
          subtitle: Text(_languageOptions[settings.preferredLocaleSubtag]!),
          onTap: () => showDialog<String>(
            context: context,
            builder: (_) => RadioSettingsDialog<String>(
              footer: const Text(
                "* Work in progress, not fully translated yet. Some words may be displayed in English!",
              ),
              titleText: S.of(context).settingsPageLanguageSettingLabel,
              options: [
                RadioOption(
                  value: 'en',
                  label: _languageOptions['en']!,
                ),
                RadioOption(
                  value: 'de',
                  label: _languageOptions['de']!,
                ),
                RadioOption(
                  value: 'cs',
                  label: _languageOptions['cs']! + "*",
                ),
                RadioOption(
                  value: 'tr',
                  label: _languageOptions['tr']! + "*",
                )
              ],
              initialValue: context
                  .read<ApplicationSettingsCubit>()
                  .state
                  .preferredLocaleSubtag,
            ),
          ).then((value) {
            if (value != null) {
              context.read<ApplicationSettingsCubit>().setLocale(value);
            }
          }),
        );
      },
    );
  }
}
