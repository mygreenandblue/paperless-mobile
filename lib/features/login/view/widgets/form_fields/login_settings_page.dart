import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:edocs_mobile/features/login/view/widgets/form_fields/client_certificate_form_field.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class LoginSettingsPage extends StatelessWidget {
  const LoginSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.settings),
      ),
      body: ListView(
        children: [
          ClientCertificateFormField(onChanged: (certificate) {}),
        ],
      ),
    );
  }
}
