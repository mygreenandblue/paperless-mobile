import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/client_certificate_form_model.dart';
import 'package:paperless_mobile/features/login/model/login_form_credentials.dart';
import 'package:paperless_mobile/features/login/view/widgets/form_fields/client_certificate_form_field.dart';
import 'package:paperless_mobile/features/login/view/widgets/form_fields/server_address_form_field.dart';
import 'package:paperless_mobile/features/login/view/widgets/form_fields/user_credentials_form_field.dart';
import 'package:paperless_mobile/features/login/view/widgets/login_pages/server_connection_page.dart';

import 'widgets/login_pages/server_login_page.dart';
import 'widgets/never_scrollable_scroll_behavior.dart';

class LoginPage extends StatefulWidget {
  final void Function(
    BuildContext context,
    String username,
    String password,
    String serverUrl,
    ClientCertificate? clientCertificate,
  ) onSubmit;

  final String submitText;
  final String titleString;

  const LoginPage({
    Key? key,
    required this.onSubmit,
    required this.submitText,
    required this.titleString,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FormBuilder(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          scrollBehavior: NeverScrollableScrollBehavior(),
          children: [
            ServerConnectionPage(
              titleString: widget.titleString,
              formBuilderKey: _formKey,
              onContinue: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            ServerLoginPage(
              formBuilderKey: _formKey,
              submitText: widget.submitText,
              onSubmit: _login,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final form = _formKey.currentState!.value;
      ClientCertificate? clientCert;
      final clientCertFormModel =
          form[ClientCertificateFormField.fkClientCertificate] as ClientCertificateFormModel?;
      if (clientCertFormModel != null) {
        clientCert = ClientCertificate(
          bytes: clientCertFormModel.bytes,
          passphrase: clientCertFormModel.passphrase,
        );
      }
      final credentials = form[UserCredentialsFormField.fkCredentials] as LoginFormCredentials;
      widget.onSubmit(
        context,
        credentials.username!,
        credentials.password!,
        form[ServerAddressFormField.fkServerAddress],
        clientCert,
      );
    }
  }
}
