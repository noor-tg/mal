import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
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
  late StreamSubscription _blocSubscription;

  @override
  void initState() {
    super.initState();
    _blocSubscription = context.read<SearchBloc>().stream.listen(
      logger.i,
      // ignore: unnecessary_lambdas
      onError: (error) => logger.t(error),
    );
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (context.read<SearchBloc>().state.status == SearchStatus.loading) {
          return;
        }
        context.read<SearchBloc>().add(LoadMore());
      }
    });
  }

  @override
  void dispose() {
    _blocSubscription.cancel();
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
