import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/calendar/ui/views/calendar_screen.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/ui/views/categories_screen.dart';
import 'package:mal/features/reports/ui/views/reports_screen.dart';
import 'package:mal/features/search/data/repositores/sql_respository.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
import 'package:mal/features/search/ui/views/search_screen.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/views/profile_screen.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/mal_page.dart';
import 'package:mal/ui/add_entry_button.dart';
import 'package:mal/ui/bottom_button.dart';
import 'package:mal/ui/half_border_fab.dart';
import 'package:mal/ui/logout_button.dart';
import 'package:mal/ui/new_category_button.dart';
import 'package:mal/utils.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  late PageController _pageController;
  int tabIndex = 4;

  List<MalPage> pages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: tabIndex);
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    context.read<CategoriesBloc>().add(
      SeedCategoriedWhenEmpty(authState.user.uid),
    );
    context.read<CategoriesBloc>().add(AppInit(authState.user.uid));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;
    final authState = context.read<AuthBloc>().state;

    pages = [
      MalPage(
        icon: const Icon(Icons.pie_chart, size: 24),
        title: l10n.reportsTitle,
        widget: (key) => ReportsScreen(key: key),
      ),
      MalPage(
        icon: const Icon(Icons.file_copy, size: 24),
        title: l10n.tabCategoriesLabel,
        widget: (key) => BlocProvider.value(
          value: context.read<CategoriesBloc>(),
          child: CategoriesScreen(key: key),
        ),
        action: NewCategoryButton(theme: theme),
      ),
      MalPage(
        icon: const Icon(Icons.search, size: 24),
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
      ),
      MalPage(
        icon: const Icon(Icons.calendar_month, size: 24),
        title: l10n.tabCalendarLabel,
        widget: (key) => CalendarScreen(key: key),
      ),
      MalPage(
        avatar: authState is AuthAuthenticated && authState.user.avatar != null
            ? FileImage(File(authState.user.avatar!))
            : null,
        title: authState is AuthAuthenticated
            ? authState.user.name
            : l10n.profileLabel,
        widget: (key) => ProfileScreen(key: key),
        action: const LogoutButton(),
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
        iconTheme: IconThemeData(color: theme.primary.withAlpha(100)),
        actions: [
          if (tabIndex != 4)
            IconButton.filled(
              icon: CircleAvatar(
                radius: 18,
                backgroundImage: pages[4].avatar,
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                onTabPress(4);
              },
            ),
          box16,
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
      floatingActionButton: HalfBorderFab(
        child: pages[tabIndex].action ?? AddEntryButton(l10n: l10n),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 88,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomButton(
              activeTab: tabIndex,
              pages: pages,
              index: 0,
              onPressed: () {
                onTabPress(0);
              },
            ),
            BottomButton(
              activeTab: tabIndex,
              pages: pages,
              index: 1,
              onPressed: () {
                onTabPress(1);
              },
            ),
            const SizedBox(width: 48),
            BottomButton(
              activeTab: tabIndex,
              pages: pages,
              index: 2,
              onPressed: () {
                onTabPress(2);
              },
            ),
            BottomButton(
              activeTab: tabIndex,
              pages: pages,
              index: 3,
              onPressed: () {
                onTabPress(3);
              },
            ),
          ],
        ),
      ),
    );
  }

  void onTabPress(int index) {
    setState(() {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      tabIndex = index;
    });
  }
}
