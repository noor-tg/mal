import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/reports/domain/bloc/daily_sums/daily_sums_bloc.dart';
import 'package:mal/ui/widgets/line_container.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';
import 'package:mal/utils.dart';
import 'package:shimmer_effects_plus/shimmer_effects_plus.dart';

class DailySumsChart extends StatelessWidget {
  const DailySumsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailySumsBloc, DailySumsState>(
      builder: (context, state) {
        if (state.status == BlocStatus.loading) {
          return ShimmerEffectWidget.cover(
            subColor: context.colors.primary.withAlpha(255),
            mainColor: context.colors.primary.withAlpha(200),
            period: const Duration(milliseconds: 1500),
            direction: ShimmerDirection.ttb,
            child: const Card(
              child: SizedBox(width: double.infinity, height: 250),
            ),
          );
        }

        if (state.status == BlocStatus.failure) {
          return Center(
            child: Text(
              'Error loading data: ${state.errorMessage.toString()}',
              style: TextStyle(color: context.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        final emptyIncomesExpenses =
            state.list.incomes.isEmpty && state.list.expenses.isEmpty;

        if (emptyIncomesExpenses) {
          return const NoDataCentered();
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: LineContainer(
              first: state.list.incomes,
              second: state.list.expenses,
            ),
          ),
        );
      },
    );
  }
}
