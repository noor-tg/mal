import 'package:flutter/material.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';
import 'package:mal/ui/widgets/sums_card.dart';
import 'package:mal/utils.dart';
import 'package:shimmer_effects_plus/shimmer_effects_plus.dart';

class SumsLoader extends StatelessWidget {
  const SumsLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadTotals(),
      builder: (BuildContext context, snapshot) {
        final primary = Theme.of(context).colorScheme.primary;
        if (snapshot.connectionState == ConnectionState.waiting) {
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

        if (snapshot.hasError) {
          return Text('test :: ${snapshot.error}');
        }

        if (snapshot.data == null) {
          return const NoDataCentered();
        }

        return SumsCard(totals: snapshot.data!);
      },
    );
  }
}
