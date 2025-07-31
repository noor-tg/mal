import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/screens/categories_screen.dart';
import 'package:mal/ui/screens/reports_screen.dart';
import 'package:mal/ui/screens/search_screen.dart';
import 'package:mal/ui/widgets/entry_form.dart';
import 'package:mal/ui/widgets/main_drawer.dart';
import 'package:mal/ui/widgets/new_category.dart';
import 'package:mal/utils.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  final PageController _pageController = PageController();
  var tabIndex = 0;

  List<MalPage> pages = [];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;

    pages = [
      MalPage(
        icon: const Icon(Icons.pie_chart),
        title: l10n.reportsTitle,
        widget: const ReportsScreen(),
        actions: [],
      ),
      MalPage(
        icon: const Icon(Icons.search),
        title: l10n.tabSearchLabel,
        widget: const SearchScreen(),
        actions: [],
      ),
      MalPage(
        icon: const Icon(Icons.dashboard),
        title: l10n.tabCategoriesLabel,
        widget: const CategoriesScreen(),
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard_customize, color: theme.onPrimary),
            onPressed: () {
              showModalBottomSheet(
                useSafeArea: true,
                isScrollControlled: true,
                // constraints: const BoxConstraints(maxHeight: 400),
                context: context,
                builder: (ctx) => const NewCategory(),
              );
            },
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pages[tabIndex].title,
          style: TextStyle(color: theme.onPrimary),
        ),
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.onPrimary),
        actions: pages[tabIndex].actions.isNotEmpty
            ? pages[tabIndex].actions
            : [
                IconButton(
                  icon: Icon(Icons.create, color: theme.onPrimary),
                  onPressed: () {
                    showModalBottomSheet(
                      useSafeArea: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (ctx) => const EntryForm(),
                    );
                  },
                ),
              ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) => setState(() => tabIndex = index),
        children: pages.map((page) => page.widget).toList(),
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 40,
        type: BottomNavigationBarType.fixed,
        currentIndex: tabIndex,
        onTap: (index) {
          setState(() {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            tabIndex = index;
          });
        },
        items: pages
            .map(
              (page) =>
                  BottomNavigationBarItem(icon: page.icon, label: page.title),
            )
            .toList(),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.search),
        //   label: AppLocalizations.of(context)!.tabSearchLabel,
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.calendar_today),
        //   label: AppLocalizations.of(context)!.tabCalendarLabel,
        // ),
      ),
    );
  }
}
