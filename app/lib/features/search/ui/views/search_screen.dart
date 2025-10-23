import 'package:flutter/material.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/ui/views/advanced_search.dart';
import 'package:mal/features/search/ui/views/search_body.dart';
import 'package:mal/features/tour/domain/showcase_cubit.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    context.read<SearchBloc>()
      ..add(FetchEntriesCategoriesList())
      ..add(FetchMaxAmount())
      ..add(FetchDateBoundries());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showcaseState = context.watch<ShowcaseCubit>().state;

    return Container(
      color: colors.surfaceContainer,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: colors.surfaceContainerHigh),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Showcase(
                  key: showcaseState.keys.filterBtn,
                  description: l10n.showCaseDescriptionFilterBtn,
                  child: IconButton.filled(
                    onPressed: showAdvancedModal,
                    icon: Icon(
                      Icons.filter_list,
                      color: colors.onPrimary,
                      size: 32,
                    ),
                  ),
                ),
                box8,
                Expanded(
                  child: Showcase(
                    key: showcaseState.keys.searchField,
                    description: l10n.showCaseDescriptionSearchField,
                    child: TextField(
                      controller: _controller,
                      onChanged: searchOnChange,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l10n.tabSearchLabel,
                        hintText: l10n.searchHint,
                      ),
                    ),
                  ),
                ),
                box8,
                Showcase(
                  key: showcaseState.keys.clearBtn,
                  description: l10n.showCaseDescriptionClearBtn,
                  child: IconButton.filledTonal(
                    onPressed: clearSearch,
                    icon: Icon(
                      Icons.delete,
                      color: colors.onSecondaryContainer,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Showcase(
              key: showcaseState.keys.searchResults,
              description: l10n.showCaseDescriptionSearchResults,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: SearchBody(),
              ),
            ),
          ),
          box40,
        ],
      ),
    );
  }

  void showAdvancedModal() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<CategoriesBloc>()),
          BlocProvider.value(value: context.read<SearchBloc>()),
        ],
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.80,
          child: const AdvancedSearch(),
        ),
      ),
    );
  }

  void searchOnChange(String value) async {
    final searchBloc = context.read<SearchBloc>();
    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthAuthenticated) return;

    if (searchBloc.state.simpleSearchActive) {
      searchBloc.add(
        SimpleSearch(term: value.trim(), userUid: authState.user.uid),
      );
      return;
    }
    searchBloc
      ..add(SetTerm(term: value.trim()))
      ..add(ApplyFilters(userUid: authState.user.uid));
  }

  void clearSearch() {
    context.read<SearchBloc>()
      ..add(ClearSearch())
      ..add(ClearFilters());

    setState(_controller.clear);
  }
}
