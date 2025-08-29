import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/features/categories/data/repositories/sql_repository.dart'
    as categories;
import 'package:mal/features/entries/data/repositories/sql_repository.dart'
    as entries;
import 'package:mal/features/reports/data/repositories/sql_repository.dart'
    as reports;
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/domain/repositories/categories_repository.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/reports/domain/bloc/reports_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/app_container.dart';

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
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CategoriesRepository>(
            create: (_) => categories.SqlRepository(),
          ),
          RepositoryProvider(
            create: (_) {
              return entries.SqlRepository();
            },
          ),
          RepositoryProvider(
            create: (_) {
              return reports.SqlRepository();
            },
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<CategoriesBloc>(
              create: (ctx) =>
                  CategoriesBloc(repo: ctx.read<CategoriesRepository>()),
            ),
            BlocProvider<EntriesBloc>(
              create: (ctx) =>
                  EntriesBloc(repo: ctx.read<entries.SqlRepository>()),
            ),
            BlocProvider(
              create: (ctx) =>
                  ReportsBloc(repo: ctx.read<reports.SqlRepository>()),
            ),
          ],
          child: const AppContainer(),
        ),
      ),
    );
  }
}
