import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/widgets/shimmer_placeholder.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/document_item_placeholder.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/tags_placeholder.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/text_placeholder.dart';

class DocumentsListLoadingWidget extends StatelessWidget
    with DocumentItemPlaceholder {
  final bool _isSliver;
  DocumentsListLoadingWidget({super.key}) : _isSliver = false;

  DocumentsListLoadingWidget.sliver({super.key}) : _isSliver = true;

  @override
  final Random random = Random(1209571050);

  @override
  Widget build(BuildContext context) {
    if (_isSliver) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildFakeListItem(context),
        ),
      );
    } else {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _buildFakeListItem(context),
      );
    }
  }

  Widget _buildFakeListItem(BuildContext context) {
    const fontSize = 14.0;
    final values = nextValues;
    return ShimmerPlaceholder(
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        dense: true,
        isThreeLine: true,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: Colors.white,
            height: double.infinity,
            width: 35,
          ),
        ),
        title: Row(
          children: [
            TextPlaceholder(
              length: values.correspondentLength,
              fontSize: fontSize,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextPlaceholder(
                length: values.titleLength,
                fontSize: fontSize,
              ),
              if (values.tagCount > 0)
                TagsPlaceholder(count: values.tagCount, dense: true),
              TextPlaceholder(
                length: 100,
                fontSize: Theme.of(context).textTheme.labelSmall!.fontSize!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
