import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/translation/color_scheme_option_localization_mapper.dart';
import 'package:paperless_mobile/core/widgets/hint_card.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/features/settings/bloc/application_settings_cubit.dart';
import 'package:paperless_mobile/features/settings/bloc/application_settings_state.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';
import 'package:paperless_mobile/features/settings/view/widgets/radio_settings_dialog.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:provider/provider.dart';

class ColorSchemeOptionSetting extends StatelessWidget {
  const ColorSchemeOptionSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationSettingsCubit, ApplicationSettingsState>(
      builder: (context, settings) {
        return ListTile(
          title: Text(S.of(context).settingsPageColorSchemeSettingLabel),
          subtitle: Text(
            translateColorSchemeOption(
              context,
              settings.preferredColorSchemeOption,
            ),
          ),
          onTap: () => showDialog(
            context: context,
            builder: (_) => RadioSettingsDialog<ColorSchemeOption>(
              titleText: S.of(context).settingsPageColorSchemeSettingLabel,
              descriptionText:
                  S.of(context).settingsPageColorSchemeSettingDialogDescription,
              options: [
                RadioOption(
                  value: ColorSchemeOption.classic,
                  label: translateColorSchemeOption(
                      context, ColorSchemeOption.classic),
                ),
                RadioOption(
                  value: ColorSchemeOption.dynamic,
                  label: translateColorSchemeOption(
                    context,
                    ColorSchemeOption.dynamic,
                  ),
                ),
              ],
              footer: _isBelowAndroid12()
                  ? HintCard(
                      hintText: S
                          .of(context)
                          .settingsPageColorSchemeSettingDynamicThemeingVersionMismatchWarning,
                      hintIcon: Icons.warning_amber,
                    )
                  : null,
              initialValue: context
                  .read<ApplicationSettingsCubit>()
                  .state
                  .preferredColorSchemeOption,
            ),
          ).then(
            (value) {
              if (value != null) {
                context
                    .read<ApplicationSettingsCubit>()
                    .setColorSchemeOption(value);
              }
            },
          ),
        );
      },
    );
  }

  bool _isBelowAndroid12() {
    if (Platform.isAndroid) {
      final int version =
          int.tryParse(androidInfo!.version.release ?? '0') ?? 0;
      return version < 12;
    }
    return false;
  }
}
