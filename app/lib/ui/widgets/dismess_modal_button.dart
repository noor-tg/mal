import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';

class DismessModalButton extends StatelessWidget {
  const DismessModalButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withAlpha(50),
          width: 2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(l10n.cancel),
      ),
    );
  }
}
