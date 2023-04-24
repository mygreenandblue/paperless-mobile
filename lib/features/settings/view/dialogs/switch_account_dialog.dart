import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class SwitchAccountDialog extends StatelessWidget {
  const SwitchAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context)!.switchAccountTitle),
      content: Text(S.of(context)!.switchToNewAccount),
      actions: [
        const DialogCancelButton(),
        DialogConfirmButton(
          style: DialogConfirmButtonStyle.normal,
          label: S.of(context)!.switchAccount,
        ),
      ],
    );
  }
}
