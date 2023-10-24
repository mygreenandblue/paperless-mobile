import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

class DocumentTypeWidget extends StatelessWidget {
  final DocumentType? documentType;
  final bool isClickable;
  final TextStyle? textStyle;
  final void Function(int? id)? onSelected;
  const DocumentTypeWidget({
    Key? key,
    required this.documentType,
    this.isClickable = true,
    this.textStyle,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !isClickable,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => onSelected?.call(documentType?.id),
          child: Text(
            documentType?.toString() ?? "-",
            style: (textStyle ?? Theme.of(context).textTheme.bodyMedium)
                ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
