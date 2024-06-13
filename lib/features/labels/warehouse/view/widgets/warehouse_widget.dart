import 'package:flutter/material.dart';
import 'package:edocs_api/edocs_api.dart';

class WarehouseWidget extends StatelessWidget {
  final Warehouse? warehouse;
  final void Function(int? id)? onSelected;
  final Color? textColor;
  final bool isClickable;
  final TextStyle? textStyle;

  const WarehouseWidget({
    super.key,
    required this.warehouse,
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
          onTap: () => onSelected?.call(warehouse?.id),
          child: Text(
            warehouse?.name ?? "-",
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
