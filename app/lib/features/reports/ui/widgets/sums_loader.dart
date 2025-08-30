import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/reports/domain/bloc/totals/totals_bloc.dart';
import 'package:mal/features/reports/domain/entities/totals.dart';
import 'package:mal/ui/widgets/sums_card.dart';
import 'package:shimmer_effects_plus/shimmer_effects_plus.dart';

class SumsLoader extends StatelessWidget {
  const SumsLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TotalsBloc, TotalsState>(
      builder: (BuildContext context, state) {
        final primary = Theme.of(context).colorScheme.primary;
        if (state.status == BlocStatus.loading) {
          return ShimmerEffectWidget.cover(
            subColor: primary.withAlpha(255),
            mainColor: primary.withAlpha(200),
            period: const Duration(milliseconds: 1500),
            direction: ShimmerDirection.ttb,
            child: const SumsCard(
              totals: Totals(balance: 0, incomes: 0, expenses: 0),
            ),
          );
        }

        if (state.status == BlocStatus.failure) {
          return Text('test :: ${state.errorMessage}');
        }

        return SumsCard(totals: state.totals);
      },
    );
  }
}
