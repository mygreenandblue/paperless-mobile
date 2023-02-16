import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/empty_state.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/paged_document_view/cubit/paged_documents_state.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

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
      child: EmptyState(
        title: S.of(context)!.oops,
        subtitle: S.of(context)!.thereSeemsToBeNothingHere,
        bottomChild: state.filter != DocumentFilter.initial && onReset != null
            ? TextButton(
                onPressed: onReset,
                child: Text(
                  S.of(context)!.resetFilter,
                ),
              ).padded()
            : null,
      ),
    );
  }
}
