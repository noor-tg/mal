import 'package:flutter/material.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/logger.dart';

class DateRangeFilter extends StatefulWidget {
  const DateRangeFilter({super.key, required this.l10n, required this.theme});

  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  State<DateRangeFilter> createState() => _DateRangeFilterState();
}

class _DateRangeFilterState extends State<DateRangeFilter> {
  late int max;
  late RangeValues values;

  late DateTime defaultMin;
  late DateTime defaultMax;

  @override
  void initState() {
    // entries date range
    final searchState = context.read<SearchBloc>().state;

    final entriesDateRange = searchState.dateRange;
    final filtersDateRange = searchState.filters.dateRange;

    defaultMin = entriesDateRange.min;
    defaultMax = entriesDateRange.max;

    // so I want to handle default state for min date as current year first day
    // for example 2025-1-1
    // and max date to current date 2025-9-25
    // but then there is 2 possiblities
    // 1. user change min and max
    // 2. the default min and max fetched from the entries table
    // --- here if there is no entries. set to default
    // --- else set to entries min and max

    // Convert dates to days since startOfYear

    final minValue = filtersDateRange.min
        .difference(defaultMin)
        .inDays
        .toDouble();
    final maxValue = filtersDateRange.max
        .difference(defaultMin)
        .inDays
        .toDouble();
    logger.i('min: $defaultMin, max: $defaultMax, filters: $filtersDateRange');

    values = RangeValues(minValue, maxValue);
    max = maxValue.toInt();
    logger.i(
      'fullMax: ${defaultMin.difference(defaultMax).inDays.toDouble()},\n minValue: $minValue,\n maxValue: $maxValue,\n defaultMin: $defaultMin,\n defaultMax: $defaultMax',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rangeLabels = RangeLabels(
      toDate(defaultMin.add(Duration(days: values.start.floor()))),
      toDate(defaultMin.add(Duration(days: values.end.ceil()))),
    );
    final division = max;

    logger.i('values: $values, labels: $rangeLabels');
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
                widget.l10n.date,
                style: widget.theme.textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Builder(
                builder: (ctx) {
                  final searchBloc = ctx.watch<SearchBloc>();
                  return Column(
                    spacing: 8,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              defaultMin.toString().split(' ').first,

                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                            Text(
                              defaultMax.toString().split(' ').first,

                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                      RangeSlider(
                        max: defaultMax
                            .difference(defaultMin)
                            .inDays
                            .toDouble(),
                        values: values,
                        divisions: division,
                        labels: rangeLabels,
                        onChanged: (RangeValues value) {
                          searchBloc
                            ..add(
                              UpdateMinDate(
                                defaultMin.add(
                                  Duration(days: value.start.floor()),
                                ),
                              ),
                            )
                            ..add(
                              UpdateMaxDate(
                                defaultMin.add(
                                  Duration(days: value.end.ceil()),
                                ),
                              ),
                            );
                          setState(() {
                            values = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              searchBloc.state.filters.dateRange.min
                                  .toString()
                                  .split(' ')
                                  .first,

                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                            Text(
                              searchBloc.state.filters.dateRange.max
                                  .toString()
                                  .split(' ')
                                  .first,

                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   spacing: 16,
                      //   children: [
                      //     Expanded(
                      //       child: TextField(
                      //         controller: minController,
                      //         decoration: const InputDecoration(
                      //           labelText: 'الادنى',
                      //           border: OutlineInputBorder(),
                      //         ),
                      //         keyboardType: TextInputType.number,
                      //         onChanged: (value) {
                      //           if (value.isEmpty) return;
                      //           if (double.parse(value) > values.end) return;
                      //           setState(() {
                      //             searchBloc.add(
                      //               UpdateMinAmount(int.parse(value)),
                      //             );
                      //             values = RangeValues(
                      //               double.parse(value),
                      //               values.end,
                      //             );
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //     const Text('-'),
                      //     Expanded(
                      //       child: TextField(
                      //         controller: maxController,
                      //         decoration: const InputDecoration(
                      //           labelText: 'الاعلى',
                      //           border: OutlineInputBorder(),
                      //         ),
                      //         keyboardType: TextInputType.number,
                      //         onChanged: (value) {
                      //           if (value.isEmpty) return;
                      //           if (double.parse(value) < values.start) return;
                      //           setState(() {
                      //             searchBloc.add(
                      //               UpdateMaxAmount(int.parse(value)),
                      //             );
                      //             values = RangeValues(
                      //               values.start,
                      //               double.parse(value),
                      //             );
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
