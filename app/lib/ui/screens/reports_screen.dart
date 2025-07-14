import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/providers/entries_provider.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/ui/widgets/sums_card.dart';
import 'package:mal/ui/widgets/today_entries_list.dart';

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
        children: [
          const SizedBox(height: 16),
          SumsCard(l10n: l10n),
          const SizedBox(height: 16),
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
}
