import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/utils.dart';

class CategoriesFilter extends StatelessWidget {
  const CategoriesFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: context.colors.surfaceBright,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                context.l10n.categories,
                style: context.texts.titleLarge?.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              Builder(
                builder: (context) {
                  final searchBloc = context.watch<SearchBloc>();
                  return Center(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4.0,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        for (final category in searchBloc.state.categories)
                          OutlinedButton(
                            onPressed: () {
                              searchBloc.add(
                                ToggleCategory(category: category),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  searchBloc.state.filters.categories.contains(
                                    category,
                                  )
                                  ? Colors.green.withAlpha(30)
                                  : context.colors.primaryContainer.withAlpha(
                                      30,
                                    ),
                              foregroundColor:
                                  searchBloc.state.filters.categories.contains(
                                    category,
                                  )
                                  ? Colors.green
                                  : context.colors.primary,
                              side: BorderSide(
                                // Set the border color conditionally, just like your other properties
                                color:
                                    searchBloc.state.filters.categories
                                        .contains(category)
                                    ? Colors.green
                                    : context.colors.primary,

                                // You can also change the border width
                                width: 1.5,
                              ),
                            ),
                            child: Wrap(
                              spacing: 4,
                              children: [
                                Text(category),
                                if (searchBloc.state.filters.categories
                                    .contains(category))
                                  const Icon(Icons.close_outlined),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
