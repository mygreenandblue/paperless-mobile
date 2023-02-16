import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class DeleteDocumentConfirmationDialog extends StatelessWidget {
  final DocumentModel document;
  const DeleteDocumentConfirmationDialog({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context)!.confirmDeletion),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context)!.areYouSureYouWantToDeleteTheFollowingDocuments(1),
          ),
          const SizedBox(height: 16),
          Text(
            document.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(S.of(context)!.thisActionIsIrreversibleDoYouWishToProceedAnyway),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(S.of(context)!.cancel),
        ),
        TextButton(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(Theme.of(context).colorScheme.error),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(S.of(context)!.delete),
        ),
      ],
    );
  }
}
