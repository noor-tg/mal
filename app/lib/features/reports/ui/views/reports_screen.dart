import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/reports/ui/widgets/daily_sums_chart.dart';
import 'package:mal/features/reports/ui/widgets/pie_chart_loader.dart';
import 'package:mal/features/reports/ui/widgets/sums_loader.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/domain/side_effects.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/ui/widgets/mal_title.dart';
import 'package:mal/ui/widgets/entries_list.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return MalPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          const SumsLoader(),
          const SizedBox(height: 16),
          MalTitle(text: l10n.currentMonth),
          const SizedBox(height: 8),
          const Card.filled(color: Colors.white, child: DailySumsChart()),
          const SizedBox(height: 16),
          MalTitle(text: l10n.expenses),
          const SizedBox(height: 4),
          PieChartLoader(type: l10n.expense),
          const SizedBox(height: 16),
          MalTitle(text: l10n.income),
          const SizedBox(height: 8),
          PieChartLoader(type: l10n.income),
          const SizedBox(height: 16),
          MalTitle(text: l10n.todayEntries),
          const SizedBox(height: 8),
          BlocBuilder<EntriesBloc, EntriesState>(
            builder: (BuildContext context, state) {
              if (state.today.isEmpty) {
                return const Card.filled(
                  color: Colors.white,
                  child: NoDataCentered(),
                );
              }
              return EntriesList(entries: state.today);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
