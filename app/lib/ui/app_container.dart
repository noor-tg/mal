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
import 'package:mal/mal_page.dart';
import 'package:mal/shared/domain/bloc/theme/theme_bloc.dart';
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
  List<MalPage> pages = [];

  @override
  void initState() {
    super.initState();
    _setupData();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    pages = makePages(context, authState);

    return BlocBuilder<ThemeBloc, ThemeState>(builder: _buildScaffold);
  }

  List<MalPage> makePages(BuildContext context, AuthState authState) {
    return [
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
        action: const NewCategoryButton(),
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
  }

  Scaffold _buildScaffold(BuildContext context, ThemeState state) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // This is important
      appBar: appBar(state, context),
      body: indexedStack(state),
      floatingActionButton: HalfBorderFab(
        child: pages[state.tabIndex].action ?? const AddEntryButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomAppBar(state),
    );
  }

  AppBar appBar(ThemeState state, BuildContext context) {
    return AppBar(
      title: Text(
        pages[state.tabIndex].title,
        style: theme.appBarTheme.titleTextStyle?.copyWith(
          fontWeight: FontWeight.bold,
          backgroundColor: colors.onSecondary,
        ),
      ),
      backgroundColor: colors.secondaryContainer,
      iconTheme: IconThemeData(color: colors.onPrimary.withAlpha(100)),
      actions: [
        Switch(
          value: state.themeMode == ThemeMode.light,
          onChanged: (value) {
            context.read<ThemeBloc>().add(
              ChangeThemeEvent(value ? ThemeMode.light : ThemeMode.dark),
            );
          },
        ),
        if (state.tabIndex != 4)
          IconButton(
            icon: CircleAvatar(
              radius: 18,
              backgroundImage: pages[4].avatar,
              backgroundColor: colors.onPrimary,
            ),
            onPressed: () {
              onTabPress(4);
            },
          ),
        box16,
      ],
    );
  }

  IndexedStack indexedStack(ThemeState state) {
    return IndexedStack(
      index: state.tabIndex,

      children: pages
          .map((page) => page.widget(ValueKey(uuid.v4())) as Widget)
          .toList(),
    );
  }

  BottomAppBar bottomAppBar(ThemeState state) {
    return BottomAppBar(
      height: 88,
      color: colors.surfaceBright,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomButton(
            activeTab: state.tabIndex,
            pages: pages,
            index: 0,
            onPressed: () => onTabPress(0),
          ),
          BottomButton(
            activeTab: state.tabIndex,
            pages: pages,
            index: 1,
            onPressed: () => onTabPress(1),
          ),
          const SizedBox(width: 48),
          BottomButton(
            activeTab: state.tabIndex,
            pages: pages,
            index: 2,
            onPressed: () => onTabPress(2),
          ),
          BottomButton(
            activeTab: state.tabIndex,
            pages: pages,
            index: 3,
            onPressed: () => onTabPress(3),
          ),
        ],
      ),
    );
  }

  void onTabPress(int index) {
    context.read<ThemeBloc>().add(ChangeTab(index));
  }

  void _setupData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    context.read<CategoriesBloc>().add(
      SeedCategoriedWhenEmpty(authState.user.uid),
    );
    context.read<CategoriesBloc>().add(AppInit(authState.user.uid));
  }
}
