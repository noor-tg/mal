import 'package:flutter/material.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/logger.dart';

class DateRangeFilter extends StatefulWidget {
  const DateRangeFilter({super.key});

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

    final minValue = filtersDateRange.min
        .difference(defaultMin)
        .inDays
        .toDouble();
    final maxValue = filtersDateRange.max
        .difference(defaultMin)
        .inDays
        .toDouble();

    values = RangeValues(minValue, maxValue);
    max = maxValue.toInt();
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
    if (division == 0) return const SizedBox(width: 0);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _buildCard(context, division, rangeLabels),
    );
  }

  Card _buildCard(BuildContext context, int division, RangeLabels rangeLabels) {
    return Card(
      color: context.colors.surfaceBright,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              l10n.date,
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
                    _buildMinMax(),
                    _buildRangeSlider(division, rangeLabels, searchBloc),
                    _buildFilterValues(searchBloc),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildMinMax() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            defaultMin.toString().split(' ').first,

            style: texts.titleMedium?.copyWith(color: colors.onSurface),
          ),
          Text(
            defaultMax.toString().split(' ').first,

            style: texts.titleMedium?.copyWith(color: colors.onSurface),
          ),
        ],
      ),
    );
  }

  Padding _buildFilterValues(SearchBloc searchBloc) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            searchBloc.state.filters.dateRange.min.toString().split(' ').first,

            style: texts.titleLarge?.copyWith(color: colors.onSurface),
          ),
          Text(
            searchBloc.state.filters.dateRange.max.toString().split(' ').first,

            style: texts.titleLarge?.copyWith(color: colors.onSurface),
          ),
        ],
      ),
    );
  }

  RangeSlider _buildRangeSlider(
    int division,
    RangeLabels rangeLabels,
    SearchBloc searchBloc,
  ) {
    return RangeSlider(
      max: defaultMax.difference(defaultMin).inDays.toDouble(),
      values: values,
      divisions: division,
      labels: rangeLabels,
      onChanged: (RangeValues value) {
        searchBloc
          ..add(
            UpdateMinDate(defaultMin.add(Duration(days: value.start.floor()))),
          )
          ..add(
            UpdateMaxDate(defaultMin.add(Duration(days: value.end.ceil()))),
          );
        setState(() {
          values = value;
        });
      },
    );
  }
}
