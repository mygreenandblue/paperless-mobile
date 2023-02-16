import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

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
        S.of(context)!.deleteView + view.name + "?",
        softWrap: true,
      ),
      content: Text(S.of(context)!.doYouReallyWantToDeleteThisView),
      actions: [
        TextButton(
          child: Text(S.of(context)!.cancel),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: Text(
            S.of(context)!.delete,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
