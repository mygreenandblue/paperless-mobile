import 'package:flutter/material.dart';
import 'package:edocs_api/edocs_api.dart';

class LabelText<T extends Label> extends StatelessWidget {
  final T? label;
  final String placeholder;
  final TextStyle? style;
  const LabelText({
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
