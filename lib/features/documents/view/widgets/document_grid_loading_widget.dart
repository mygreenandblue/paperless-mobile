import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paperless_mobile/core/widgets/shimmer_placeholder.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/document_item_placeholder.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/tags_placeholder.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/text_placeholder.dart';
import 'package:shimmer/shimmer.dart';

class DocumentGridLoadingWidget extends StatelessWidget
    with DocumentItemPlaceholder {
  final bool _isSliver;
  @override
  final Random random = Random(1257195195);
  DocumentGridLoadingWidget({super.key}) : _isSliver = false;

  DocumentGridLoadingWidget.sliver({super.key}) : _isSliver = true;

  @override
  Widget build(BuildContext context) {
    const delegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 1 / 2,
    );
    if (_isSliver) {
      return SliverGrid.builder(
        gridDelegate: delegate,
        itemBuilder: (context, index) => _buildPlaceholderGridItem(context),
      );
    }
    return GridView.builder(
      gridDelegate: delegate,
      itemBuilder: (context, index) => _buildPlaceholderGridItem(context),
    );
  }

  Widget _buildPlaceholderGridItem(BuildContext context) {
    final values = nextValues;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerPlaceholder(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShimmerPlaceholder(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextPlaceholder(
                        length: values.correspondentLength,
                        fontSize: 16,
                      ).padded(1),
                      TextPlaceholder(
                        length: values.titleLength,
                        fontSize: 16,
                      ),
                      if (values.tagCount > 0) ...[
                        const Spacer(),
                        TagsPlaceholder(
                          count: values.tagCount,
                          dense: true,
                        ),
                      ],
                      const Spacer(),
                      TextPlaceholder(
                        length: 100,
                        fontSize:
                            Theme.of(context).textTheme.bodySmall!.fontSize!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
