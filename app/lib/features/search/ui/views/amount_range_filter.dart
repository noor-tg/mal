import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmountRangeFilter extends StatefulWidget {
  const AmountRangeFilter({super.key});

  @override
  State<AmountRangeFilter> createState() => _AmountRangeFilterState();
}

class _AmountRangeFilterState extends State<AmountRangeFilter> {
  int max = 1000;
  late RangeValues values;

  final minController = TextEditingController();

  final maxController = TextEditingController();

  @override
  void initState() {
    final searchBloc = context.read<SearchBloc>();
    max = searchBloc.state.maxAmount;
    final amountRange = searchBloc.state.filters.amountRange;
    values = RangeValues(
      amountRange.min.toDouble(),
      amountRange.max.toDouble() > 0
          ? amountRange.max.toDouble()
          : max.toDouble(),
    );
    minController.text = values.start.toInt().toString();
    maxController.text = values.end.toInt().toString();
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
      child: Card(
        color: context.colors.surfaceBright,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                l10n.amount,
                style: texts.titleLarge?.copyWith(
                  color: context.colors.onSurface,
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
                              style: context.texts.titleMedium?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              moneyFormat(max),
                              style: context.texts.titleMedium?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value.isEmpty) return;
                                final parsed = double.parse(value);
                                if (parsed > values.end) return;
                                if (parsed > max) {
                                  value = max.toString();
                                  minController.text = value;
                                }
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value.isEmpty) return;
                                final parsed = double.parse(value);
                                if (parsed < values.start) return;
                                if (parsed > max) {
                                  value = max.toString();
                                  maxController.text = value;
                                }
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
