import 'package:flutter/material.dart';
import 'package:mal/constants.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/router.dart';
import 'package:mal/ui/bloc_loader.dart';

class MalApp extends StatelessWidget {
  const MalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocLoader(
      child: MaterialApp.router(
        theme: theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        routerConfig: createAppRouter(context),
      ),
    );
  }
}
