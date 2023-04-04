import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tag_widget.dart';

class TagsWidget extends StatelessWidget {
  final List<Tag> tags;
  final bool isMultiLine;
  final void Function(int tagId)? onTagSelected;
  final bool isClickable;
  final bool showShortNames;
  final bool dense;

  const TagsWidget({
    Key? key,
    required this.tags,
    this.isMultiLine = true,
    this.isClickable = true,
    this.onTagSelected,
    this.showShortNames = false,
    this.dense = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final children = tags
            .map(
              (tag) => TagWidget(
                tag: tag,
                isClickable: isClickable,
                onSelected: () => onTagSelected?.call(tag.id!),
                showShortName: showShortNames,
                dense: dense,
              ),
            )
            .toList();
        if (isMultiLine) {
          return Wrap(
            runAlignment: WrapAlignment.start,
            children: children,
            runSpacing: 4,
            spacing: 4,
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: children),
          );
        }
      },
    );
  }
}
