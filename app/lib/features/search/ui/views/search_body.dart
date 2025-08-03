import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/widgets/entry_details.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';
import 'package:mal/utils.dart';
import 'package:shimmer_effects_plus/shimmer_effects_plus.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({super.key});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final shimmerList = ShimmerList(
      height: 80,
      radius: 8,
      subColor: Colors.white,
      mainColor: Colors.grey[300]!,
      qtyLine: 2,
    );
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (ctx, state) {
        logger
          ..i('builder state:')
          ..i(state);
        switch (state.status) {
          case SearchStatus.loading:
            return shimmerList;
          case SearchStatus.initial:
            return const NoDataCentered();
          case SearchStatus.success:
            if (state.result.list.isEmpty) {
              return const NoDataCentered();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.searchTitleResults} : ${state.result.count}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                box8,
                Card.filled(
                  color: Colors.white,
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: state.result.list.length + 1,
                    itemBuilder: (ctx, int index) {
                      if (index < state.result.list.length) {
                        final entry = state.result.list[index];
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => EntryDetails(entry: entry),
                              ),
                            );
                          },
                          title: Text(
                            entry.description,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey.shade800,
                            ),
                          ),
                          subtitle: Text(
                            entry.category,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade800,
                            ),
                          ),
                          trailing: Text(
                            entry.prefixedAmount(l10n!.income),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: entry.color(l10n.income),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: state.noMoreData
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Text(
                                      l10n!.noMoreData,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                          ),
                                    ),
                                  ),
                                )
                              : shimmerList,
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          case SearchStatus.failure:
            return Text('error :: ${state.errorMessage}');
        }
      },
    );
  }
}
