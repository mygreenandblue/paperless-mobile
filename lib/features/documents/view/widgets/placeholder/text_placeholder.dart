import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';

class TextPlaceholder extends StatelessWidget {
  final double length;
  final double fontSize;

  const TextPlaceholder({
    super.key,
    required this.length,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: length,
      height: fontSize,
    );
  }
}
