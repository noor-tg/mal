import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      // brightness: Brightness.light,
    ),
    useMaterial3: true,
    textTheme: Typography.blackCupertino,
    cardTheme: const CardThemeData(
      color: Colors.white,
      // surfaceTintColor: Colors.transparent,
      elevation: 2,
    ),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    textTheme: Typography.whiteCupertino,
    cardTheme: CardThemeData(
      color: Colors.grey[300],
      // surfaceTintColor: Colors.transparent,
      elevation: 2,
    ),
  );
}
