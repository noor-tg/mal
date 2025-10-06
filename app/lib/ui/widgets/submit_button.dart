import 'package:flutter/material.dart';
import 'package:mal/utils.dart';

class SubmitButton extends StatelessWidget {
  final void Function() onPressed;

  const SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.onPrimary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          context.l10n.save,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
