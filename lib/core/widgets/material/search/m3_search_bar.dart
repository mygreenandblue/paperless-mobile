import 'dart:math';

import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    this.height = 56,
    required this.leadingIcon,
    this.trailingIcon,
    required this.supportingText,
    required this.onTap,
  }) : super(key: key);

  final double height;
  double get effectiveHeight {
    return max(height, 48);
  }

  final VoidCallback onTap;
  final Widget leadingIcon;
  final Widget? trailingIcon;

  final String supportingText;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 360, maxWidth: 720),
      width: double.infinity,
      height: effectiveHeight,
      child: Material(
        elevation: 1,
        color: colorScheme.surface,
        shadowColor: colorScheme.shadow,
        surfaceTintColor: colorScheme.surfaceTint,
        borderRadius: BorderRadius.circular(effectiveHeight / 2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(effectiveHeight / 2),
          highlightColor: Colors.transparent,
          splashFactory: InkRipple.splashFactory,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(children: [
              leadingIcon,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextField(
                    onTap: onTap,
                    readOnly: true,
                    enabled: false,
                    cursorColor: colorScheme.primary,
                    style: textTheme.bodyLarge,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      hintText: supportingText,
                      hintStyle: textTheme.bodyLarge?.apply(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              if (trailingIcon != null) trailingIcon!,
            ]),
          ),
        ),
      ),
    );
  }
}
