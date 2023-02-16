import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:paperless_mobile/generated/l10n.dart';

class BulkDeleteConfirmationDialog extends StatelessWidget {
  final DocumentsState state;
  const BulkDeleteConfirmationDialog({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(state.selection.isNotEmpty);
    return AlertDialog(
      title: Text(S.of(context).confirmDeletion),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).areYouSureYouWantToDeleteTheFollowingDocuments(
                state.selection.length),
          ),
          const SizedBox(height: 16),
          ...state.selection.map(_buildBulletPoint).toList(),
          const SizedBox(height: 16),
          Text(S.of(context).thisActionIsIrreversibleDoYouWishToProceedAnyway),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(Theme.of(context).colorScheme.error),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(S.of(context).delete),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(DocumentModel doc) {
    return ListTile(
      dense: true,
      title: Text(
        doc.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
