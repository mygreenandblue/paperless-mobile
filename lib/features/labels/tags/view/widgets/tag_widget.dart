import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

class TagWidget extends StatelessWidget {
  final Tag tag;
  final VoidCallback? afterTagTapped;
  final VoidCallback onSelected;
  final bool isSelected;
  final bool isClickable;
  final bool showShortName;
  final bool dense;

  const TagWidget({
    super.key,
    required this.tag,
    required this.afterTagTapped,
    this.isClickable = true,
    required this.onSelected,
    required this.isSelected,
    this.showShortName = false,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: AbsorbPointer(
        absorbing: !isClickable,
        child: FilterChip(
          labelPadding:
              dense ? const EdgeInsets.symmetric(horizontal: 2) : null,
          padding: dense ? const EdgeInsets.all(4) : null,
          selected: isSelected,
          selectedColor: tag.color,
          onSelected: (_) => onSelected(),
          visualDensity: const VisualDensity(vertical: -2),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: Text(
            showShortName && tag.name.length > 6
                ? '${tag.name.substring(0, 6)}...'
                : tag.name,
            style: TextStyle(color: tag.textColor),
          ),
          checkmarkColor: tag.textColor,
          backgroundColor: tag.color,
          side: BorderSide.none,
        ),
      ),
    );
  }
}
