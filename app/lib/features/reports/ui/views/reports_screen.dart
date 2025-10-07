import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/reports/ui/widgets/daily_sums_chart.dart';
import 'package:mal/features/reports/ui/widgets/pie_chart_loader.dart';
import 'package:mal/features/reports/ui/widgets/sums_loader.dart';
import 'package:mal/shared/domain/side_effects.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/ui/widgets/mal_title.dart';
import 'package:mal/ui/widgets/entries_list.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';
import 'package:mal/utils.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late StreamSubscription<EntriesState> stream;
  @override
  void initState() {
    reloadReportsData(context);

    stream = context.read<EntriesBloc>().stream.listen((state) {
      if (OperationType.values.contains(state.operationType)) {
        if (!mounted) return;

        reloadReportsData(context);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MalPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          box8,
          const SumsLoader(),
          box16,
          MalTitle(text: l10n.currentMonth),
          box8,
          const Card(child: DailySumsChart()),
          box16,
          MalTitle(text: l10n.expenses),
          box4,
          PieChartLoader(type: l10n.expense),
          box16,
          MalTitle(text: l10n.income),
          box8,
          PieChartLoader(type: l10n.income),
          box16,
          MalTitle(text: l10n.todayEntries),
          box8,
          BlocBuilder<EntriesBloc, EntriesState>(
            builder: (BuildContext context, state) {
              if (state.today.isEmpty) {
                return const Card(child: NoDataCentered());
              }
              return EntriesList(entries: state.today);
            },
          ),
          box64,
        ],
      ),
    );
  }
}
