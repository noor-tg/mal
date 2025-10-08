import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/router.dart';
import 'package:mal/shared/data/app_theme.dart';
import 'package:mal/shared/domain/bloc/theme/theme_bloc.dart';
import 'package:mal/ui/bloc_loader.dart';

class MalApp extends StatelessWidget {
  const MalApp({super.key, required this.seenOnBoard});

  final bool seenOnBoard;

  @override
  Widget build(BuildContext context) {
    return BlocLoader(
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) => MaterialApp.router(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
          routerConfig: createAppRouter(context, seenOnBoard),
        ),
      ),
    );
  }
}
