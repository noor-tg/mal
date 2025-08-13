import 'package:flutter/material.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Add this import for context.watch()

class AmountRangeFilter extends StatefulWidget {
  const AmountRangeFilter({super.key, required this.l10n, required this.theme});

  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  State<AmountRangeFilter> createState() => _AmountRangeFilterState();
}

class _AmountRangeFilterState extends State<AmountRangeFilter> {
  final max = 1000;
  late RangeValues values;

  var minController = TextEditingController();

  var maxController = TextEditingController();

  @override
  void initState() {
    values = RangeValues(0, max.toDouble());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rangeLabels = RangeLabels(
      values.start.toString(),
      values.end.toString(),
    );
    final division = (max / 5).toInt();

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
                widget.l10n.amount,
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
                              '0',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                            Text(
                              max.toString(),
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
                            ..add(UpdateMinAmount(value.start.toInt()))
                            ..add(UpdateMaxAmount(value.end.toInt()));
                          setState(() {
                            values = value;
                            minController.text = value.start.ceil().toString();
                            maxController.text = value.end.ceil().toString();
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 16,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: minController,
                              decoration: const InputDecoration(
                                labelText: 'الادنى',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value.isEmpty) return;
                                if (double.parse(value) > values.end) return;
                                setState(() {
                                  searchBloc.add(
                                    UpdateMinAmount(int.parse(value)),
                                  );
                                  values = RangeValues(
                                    double.parse(value),
                                    values.end,
                                  );
                                });
                              },
                            ),
                          ),
                          const Text('-'),
                          Expanded(
                            child: TextField(
                              controller: maxController,
                              decoration: const InputDecoration(
                                labelText: 'الاعلى',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value.isEmpty) return;
                                if (double.parse(value) < values.start) return;
                                setState(() {
                                  searchBloc.add(
                                    UpdateMaxAmount(int.parse(value)),
                                  );
                                  values = RangeValues(
                                    values.start,
                                    double.parse(value),
                                  );
                                });
                              },
                            ),
                          ),
                        ],
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
