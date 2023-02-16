import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/highlighted_text.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/generated/l10n.dart';

class DocumentContentWidget extends StatelessWidget {
  final bool isFullContentLoaded;
  final String? fullContent;
  final String? queryString;
  final DocumentModel document;
  const DocumentContentWidget({
    super.key,
    required this.isFullContentLoaded,
    this.fullContent,
    required this.document,
    this.queryString,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HighlightedText(
            text: (isFullContentLoaded ? fullContent : document.content) ?? "",
            highlights: queryString != null ? queryString!.split(" ") : [],
            style: Theme.of(context).textTheme.bodyMedium,
            caseSensitive: false,
          ),
          if (!isFullContentLoaded && (document.content ?? '').isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                child: Text(S.of(context).loadFullContent),
                onPressed: () {
                  context.read<DocumentDetailsCubit>().loadFullContent();
                },
              ),
            ),
        ],
      ),
    );
  }
}
