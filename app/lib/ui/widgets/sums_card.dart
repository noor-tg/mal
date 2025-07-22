import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class SumsCard extends StatelessWidget {
  const SumsCard({super.key, required this.totals});

  final Totals totals;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card.filled(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                Text(l10n!.reportsBalance),
                const SizedBox(width: 16),
                Text(
                  moneyFormat(context, totals.balance),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card.filled(
                    color: Colors.red.withAlpha(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(l10n.expenses),
                          Text(
                            moneyFormat(context, totals.expenses),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card.filled(
                    color: Colors.lightGreen.withAlpha(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(l10n.income),
                          Text(
                            moneyFormat(context, totals.incomes),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: Colors.lightGreen),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
