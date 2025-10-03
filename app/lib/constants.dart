import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kSearchLimit = 10;
const kAvatarPath = 'assets/avatar.png';
final kBgColor = Colors.grey.withAlpha(50);

const incomeType = 'دخل';
const expenseType = 'منصرف';
final types = [expenseType, incomeType];

String approximate(int amount) {
  if (amount >= 1000000) {
    return '${(amount / 1000000).floor().truncate()} مـ';
  }
  if (amount >= 10000) {
    return '${(amount / 1000).floor().toInt()} أ';
  }
  return '$amount';
}

final colorScheme = ColorScheme.fromSeed(
  // brightness: Brightness.light,
  seedColor: Colors.purpleAccent,
  surface: Colors.white,
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.cairoTextTheme().copyWith(
    titleSmall: GoogleFonts.cairo(fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.cairo(fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.cairo(fontWeight: FontWeight.bold),
  ),
);
