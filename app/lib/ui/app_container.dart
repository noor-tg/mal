import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/models/entry.dart';
import 'package:mal/ui/screens/categories_screen.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/ui/screens/reports_screen.dart';
import 'package:mal/ui/widgets/entry_form.dart';
import 'package:mal/ui/widgets/main_drawer.dart';
import 'package:mal/ui/widgets/new_category.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';
import 'package:mal/utils.dart';
import 'package:shimmer_effects_plus/shimmer_effects_plus.dart';

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
                      // constraints: const BoxConstraints(maxHeight: 400),
                      context: context,
                      builder: (ctx) => EntryForm(),
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String term = '';
  Object? currentError;
  bool isLoading = false;
  List<Entry> searchResults = [];

  @override
  void initState() {
    searchResults = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const NoDataCentered();

    if (isLoading) {
      body = ShimmerList(
        height: 80,
        radius: 8,
        subColor: Colors.white,
        mainColor: Colors.grey[300]!,
        qtyLine: 5,
      );
    }
    if (currentError != null) {
      return Text('error :: $currentError');
    }
    if (searchResults.isNotEmpty) {
      body = Card.filled(
        color: Colors.white,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: searchResults.length,
          separatorBuilder: (BuildContext context, int index) {
            return Container(height: 1, color: Colors.grey.shade300);
          },
          itemBuilder: (BuildContext context, int index) => ListTile(
            title: Text(
              searchResults[index].description,
              style: const TextStyle(height: 2, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                Text(searchResults[index].type),
                box8,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Text(searchResults[index].category),
                ),
              ],
            ),
            trailing: Text(searchResults[index].amount.toString()),
          ),
        ),
      );
    }

    return MalPageContainer(
      child: Column(
        children: [
          TextField(
            onChanged: (value) async {
              try {
                if (value.trim().isEmpty) return;
                setState(() {
                  isLoading = true;
                  searchResults = [];
                });
                final results = await searchEntries(value);
                setState(() {
                  searchResults = results;
                  isLoading = false;
                });
              } catch (error) {
                isLoading = false;
                searchResults = [];
                logger.e(error);
                currentError = error;
              }
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.tabSearchLabel,
              hintText: AppLocalizations.of(context)!.searchHint,
            ),
            autofocus: true,
          ),
          box24,
          body,
        ],
      ),
    );
  }

  Future<List<Entry>> searchEntries(String term) async {
    try {
      await Future.delayed(const Duration(seconds: 5));

      final db = await createOrOpenDB();
      final search = '%$term%';
      final res = await db.query(
        'entries',
        where: 'type = ? or category like ? or description like ?',
        whereArgs: [term, search, search],
      );
      final List<Entry> data = [];
      for (final item in res) {
        data.add(
          Entry(
            uid: item['uid'] as String,
            description: item['description'] as String,
            amount: item['amount'] as int,
            category: item['category'] as String,
            type: item['type'] as String,
          ),
        );
      }
      return data;
    } catch (error) {
      logger.t(error);
    }
    return [];
  }
}
