import 'package:flutter/material.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Add this import for context.watch()

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

  final minController = TextEditingController();

  final maxController = TextEditingController();
  late DateTime startOfYear;
  late DateTime now;

  @override
  void initState() {
    now = DateTime.now();
    startOfYear = DateTime(now.year);
    final today = now;

    // Convert dates to days since startOfYear
    const minValue = 0;
    final maxValue = today.difference(startOfYear).inDays.toDouble();

    values = RangeValues(minValue.toDouble(), maxValue);
    max = maxValue.toInt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rangeLabels = RangeLabels(
      startOfYear
          .add(Duration(days: values.start.ceil()))
          .toString()
          .split(' ')
          .first,
      startOfYear
          .add(Duration(days: values.end.ceil()))
          .toString()
          .split(' ')
          .first,
    );
    final division = max;

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
                              startOfYear.toString().split(' ').first,

                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                            Text(
                              now.toString().split(' ').first,

                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                      RangeSlider(
                        max: max.toDouble(),
                        values: values,
                        divisions: division,
                        labels: rangeLabels,
                        onChanged: (RangeValues value) {
                          searchBloc
                            ..add(
                              UpdateMinDate(
                                startOfYear.add(
                                  Duration(days: value.start.ceil()),
                                ),
                              ),
                            )
                            ..add(
                              UpdateMaxDate(
                                startOfYear.add(
                                  Duration(days: value.end.ceil()),
                                ),
                              ),
                            );
                          setState(() {
                            values = value;
                            minController.text = value.start.ceil().toString();
                            maxController.text = value.end.ceil().toString();
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
