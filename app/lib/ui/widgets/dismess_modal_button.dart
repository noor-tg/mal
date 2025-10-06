import 'package:flutter/material.dart';
import 'package:mal/utils.dart';

class DismessModalButton extends StatelessWidget {
  const DismessModalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: context.colors.primary.withAlpha(50), width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(context.l10n.cancel),
      ),
    );
  }
}
