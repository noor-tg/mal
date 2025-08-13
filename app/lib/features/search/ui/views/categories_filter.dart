import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';

class CategoriesFilter extends StatelessWidget {
  const CategoriesFilter({super.key, required this.l10n, required this.theme});

  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card.filled(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                l10n.categories,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Builder(
                builder: (context) {
                  final categoriesState = context.watch<CategoriesBloc>().state;
                  final searchBloc = context.watch<SearchBloc>();
                  return Row(
                    spacing: 8,
                    children: [
                      for (final category in categoriesState.categories.list)
                        OutlinedButton(
                          onPressed: () {
                            searchBloc.add(
                              ToggleCategory(category: category.title),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                searchBloc.state.filters.categories.contains(
                                  category.title,
                                )
                                ? Colors.green.withAlpha(30)
                                : theme.colorScheme.primaryContainer.withAlpha(
                                    30,
                                  ),
                            foregroundColor:
                                searchBloc.state.filters.categories.contains(
                                  category.title,
                                )
                                ? Colors.green
                                : theme.colorScheme.primary,
                            side: BorderSide(
                              // Set the border color conditionally, just like your other properties
                              color:
                                  searchBloc.state.filters.categories.contains(
                                    category.title,
                                  )
                                  ? Colors.green
                                  : theme.colorScheme.primary,

                              // You can also change the border width
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            spacing: 5,
                            children: [
                              Text(category.title),
                              if (searchBloc.state.filters.categories.contains(
                                category.title,
                              ))
                                const Icon(Icons.close_outlined),
                            ],
                          ),
                        ),
                    ],
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
