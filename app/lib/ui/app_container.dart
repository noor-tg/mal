import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/calendar/ui/views/calendar_screen.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/ui/views/categories_screen.dart';
import 'package:mal/features/categories/ui/widgets/new_category.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/reports/domain/bloc/totals/totals_bloc.dart';
import 'package:mal/features/reports/ui/views/reports_screen.dart';
import 'package:mal/features/search/data/repositores/sql_respository.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
import 'package:mal/features/search/ui/views/search_screen.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/widgets/entry_form.dart';
import 'package:mal/ui/widgets/main_drawer.dart';
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
  void initState() {
    context.read<CategoriesBloc>().add(SeedCategoriedWhenEmpty());
    initEvents();
    super.initState();
  }

  void initEvents() {
    context.read<CategoriesBloc>().add(AppInit());
    context.read<EntriesBloc>().add(LoadTodayEntries());
    context.read<TotalsBloc>().add(RequestTotalsData());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;

    pages = [
      MalPage(
        icon: const Icon(Icons.pie_chart),
        title: l10n.reportsTitle,
        widget: (key) => ReportsScreen(key: key),
        actions: [],
      ),
      MalPage(
        icon: const Icon(Icons.search),
        title: l10n.tabSearchLabel,
        widget: (key) => RepositoryProvider<SearchRepository>(
          key: key,
          create: (_) => SqlRespository(),
          child: BlocProvider(
            create: (ctx) =>
                SearchBloc(searchRepo: ctx.read<SearchRepository>()),
            child: const SearchScreen(),
          ),
        ),
        actions: [],
      ),
      MalPage(
        icon: const Icon(Icons.dashboard),
        title: l10n.tabCategoriesLabel,
        widget: (key) => BlocProvider.value(
          value: context.read<CategoriesBloc>(),
          child: CategoriesScreen(key: key),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard_customize, color: theme.onPrimary),
            onPressed: () async {
              await showModalBottomSheet(
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (ctx) {
                  final categoriesBloc = context.read<CategoriesBloc>();
                  return BlocProvider.value(
                    value: categoriesBloc,
                    child: const NewCategory(),
                  );
                },
              );
            },
          ),
        ],
      ),

      MalPage(
        icon: const Icon(Icons.calendar_month),
        title: l10n.tabCalendarLabel,
        widget: (key) => CalendarScreen(key: key),
        actions: [],
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true, // This is important
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
                  onPressed: () async {
                    await showModalBottomSheet(
                      useSafeArea: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (ctx) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<EntriesBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<CategoriesBloc>(),
                          ),
                        ],
                        child: const EntryForm(),
                      ),
                    );
                    initEvents();
                  },
                ),
              ],
      ),
      body: PageView.builder(
        itemCount: pages.length,
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) => setState(() => tabIndex = index),
        itemBuilder: (BuildContext context, int index) {
          // use Unieque key to make full reload of widget on tab change
          return pages[index].widget(
            ValueKey(tabIndex == index ? UniqueKey() : null),
          );
        },
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
      ),
    );
  }
}
