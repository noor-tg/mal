import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
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
    final searchBloc = context.read<SearchBloc>();
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        final authState = context.read<AuthBloc>().state;

        if (authState is! AuthAuthenticated) return;

        if (searchBloc.state.status == SearchStatus.loading) return;

        searchBloc.add(LoadMore(userUid: authState.user.uid));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shimmerList = ShimmerList(
      height: 80,
      radius: 8,
      subColor: colors.surface,
      mainColor: colors.surfaceDim,
      qtyLine: 1,
    );
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (ctx, state) {
        switch (state.status) {
          case SearchStatus.loading:
            return shimmerList;
          case SearchStatus.initial:
            return const NoDataCentered();
          case SearchStatus.success:
            if (state.result.list.isEmpty) {
              return const NoDataCentered();
            }
            return resultsInfo(
              state: state,
              context: context,
              shimmerList: shimmerList,
            );
          case SearchStatus.failure:
            return Text('error :: ${state.errorMessage}');
        }
      },
    );
  }

  Widget resultsInfo({
    required SearchState state,
    required BuildContext context,
    required ShimmerList shimmerList,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${l10n.searchTitleResults} : ${state.result.count}',
            style: texts.titleLarge?.copyWith(color: colors.onSurface),
          ),
        ),
        box8,
        Expanded(
          child: Card(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.result.list.length,
                    itemBuilder: (ctx, index) =>
                        listItemBuilder(ctx, index, state),
                  ),
                  if (state.result.list.length < state.result.count)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: shimmerList,
                    ),
                  if (state.noMoreData)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            l10n.noMoreData,
                            style: texts.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? listItemBuilder(BuildContext context, int index, SearchState state) {
    final entry = state.result.list[index];
    return ListTile(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (ctx) => EntryDetails(entry: entry)));
      },
      title: Text(
        '${index + 1} - ${entry.description.length > 25 ? entry.description.substring(0, 24) : entry.description}',
        style: texts.titleMedium?.copyWith(color: colors.onSurface),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.category,
            style: texts.bodyLarge?.copyWith(
              color: colors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            toDate(DateTime.parse(entry.date)),
            style: texts.bodyLarge?.copyWith(
              color: colors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      isThreeLine: true,
      trailing: Text(
        entry.prefixedAmount(l10n.income),
        style: texts.bodyLarge?.copyWith(color: entry.color(l10n.income)),
      ),
    );
  }
}
