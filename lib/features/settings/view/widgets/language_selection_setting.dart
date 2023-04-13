import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/features/settings/cubit/application_settings_cubit.dart';
import 'package:paperless_mobile/features/settings/global_app_settings.dart';
import 'package:paperless_mobile/features/settings/view/widgets/radio_settings_dialog.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';

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
    'fr': 'Français',
    'pl': 'Polska',
  };

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        return ListTile(
          title: Text(S.of(context)!.language),
          subtitle: Text(_languageOptions[settings.preferredLocaleSubtag]!),
          onTap: () => showDialog<String>(
            context: context,
            builder: (_) => RadioSettingsDialog<String>(
              footer: const Text(
                "* Not fully translated yet. Some words may be displayed in English!",
              ),
              titleText: S.of(context)!.language,
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
                  value: 'fr',
                  label: _languageOptions['fr']!,
                ),
                RadioOption(
                  value: 'cs',
                  label: _languageOptions['cs']! + "*",
                ),
                RadioOption(
                  value: 'tr',
                  label: _languageOptions['tr']! + "*",
                ),
                RadioOption(
                  value: 'pl',
                  label: _languageOptions['pl']! + "*",
                )
              ],
              initialValue: settings.preferredLocaleSubtag,
            ),
          ).then((value) {
            if (value != null) {
              settings.preferredLocaleSubtag = value;
              settings.save();
            }
          }),
        );
      },
    );
  }
}
