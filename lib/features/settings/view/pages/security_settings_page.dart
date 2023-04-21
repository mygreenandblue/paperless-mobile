import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/settings/view/widgets/biometric_authentication_setting.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.security),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              message: "These settings apply to the current user only", //TODO: INTL
              child: Icon(Icons.info_outline),
            ),
          ),
        ],
      ),
      body: ListView(
        children: const [
          BiometricAuthenticationSetting(),
        ],
      ),
    );
  }
}
