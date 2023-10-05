import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/exception/server_message_exception.dart';
import 'package:paperless_mobile/core/model/info_message_exception.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/client_certificate_form_model.dart';
import 'package:paperless_mobile/features/login/model/login_form_credentials.dart';
import 'package:paperless_mobile/features/login/model/reachability_status.dart';
import 'package:paperless_mobile/features/login/view/widgets/form_fields/client_certificate_form_field.dart';
import 'package:paperless_mobile/features/login/view/widgets/form_fields/server_address_form_field.dart';
import 'package:paperless_mobile/features/login/view/widgets/form_fields/user_credentials_form_field.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class AddAccountPage extends StatefulWidget {
  final FutureOr<void> Function(
    BuildContext context,
    String username,
    String password,
    String serverUrl,
    ClientCertificate? clientCertificate,
  ) onSubmit;

  final String? initialServerUrl;
  final String? initialUsername;
  final String? initialPassword;
  final ClientCertificate? initialClientCertificate;

  final String submitText;
  final String titleText;
  final bool showLocalAccounts;

  final Widget? bottomLeftButton;
  const AddAccountPage({
    Key? key,
    required this.onSubmit,
    required this.submitText,
    required this.titleText,
    this.showLocalAccounts = false,
    this.initialServerUrl,
    this.initialUsername,
    this.initialPassword,
    this.initialClientCertificate,
    this.bottomLeftButton,
  }) : super(key: key);

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isCheckingConnection = false;
  ReachabilityStatus _reachabilityStatus = ReachabilityStatus.unknown;

  bool _isFormSubmitted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleText),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: widget.bottomLeftButton != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            if (widget.bottomLeftButton != null) widget.bottomLeftButton!,
            FilledButton(
              child: Text(S.of(context)!.loginPageSignInTitle),
              onPressed: _reachabilityStatus == ReachabilityStatus.reachable &&
                      !_isFormSubmitted
                  ? _onSubmit
                  : null,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: FormBuilder(
        key: _formKey,
        child: ListView(
          children: [
            ServerAddressFormField(
              initialValue: widget.initialServerUrl,
              onSubmit: (address) {
                _updateReachability(address);
              },
            ).padded(),
            ClientCertificateFormField(
              initialBytes: widget.initialClientCertificate?.bytes,
              initialPassphrase: widget.initialClientCertificate?.passphrase,
              onChanged: (_) => _updateReachability(),
            ).padded(),
            _buildStatusIndicator(),
            if (_reachabilityStatus == ReachabilityStatus.reachable) ...[
              UserCredentialsFormField(
                formKey: _formKey,
                initialUsername: widget.initialUsername,
                initialPassword: widget.initialPassword,
                onFieldsSubmitted: _onSubmit,
              ),
              Text(
                S.of(context)!.loginRequiredPermissionsHint,
                style: Theme.of(context).textTheme.bodySmall?.apply(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6),
                    ),
              ).padded(16),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> _updateReachability([String? address]) async {
    setState(() {
      _isCheckingConnection = true;
    });
    final certForm =
        _formKey.currentState?.getRawValue<ClientCertificateFormModel>(
      ClientCertificateFormField.fkClientCertificate,
    );
    final status = await context
        .read<ConnectivityStatusService>()
        .isPaperlessServerReachable(
          address ??
              _formKey.currentState!
                  .getRawValue(ServerAddressFormField.fkServerAddress),
          certForm != null
              ? ClientCertificate(
                  bytes: certForm.bytes,
                  passphrase: certForm.passphrase,
                )
              : null,
        );
    setState(() {
      _isCheckingConnection = false;
      _reachabilityStatus = status;
    });
  }

  Widget _buildStatusIndicator() {
    if (_isCheckingConnection) {
      return const ListTile();
    }

    Widget _buildIconText(
      IconData icon,
      String text, [
      Color? color,
    ]) {
      return ListTile(
        title: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
        leading: Icon(
          icon,
          color: color,
        ),
      );
    }

    Color errorColor = Theme.of(context).colorScheme.error;
    switch (_reachabilityStatus) {
      case ReachabilityStatus.unknown:
        return Container();
      case ReachabilityStatus.reachable:
        return _buildIconText(
          Icons.done,
          S.of(context)!.connectionSuccessfulylEstablished,
          Colors.green,
        );
      case ReachabilityStatus.notReachable:
        return _buildIconText(
          Icons.close,
          S.of(context)!.couldNotEstablishConnectionToTheServer,
          errorColor,
        );
      case ReachabilityStatus.unknownHost:
        return _buildIconText(
          Icons.close,
          S.of(context)!.hostCouldNotBeResolved,
          errorColor,
        );
      case ReachabilityStatus.missingClientCertificate:
        return _buildIconText(
          Icons.close,
          S.of(context)!.loginPageReachabilityMissingClientCertificateText,
          errorColor,
        );
      case ReachabilityStatus.invalidClientCertificateConfiguration:
        return _buildIconText(
          Icons.close,
          S.of(context)!.incorrectOrMissingCertificatePassphrase,
          errorColor,
        );
      case ReachabilityStatus.connectionTimeout:
        return _buildIconText(
          Icons.close,
          S.of(context)!.connectionTimedOut,
          errorColor,
        );
    }
  }

  Future<void> _onSubmit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isFormSubmitted = true;
    });
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final form = _formKey.currentState!.value;
      ClientCertificate? clientCert;
      final clientCertFormModel =
          form[ClientCertificateFormField.fkClientCertificate]
              as ClientCertificateFormModel?;
      if (clientCertFormModel != null) {
        clientCert = ClientCertificate(
          bytes: clientCertFormModel.bytes,
          passphrase: clientCertFormModel.passphrase,
        );
      }
      final credentials =
          form[UserCredentialsFormField.fkCredentials] as LoginFormCredentials;
      try {
        await widget.onSubmit(
          context,
          credentials.username!,
          credentials.password!,
          form[ServerAddressFormField.fkServerAddress],
          clientCert,
        );
      } on PaperlessApiException catch (error) {
        showErrorMessage(context, error);
      } on ServerMessageException catch (error) {
        showLocalizedError(context, error.message);
      } on InfoMessageException catch (error) {
        showInfoMessage(context, error);
      } catch (error) {
        showGenericError(context, error);
      } finally {
        setState(() {
          _isFormSubmitted = false;
        });
      }
    }
  }
}
