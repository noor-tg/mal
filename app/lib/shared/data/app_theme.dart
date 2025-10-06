import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // general
  static const elevation = 1;
  static const seedColor = Colors.lightBlue;

  // Bright
  static final brightScheme = ColorScheme.fromSeed(seedColor: seedColor);
  static final light = ThemeData(
    colorScheme: brightScheme,
    useMaterial3: true,
    textTheme: GoogleFonts.cairoTextTheme(Typography.blackMountainView),
    cardTheme: CardThemeData(
      color: brightScheme.surfaceContainerLow,
      elevation: elevation.toDouble(),
    ),
  );

  // Dark
  static final darkScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );

  static final dark = ThemeData(
    colorScheme: darkScheme,
    useMaterial3: true,
    textTheme: GoogleFonts.cairoTextTheme(Typography.whiteMountainView),
    cardTheme: CardThemeData(
      color: darkScheme.surfaceContainerHigh,
      elevation: elevation.toDouble(),
    ),
  );
}
