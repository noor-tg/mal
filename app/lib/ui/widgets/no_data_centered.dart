import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';

class NoDataCentered extends StatelessWidget {
  const NoDataCentered({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.noDataFound,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
