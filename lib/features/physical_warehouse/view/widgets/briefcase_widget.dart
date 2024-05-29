import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

class BriefcaseWidget extends StatelessWidget {
  final WarehouseModel? briefcase;
  final void Function(int? id)? onSelected;
  final Color? textColor;
  final bool isClickable;
  final TextStyle? textStyle;

  const BriefcaseWidget({
    super.key,
    required this.briefcase,
    this.textColor,
    this.isClickable = true,
    this.textStyle,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !isClickable,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => onSelected?.call(briefcase?.id),
          child: Text(
            briefcase?.name ?? "-",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                (textStyle ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(
              color: textColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
