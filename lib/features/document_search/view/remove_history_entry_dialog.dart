import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/generated/l10n.dart';

class RemoveHistoryEntryDialog extends StatelessWidget {
  final String entry;
  const RemoveHistoryEntryDialog({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(entry),
      content: Text(S.of(context).documentSearchRemoveHistoryEntryText),
      actions: [
        const DialogCancelButton(),
        TextButton(
          child: Text(S.of(context).genericActionRemoveLabel),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
