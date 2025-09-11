import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/features/calendar/ui/views/calendar_screen.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/ui/views/categories_screen.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/reports/domain/bloc/totals/totals_bloc.dart';
import 'package:mal/features/reports/ui/views/reports_screen.dart';
import 'package:mal/features/search/data/repositores/sql_respository.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
import 'package:mal/features/search/ui/views/search_screen.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/views/profile_screen.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/mal_page.dart';
import 'package:mal/ui/logout_button.dart';
import 'package:mal/ui/new_category_button.dart';
import 'package:mal/ui/widgets/entry_form.dart';
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
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<CategoriesBloc>().add(
        SeedCategoriedWhenEmpty(authState.user.uid),
      );
    }
    initEvents();
    super.initState();
  }

  void initEvents() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<CategoriesBloc>().add(AppInit(authState.user.uid));
      context.read<EntriesBloc>().add(LoadTodayEntries(authState.user.uid));
      context.read<TotalsBloc>().add(RequestTotalsData(authState.user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;
    final authState = context.read<AuthBloc>().state;

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
        actions: [NewCategoryButton(theme: theme)],
      ),

      MalPage(
        icon: const Icon(Icons.calendar_month),
        title: l10n.tabCalendarLabel,
        widget: (key) => CalendarScreen(key: key),
        actions: [],
      ),
      MalPage(
        avatar: authState is AuthAuthenticated && authState.user.avatar != null
            ? FileImage(File(authState.user.avatar!))
            : null,
        title: authState is AuthAuthenticated
            ? authState.user.name.substring(0, 4)
            : l10n.profileLabel,
        widget: (key) => ProfileScreen(key: key),
        actions: [const LogoutButton()],
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
                    try {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is AuthAuthenticated) {
                        final userUid = authState.user.uid;

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
                            child: EntryForm(userUid: userUid),
                          ),
                        );
                        initEvents();
                      } else {
                        context.go('/login');
                      }
                    } catch (e, t) {
                      logger
                        ..e(e)
                        ..t(t);
                    }
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
              (page) => BottomNavigationBarItem(
                icon:
                    page.icon ??
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: page.avatar,
                      backgroundColor: Colors.white,
                    ),
                label: page.title,
              ),
            )
            .toList(),
      ),
    );
  }
}
