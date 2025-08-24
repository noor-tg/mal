import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/providers/entries_provider.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/ui/widgets/daily_sums_chart.dart';
import 'package:mal/ui/widgets/mal_title.dart';
import 'package:mal/ui/widgets/pie_chart_loader.dart';
import 'package:mal/ui/widgets/sums_loader.dart';
import 'package:mal/ui/widgets/entries_list.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  var tabIndex = 0;
  @override
  void initState() {
    super.initState();
    ref.read(entriesProvider.notifier).loadEntries();
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
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       AppLocalizations.of(context)!.reportsTitle,
    //       style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    //     ),
    //     backgroundColor: Theme.of(context).colorScheme.primary,
    //     iconTheme: IconThemeData(
    //       color: Theme.of(context).colorScheme.onPrimary,
    //     ),
    //     // centerTitle: true,
    //     actions: [
    //       IconButton(
    //         icon: Icon(
    //           Icons.create,
    //           color: Theme.of(context).colorScheme.onPrimary,
    //         ),
    //         onPressed: () {},
    //       ),
    //     ],
    //   ),
    //   body: body,
    //   drawer: MainDrawer(),
    //   bottomNavigationBar: BottomNavigationBar(
    //     elevation: 40,
    //     type: BottomNavigationBarType.fixed,
    //     currentIndex: tabIndex,
    //     onTap: (index) {
    //       setState(() {
    //         tabIndex = index;
    //       });
    //     },
    //     items: [
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.pie_chart),
    //         label: AppLocalizations.of(context)!.tabReportsLabel,
    //       ),
    //       // BottomNavigationBarItem(
    //       //   icon: Icon(Icons.search),
    //       //   label: AppLocalizations.of(context)!.tabSearchLabel,
    //       // ),
    //       // BottomNavigationBarItem(
    //       //   icon: Icon(Icons.calendar_today),
    //       //   label: AppLocalizations.of(context)!.tabCalendarLabel,
    //       // ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.category),
    //         label: AppLocalizations.of(context)!.tabCategoriesLabel,
    //       ),
    //     ],
    //   ),
    // );
  }
}
