import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/domain/bloc/sorting.dart';
import 'package:mal/l10n/app_localizations.dart';

class Sorting extends StatelessWidget {
  const Sorting({super.key, required this.l10n, required this.theme});

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
                l10n.order,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Builder(
                builder: (context) {
                  final searchBloc = context.watch<SearchBloc>();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4.0,
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          ...SortingField.values.map(
                            (field) => OutlinedButton(
                              onPressed: () {
                                searchBloc.add(SortBy(field: field));
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    searchBloc.state.sorting.field == field
                                    ? Colors.green.withAlpha(30)
                                    : theme.colorScheme.primaryContainer
                                          .withAlpha(30),
                                foregroundColor:
                                    searchBloc.state.sorting.field == field
                                    ? Colors.green
                                    : theme.colorScheme.primary,
                                side: BorderSide(
                                  // Set the border color conditionally, just like your other properties
                                  color: searchBloc.state.sorting.field == field
                                      ? Colors.green
                                      : theme.colorScheme.primary,

                                  // You can also change the border width
                                  width: 1.5,
                                ),
                              ),
                              child: Wrap(
                                spacing: 4,
                                children: [
                                  if (field == SortingField.date)
                                    Text(l10n.date),
                                  if (field == SortingField.amount)
                                    Text(l10n.amount),
                                  if (field == SortingField.category)
                                    Text(l10n.category),
                                  if (field == SortingField.description)
                                    Text(l10n.description),
                                  if (field == SortingField.type)
                                    Text(l10n.type),
                                  if (searchBloc.state.sorting.field == field)
                                    Transform.flip(
                                      flipY:
                                          searchBloc.state.sorting.direction ==
                                              SortingDirection.asc
                                          ? false
                                          : true,
                                      child: const Icon(Icons.sort),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
