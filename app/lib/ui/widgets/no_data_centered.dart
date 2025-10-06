import 'package:flutter/material.dart';
import 'package:mal/utils.dart';

class NoDataCentered extends StatelessWidget {
  const NoDataCentered({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Text(
          context.l10n.noDataFound,
          style: context.texts.bodyLarge?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
