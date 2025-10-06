import 'package:flutter/material.dart';
import 'package:mal/features/reports/domain/entities/totals.dart';
import 'package:mal/utils.dart';

class SumsCard extends StatelessWidget {
  const SumsCard({super.key, required this.totals});

  final Totals totals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                context.l10n.reportsBalance,
                style: context.texts.titleLarge?.copyWith(
                  color: Colors.blue[200],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                moneyFormat(totals.balance),
                style: context.texts.displaySmall?.copyWith(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  context.l10n.expenses,
                  style: context.texts.titleLarge?.copyWith(
                    color: Colors.red[200],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  moneyFormat(totals.expenses),
                  style: context.texts.displaySmall?.copyWith(
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  context.l10n.income,
                  style: context.texts.titleLarge?.copyWith(
                    color: Colors.green[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  moneyFormat(totals.incomes),
                  style: context.texts.displaySmall?.copyWith(
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
