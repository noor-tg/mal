import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/calendar/ui/views/calendar_screen.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/ui/views/categories_screen.dart';
import 'package:mal/features/reports/ui/views/reports_screen.dart';
import 'package:mal/features/search/ui/views/search_screen.dart';
import 'package:mal/features/tour/data/showcase_keys_data.dart';
import 'package:mal/features/tour/domain/showcase_cubit.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/views/profile_screen.dart';
import 'package:mal/mal_page.dart';
import 'package:mal/shared/domain/bloc/theme/theme_bloc.dart';
import 'package:mal/ui/add_entry_button.dart';
import 'package:mal/ui/bottom_button.dart';
import 'package:mal/ui/half_border_fab.dart';
import 'package:mal/ui/logout_button.dart';
import 'package:mal/ui/theme_switcher_btn.dart';
import 'package:mal/ui/tour_guide_container.dart';
import 'package:mal/utils.dart';
import 'package:showcaseview/showcaseview.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  List<MalPage> pages = [];

  @override
  void initState() {
    _setupData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final showcaseState = context.watch<ShowcaseCubit>().state;
    final themeState = context.watch<ThemeBloc>().state;

    pages = makePages(authState, showcaseState);

    return TourGuideContainer(
      firstShowCaseKey: showcaseState.wrapperKeys.first,
      lastShowCaseKey: showcaseState.wrapperKeys.last,
      // NOTICE: the builder is needed to provide context for the showcase runner
      child: Builder(
        builder: (ctx) => _buildScaffold(ctx, themeState, showcaseState),
      ),
    );
  }

  List<MalPage> makePages(AuthState authState, ShowcaseState showcaseState) {
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
      ),
      MalPage(
        icon: const Icon(Icons.search, size: 24),
        title: l10n.tabSearchLabel,
        widget: (key) => SearchScreen(key: key),
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
        action: Showcase(
          key: showcaseState.keys.logoutBtn,
          description: l10n.showCaseDescriptionLogoutBtn,
          child: const LogoutButton(),
        ),
      ),
    ];
  }

  Scaffold _buildScaffold(
    BuildContext context,
    ThemeState themeState,
    ShowcaseState showcaseState,
  ) {
    final keys = showcaseState.keys;
    return Scaffold(
      resizeToAvoidBottomInset: true, // This is important
      appBar: appBar(themeState, context, keys),
      body: indexedStack(themeState),
      floatingActionButton: HalfBorderFab(
        child:
            pages[themeState.tabIndex].action ??
            Showcase(
              key: keys.newEntryBtn,
              description: l10n.showCaseDescriptionNewEntry,
              child: const AddEntryButton(),
            ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomAppBar(themeState, keys),
    );
  }

  AppBar appBar(ThemeState state, BuildContext context, ShowcaseKeysData keys) {
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
        IconButton(
          icon: Transform.flip(
            flipX: true,
            child: Icon(
              Icons.help_outline,
              color: colors.onSecondaryContainer.withAlpha(150),
            ),
          ),
          onPressed: () {
            showCaseActivate(state.tabIndex, context);
          },
          tooltip: l10n.help,
        ),
        ThemeSwitcherBtn(
          activeMode: state.themeMode,
          showCaseKey: keys.themeSwitcher,
        ),
        if (state.tabIndex != 4)
          Showcase(
            key: keys.profileBtn,
            description: l10n.showCaseDescriptionUserProfile,
            child: IconButton(
              icon: CircleAvatar(
                radius: 18,
                backgroundImage: pages[4].avatar,
                backgroundColor: colors.onPrimary,
              ),
              onPressed: () {
                onTabPress(4);
              },
            ),
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

  BottomAppBar bottomAppBar(ThemeState state, ShowcaseKeysData keys) {
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

    context.read<CategoriesBloc>().add(AppInit(authState.user.uid));
  }

  void showCaseActivate(int tabIndex, BuildContext context) {
    context.read<ShowcaseCubit>().activateShowcaseForTab(tabIndex);
    final activeKeys = context.read<ShowcaseCubit>().state.activeKeys;
    // ignore: deprecated_member_use
    ShowCaseWidget.of(context).startShowCase(activeKeys);
  }
}
