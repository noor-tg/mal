import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/widgets/line_container.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';
import 'package:mal/utils.dart';

class DailySumsChart extends StatelessWidget {
  const DailySumsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Sums>(
      future: loadDailySums(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading data: ${snapshot.error.toString()}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        final emptyIncomesExpenses =
            snapshot.data!.incomes.isEmpty && snapshot.data!.expenses.isEmpty;

        if (snapshot.hasData || emptyIncomesExpenses) {
          return const NoDataCentered();
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: LineContainer(
              first: snapshot.data!.incomes,
              second: snapshot.data!.expenses,
            ),
          ),
        );
      },
    );
  }
}
