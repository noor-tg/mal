import 'package:flutter/material.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/ui/views/advanced_search.dart';
import 'package:mal/features/search/ui/views/search_body.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  var scrollController = ScrollController();

  @override
  void initState() {
    final searchBloc = context.read<SearchBloc>();
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (searchBloc.state.status == SearchStatus.loading) {
          return;
        }
        searchBloc.add(LoadMore());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // _blocSubscription.cancel();
    scrollController.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        useSafeArea: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (ctx) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<CategoriesBloc>(),
                            ),
                            BlocProvider.value(
                              value: context.read<SearchBloc>(),
                            ),
                          ],
                          child: const AdvancedSearch(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.filter_list, color: Colors.blue),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) async {
                        if (value.trim().isEmpty) return;
                        context.read<SearchBloc>().add(
                          SimpleSearch(term: value.trim()),
                        );
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.tabSearchLabel,
                        hintText: AppLocalizations.of(context)!.searchHint,
                      ),
                      // autofocus: true,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        context.read<SearchBloc>().add(ClearSearch());
                        _controller.clear();
                      });
                    },
                    icon: const Icon(Icons.delete, color: Colors.blue),
                  ),
                ],
              ),
              box24,
              const SearchBody(),
            ],
          ),
        ),
      ),
    );
  }
}
