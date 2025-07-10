import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/app_container.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
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

class MalApp extends StatelessWidget {
  const MalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: AppContainer(),
    );
  }
}
