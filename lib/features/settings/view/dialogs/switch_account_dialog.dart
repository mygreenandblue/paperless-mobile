import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class SwitchAccountDialog extends StatelessWidget {
  final String username;
  final String serverUrl;
  const SwitchAccountDialog({
    super.key,
    required this.username,
    required this.serverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Switch account"),
      content: Text("Do you want to switch to $serverUrl and log in as $username?"),
      actions: [
        DialogConfirmButton(
          style: DialogConfirmButtonStyle.danger,
          label: S.of(context)!.continueLabel, //TODO: INTL change labels
        ),
        DialogCancelButton(),
      ],
    );
  }
}
