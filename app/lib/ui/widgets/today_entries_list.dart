import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/models/entry.dart';

class TodayEntriesList extends StatelessWidget {
  final List<Entry> entries;

  const TodayEntriesList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Card.filled(
      color: Colors.white,
      child: Column(
        children: entries
            .map(
              (entry) => ListTile(
                title: Text(
                  entry.description,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade800,
                  ),
                ),
                subtitle: Text(
                  entry.category,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade800,
                  ),
                ),
                trailing: Text(
                  entry.prefixedAmount(l10n!.income),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: entry.color(l10n.income),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
