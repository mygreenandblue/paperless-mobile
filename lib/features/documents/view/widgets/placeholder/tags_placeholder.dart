import 'package:flutter/material.dart';

class TagsPlaceholder extends StatelessWidget {
  static const _lengths = [24, 36, 16, 48];
  final int count;
  final bool dense;
  const TagsPlaceholder({
    super.key,
    required this.count,
    required this.dense,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: count,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => FilterChip(
          labelPadding:
              dense ? const EdgeInsets.symmetric(horizontal: 2) : null,
          padding: dense ? const EdgeInsets.all(4) : null,
          visualDensity: const VisualDensity(vertical: -2),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide.none,
          onSelected: (_) {},
          selected: false,
          label: Text(
            List.filled(_lengths[index], " ").join(),
          ),
        ),
        separatorBuilder: (context, _) => const SizedBox(width: 4),
      ),
    );
  }
}
