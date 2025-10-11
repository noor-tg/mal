import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/reports/domain/entities/totals.dart';
import 'package:mal/features/tour/domain/showcase_cubit.dart';
import 'package:mal/utils.dart';
import 'package:showcaseview/showcaseview.dart';

class SumsCard extends StatelessWidget {
  const SumsCard({super.key, required this.totals});

  final Totals totals;

  @override
  Widget build(BuildContext context) {
    final showcaseState = context.watch<ShowcaseCubit>().state;
    final l10n = context.l10n;
    final texts = context.texts;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Showcase(
          key: showcaseState.keys.balanceCard,
          description: l10n.showCaseDescriptionBalanceCard,
          child: Card(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  l10n.reportsBalance,
                  style: texts.titleLarge?.copyWith(
                    color: colors.primary.withAlpha(200),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  moneyFormat(totals.balance),
                  style: texts.displaySmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
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
                    color: context.green.withAlpha(200),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  moneyFormat(totals.incomes),
                  style: context.texts.displaySmall?.copyWith(
                    color: context.green,
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
                  context.l10n.expenses,
                  style: context.texts.titleLarge?.copyWith(
                    color: context.red.withAlpha(200),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  moneyFormat(totals.expenses),
                  style: context.texts.displaySmall?.copyWith(
                    color: context.red,
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
