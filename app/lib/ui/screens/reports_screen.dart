import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/providers/categories_provider.dart';
import 'package:mal/providers/entries_provider.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/ui/widgets/daily_sums_chart.dart';
import 'package:mal/ui/widgets/mal_pie_chart.dart';
import 'package:mal/ui/widgets/sums_card.dart';
import 'package:mal/ui/widgets/today_entries_list.dart';
import 'package:mal/utils.dart';

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

    final entries = ref.watch(entriesProvider);
    return MalPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          FutureBuilder<Totals>(
            future: loadTotals(),
            builder: (BuildContext context, AsyncSnapshot<Totals> snapshot) {
              if (snapshot.hasData) {
                return SumsCard(l10n: l10n, totals: snapshot.data!);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(height: 16),
          Text(
            l10n.currentMonth,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          const Card.filled(color: Colors.white, child: DailySumsChart()),
          const SizedBox(height: 16),
          Text(
            l10n.expenses,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Card.filled(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: getPieData(l10n.expense),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return MalPieChart(list: snapshot.data!);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.income,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Card.filled(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: getPieData(l10n.income),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return MalPieChart(list: snapshot.data!);
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.todayEntries,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          TodayEntriesList(entries: entries),
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

  Future<Totals> loadTotals() async {
    final db = await createOrOpenDB();

    final incomes = await db.query(
      'entries',
      columns: ['sum(amount) as sum', 'type'],
      where: 'type = ?',
      whereArgs: ['دخل'],
      groupBy: '"type"',
    );
    final expenses = await db.query(
      'entries',
      columns: ['sum(amount) as sum', 'type'],
      where: 'type = ?',
      whereArgs: ['منصرف'],
      groupBy: '"type"',
    );
    final balance =
        (incomes.first['sum'] as int) - (expenses.first['sum'] as int);
    return Totals(
      balance: balance,
      incomes: incomes.first['sum'] as int,
      expenses: expenses.first['sum'] as int,
    );
  }
}
