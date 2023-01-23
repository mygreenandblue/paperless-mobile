import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';

const _classicThemeColorSeed = Colors.lightGreen;

const _defaultListTileTheme = ListTileThemeData(
  tileColor: Colors.transparent,
);

final _defaultInputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 16.0,
  ),
);

ThemeData buildTheme({
  required Brightness brightness,
  required ColorSchemeOption preferredColorScheme,
  ColorScheme? dynamicScheme,
}) {
  final classicScheme = ColorScheme.fromSeed(
    seedColor: _classicThemeColorSeed,
    brightness: brightness,
  ).harmonized();
  late ColorScheme colorScheme;
  switch (preferredColorScheme) {
    case ColorSchemeOption.classic:
      colorScheme = classicScheme;
      break;
    case ColorSchemeOption.dynamic:
      colorScheme = dynamicScheme ?? classicScheme;
      break;
  }
  return ThemeData.from(
    colorScheme: colorScheme.harmonized(),
    useMaterial3: true,
  ).copyWith(
    inputDecorationTheme: _defaultInputDecorationTheme,
    listTileTheme: _defaultListTileTheme,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
    ),
  );
}
