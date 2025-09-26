import 'package:flutter/material.dart';
import 'package:mal/constants.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/ui/views/advanced_search.dart';
import 'package:mal/features/search/ui/views/search_body.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/utils/logger.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    final bloc = context.read<SearchBloc>();
    bloc.stream.listen(logger.i);
    bloc
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
    return Container(
      color: kBgColor,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: BoxBorder.fromLTRB(bottom: BorderSide(color: kBgColor)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filled(
                  onPressed: showAdvancedModal,
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                box8,
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: searchOnChange,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.tabSearchLabel,
                      hintText: AppLocalizations.of(context)!.searchHint,
                    ),
                  ),
                ),
                box8,
                IconButton.filledTonal(
                  onPressed: clearSearch,
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Padding(padding: EdgeInsets.all(8), child: SearchBody()),
          ),
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
