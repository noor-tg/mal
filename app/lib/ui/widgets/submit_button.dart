import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';

class SubmitButton extends StatelessWidget {
  final void Function() onPressed;

  const SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          l10n.save,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
