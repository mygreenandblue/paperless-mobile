import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/login/model/basic_auth_model.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

import 'obscured_input_text_form_field.dart';

class BasicAuthFormField extends StatefulWidget {
  static const fkBasicAuth = 'basicAuth';

  const BasicAuthFormField({
    super.key,
  });

  @override
  State<BasicAuthFormField> createState() => _BasicAuthFormFieldState();
}

class _BasicAuthFormFieldState extends State<BasicAuthFormField> {
  //TODO: INTL ALL
  @override
  Widget build(BuildContext context) {
    return FormBuilderField<BasicAuthModel?>(
      key: const ValueKey('login-basic-auth'),
      initialValue: null,
      builder: (field) {
        final theme = Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        );
        return Theme(
          data: theme,
          child: ExpansionTile(
            title: Text("Basic Authentication"),
            subtitle: Text("Configure basic authentication credentials"),
            children: [
              InputDecorator(
                decoration: InputDecoration(
                  errorText: field.errorText,
                  border: InputBorder.none,
                ),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: S.of(context)!.username,
                      ),
                      onChanged: (value) {
                        field.didChange(
                          (field.value ?? BasicAuthModel())
                              .copyWith(username: value),
                        );
                      },
                    ),
                    ObscuredInputTextFormField(
                      label: S.of(context)!.password,
                      onChanged: (value) {
                        field.didChange(
                          (field.value ?? BasicAuthModel())
                              .copyWith(password: value),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      name: BasicAuthFormField.fkBasicAuth,
    );
  }
}
