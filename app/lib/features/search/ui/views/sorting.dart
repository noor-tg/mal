import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/domain/bloc/sorting.dart';
import 'package:mal/utils.dart';

class Sorting extends StatelessWidget {
  const Sorting({super.key});

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
                context.l10n.order,
                style: context.texts.titleLarge?.copyWith(
                  color: context.colors.onSurface,
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
                          ...SortingField.values.map((field) {
                            final activeField =
                                searchBloc.state.sorting.field == field;
                            final activeBg = context.green.withAlpha(30);
                            final defaultBg = context.colors.primaryContainer
                                .withAlpha(30);
                            final activeColor = context.green;
                            final defaultColor = context.colors.primary;
                            return OutlinedButton(
                              onPressed: () {
                                searchBloc.add(SortBy(field: field));
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: activeField
                                    ? activeBg
                                    : defaultBg,
                                foregroundColor: activeField
                                    ? activeColor
                                    : defaultColor,
                                side: BorderSide(
                                  // Set the border color conditionally, just like your other properties
                                  color: activeField
                                      ? activeColor
                                      : defaultColor,

                                  // You can also change the border width
                                  width: 1.5,
                                ),
                              ),
                              child: Wrap(
                                spacing: 4,
                                children: [
                                  if (field == SortingField.date)
                                    SortText(
                                      text: context.l10n.date,
                                      color: activeField
                                          ? activeColor
                                          : defaultColor,
                                    ),
                                  if (field == SortingField.amount)
                                    SortText(
                                      text: context.l10n.amount,
                                      color: activeField
                                          ? activeColor
                                          : defaultColor,
                                    ),
                                  if (field == SortingField.category)
                                    SortText(
                                      text: context.l10n.category,
                                      color: activeField
                                          ? activeColor
                                          : defaultColor,
                                    ),
                                  if (field == SortingField.description)
                                    SortText(
                                      text: context.l10n.description,
                                      color: activeField
                                          ? activeColor
                                          : defaultColor,
                                    ),
                                  if (field == SortingField.type)
                                    SortText(
                                      text: context.l10n.type,
                                      color: activeField
                                          ? activeColor
                                          : defaultColor,
                                    ),
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
                            );
                          }),
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

class SortText extends StatelessWidget {
  final String text;

  final Color? color;

  const SortText({required this.text, super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.texts.labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
