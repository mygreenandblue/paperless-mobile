import 'package:flutter/material.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:edocs_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class ConfirmDeleteSavedViewDialog extends StatelessWidget {
  const ConfirmDeleteSavedViewDialog({
    Key? key,
    required this.view,
  }) : super(key: key);

  final SavedView view;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        S.of(context)!.deleteView(view.name),
        softWrap: true,
      ),
      content: Text(S.of(context)!.doYouReallyWantToDeleteThisView),
      actions: [
        const DialogCancelButton(),
        DialogConfirmButton(
          label: S.of(context)!.delete,
          style: DialogConfirmButtonStyle.danger,
        ),
      ],
    );
  }
}
