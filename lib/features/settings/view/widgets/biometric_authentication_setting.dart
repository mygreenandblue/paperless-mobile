import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/features/settings/cubit/application_settings_cubit.dart';
import 'package:paperless_mobile/features/settings/global_app_settings.dart';
import 'package:paperless_mobile/features/settings/user_app_settings.dart';
import 'package:paperless_mobile/features/settings/view/widgets/user_settings_builder.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BiometricAuthenticationSetting extends StatelessWidget {
  const BiometricAuthenticationSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return UserSettingsBuilder(
      builder: (context, settings) {
        if (settings == null) {
          return const SizedBox.shrink();
        }
        return SwitchListTile(
          value: settings.isBiometricAuthenticationEnabled,
          title: Text(S.of(context)!.biometricAuthentication),
          subtitle: Text(S.of(context)!.authenticateOnAppStart),
          onChanged: (val) async {
            final String localizedReason =
                S.of(context)!.authenticateToToggleBiometricAuthentication(
                      val ? 'enable' : 'disable',
                    );

            final isAuthenticated = await context
                .read<LocalAuthenticationService>()
                .authenticateLocalUser(localizedReason);
            if (isAuthenticated) {
              settings.isBiometricAuthenticationEnabled = val;
              settings.save();
            }
          },
        );
      },
    );
  }
}
