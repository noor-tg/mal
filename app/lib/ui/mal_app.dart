import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  surface: const Color.fromARGB(255, 56, 49, 66),
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

class MalApp extends StatelessWidget {
  const MalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Text('hi'),
    );
  }
}
