import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:shimmer/shimmer.dart';

class DocumentsListLoadingWidget extends StatelessWidget {
  static const _tags = ["    ", "            ", "      "];
  static const _titleLengths = <double>[double.infinity, 150.0, 200.0];
  static const _correspondentLengths = <double>[200.0, 300.0, 150.0];
  static const _fontSize = 16.0;

  const DocumentsListLoadingWidget({super.key
  });

  @override
  Widget build(BuildContext context) {
    final _random = Random();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildFakeListItem(context, _random);
        },
      ),
    );
  }

  Widget _buildFakeListItem(BuildContext context, Random random) {
    final tagCount = random.nextInt(_tags.length + 1);
    final correspondentLength =
        _correspondentLengths[random.nextInt(_correspondentLengths.length - 1)];
    final titleLength = _titleLengths[random.nextInt(_titleLengths.length - 1)];
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]!
          : Colors.grey[900]!,
      highlightColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]!
          : Colors.grey[600]!,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        dense: true,
        isThreeLine: true,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: Colors.white,
            height: 50,
            width: 35,
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          width: correspondentLength,
          height: _fontSize,
          color: Colors.white,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                height: _fontSize,
                width: titleLength,
                color: Colors.white,
              ),
              Wrap(
                spacing: 2.0,
                children: List.generate(
                  tagCount,
                  (index) => InputChip(
                    label: Text(_tags[random.nextInt(_tags.length)]),
                  ),
                ),
              ).paddedOnly(top: 4),
            ],
          ),
        ),
      ),
    );
  }
}
