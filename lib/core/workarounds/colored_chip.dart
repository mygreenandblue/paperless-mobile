import 'package:flutter/material.dart';

class ColoredChipWrapper extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  const ColoredChipWrapper({
    super.key,
    this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Color color = backgroundColor ?? Colors.lightGreen[50]!;

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: color,
      ),
      child: child,
    );
  }
}
