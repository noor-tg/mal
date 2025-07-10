import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/ui/widgets/sums_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  var tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;

    return MalPageContainer(
      child: Column(
        children: [
          SizedBox(height: 16),
          SumsCard(l10n: l10n),
          SizedBox(height: 16),
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
