import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

class StoragePathWidget extends StatelessWidget {
  final StoragePath? storagePath;
  final Color? textColor;
  final bool isClickable;
  final void Function(int? id)? onSelected;

  const StoragePathWidget({
    Key? key,
    this.storagePath,
    this.textColor,
    this.isClickable = true,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !isClickable,
      child: GestureDetector(
        onTap: () => onSelected?.call(storagePath?.id),
        child: Text(
          storagePath?.name ?? "-",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor ?? Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
    );
  }
}
