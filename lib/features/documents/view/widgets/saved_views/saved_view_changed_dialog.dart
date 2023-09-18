import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class SavedViewChangedDialog extends StatelessWidget {
  const SavedViewChangedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Discard changes?"), //TODO: INTL
      content: Text(
        "Some filters of the currently active view have changed. By resetting the filter, these changes will be lost. Do you still wish to continue?", //TODO: INTL
      ),
      actionsOverflowButtonSpacing: 8,
      actions: [
        const DialogCancelButton(),
        // TextButton(
        //   child: Text(S.of(context)!.saveChanges),
        //   onPressed: () {
        //     Navigator.pop(context, false);
        //   },
        // ),
        DialogConfirmButton(
          label: S.of(context)!.resetFilter,
          style: DialogConfirmButtonStyle.danger,
          returnValue: true,
        ),
      ],
    );
  }
}
