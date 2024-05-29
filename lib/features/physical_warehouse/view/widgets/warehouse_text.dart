import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

class WarehouseText<T extends WarehouseModel> extends StatelessWidget {
  final T? label;
  final String placeholder;
  final TextStyle? style;
  const WarehouseText({
    super.key,
    this.style,
    this.placeholder = "-",
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label?.toString() ?? placeholder,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
