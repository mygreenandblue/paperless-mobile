import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/features/paged_document_view/cubit/paged_documents_state.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class DocumentsEmptyState extends StatelessWidget {
  final DocumentPagingState state;
  final VoidCallback? onReset;

  const DocumentsEmptyState({
    Key? key,
    required this.state,
    this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            S.of(context)!.noDocumentsFound,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (state.filter != DocumentFilter.initial && onReset != null)
            TextButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                onReset!();
              },
              child: Text(
                S.of(context)!.resetFilter,
              ),
            ).padded(),
        ],
      ).padded(24),
    );
  }
}
