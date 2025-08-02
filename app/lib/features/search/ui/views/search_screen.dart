import 'package:flutter/material.dart';
import 'package:mal/features/search/data/repositores/sql_respository.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/ui/views/search_body.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  int offset = 0;
  bool noMoreData = false;

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      height: double.infinity,
      child: RepositoryProvider(
        create: (_) => SqlRespository(),
        child: BlocProvider(
          create: (ctx) => SearchBloc(searchRepo: ctx.read<SqlRespository>()),
          child: BlocBuilder(
            builder: (BuildContext context, state) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: (value) async {
                            if (value.trim().isEmpty) return;
                            setState(() {
                              context.read<SearchBloc>().add(
                                SimpleSearch(term: value.trim()),
                              );
                            });
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(
                              context,
                            )!.tabSearchLabel,
                            hintText: AppLocalizations.of(context)!.searchHint,
                          ),
                          autofocus: true,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
