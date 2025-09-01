import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/reports/domain/bloc/categories_report/categories_report_bloc.dart';
import 'package:mal/features/reports/domain/bloc/daily_sums/daily_sums_bloc.dart';
import 'package:mal/features/reports/domain/bloc/totals/totals_bloc.dart';
import 'package:mal/features/reports/ui/widgets/daily_sums_chart.dart';
import 'package:mal/features/reports/ui/widgets/pie_chart_loader.dart';
import 'package:mal/features/reports/ui/widgets/sums_loader.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/ui/widgets/mal_title.dart';
import 'package:mal/ui/widgets/entries_list.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  var tabIndex = 0;
  @override
  void initState() {
    context.read<EntriesBloc>().add(LoadTodayEntries());
    context.read<TotalsBloc>().add(RequestTotalsData());
    context.read<DailySumsBloc>().add(RequestDailySumsData());
    context.read<CategoriesReportBloc>().add(RequestIncomesPieReportData());
    context.read<CategoriesReportBloc>().add(RequestExpensesPieReportData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MalPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
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
              return EntriesList(entries: state.today);
            },
          ),
        ],
      ),
    );
  }
}
