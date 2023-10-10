import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/highlighted_text.dart';
import 'package:paperless_mobile/core/widgets/shimmer_placeholder.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class DocumentContentWidget extends StatelessWidget {
  final bool isFullContentLoaded;
  final String? queryString;
  final DocumentModel document;
  const DocumentContentWidget({
    super.key,
    required this.isFullContentLoaded,
    required this.document,
    this.queryString,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HighlightedText(
            text: document.content ?? '',
            highlights: queryString != null ? queryString!.split(" ") : [],
            style: Theme.of(context).textTheme.bodyMedium,
            caseSensitive: false,
          ),
          if (!isFullContentLoaded)
            ShimmerPlaceholder(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var scale in [0.5, 0.9, 0.5, 0.8, 0.9, 0.9])
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: screenWidth * scale,
                      height: 14,
                      color: Colors.white,
                    ),
                ],
              ),
            ).paddedOnly(top: 4),
        ],
      ),
    );
  }
}
