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
  late int division;
  late RangeLabels rangeLabels;

  @override
  void initState() {
    super.initState();
    defaultMin = DateTime.now();
    defaultMax = DateTime.now();
    max = 0;
    division = 0;
    values = const RangeValues(0, 0);
    rangeLabels = const RangeLabels('', '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Prepare data after widget is fully built and has access to context
    _prepareSliderData();
  }

  void _prepareSliderData() {
    // entries date range
    final searchState = context.read<SearchBloc>().state;

    // get entries range from db
    final entriesDateRange = searchState.dateRange;

    // get default filters range
    final filtersDateRange = searchState.filters.dateRange;

    // set min default to entries min
    defaultMin = entriesDateRange.min;
    // set max default to entries max
    defaultMax = entriesDateRange.max;

    // calc filters min diff from entries min in days
    double minValue = filtersDateRange.min
        .difference(defaultMin)
        .inDays
        .toDouble();
    // calc filters max diff from entries min in days
    double maxValue = filtersDateRange.max
        .difference(defaultMin)
        .inDays
        .toDouble();

    // Calculate total range in days
    final totalDays = defaultMax.difference(defaultMin).inDays;

    // If there's no date range (e.g., no entries in DB), return early
    if (totalDays <= 0) {
      max = 0;
      division = 0;
      values = const RangeValues(0, 0);
      rangeLabels = const RangeLabels('', '');
      logger.w('No valid date range available');
      return;
    }

    minValue = minValue.clamp(0.0, totalDays.toDouble());
    maxValue = maxValue.clamp(0.0, totalDays.toDouble());

    // Ensure min is not greater than max
    if (minValue > maxValue) {
      maxValue = minValue;
    }

    // store range values data
    // to use in slider :: which show error when user reset search form (in simple or advance). why !!!!!
    values = RangeValues(minValue, maxValue);
    // set max (which is used in slider and for divisions counts)

    max = totalDays;
    division = totalDays;

    // set labels info based on default min diff in days
    rangeLabels = RangeLabels(
      toDate(defaultMin.add(Duration(days: values.start.floor()))),
      toDate(defaultMin.add(Duration(days: values.end.ceil()))),
    );

    logger.i('values: $values, labels: $rangeLabels, division: $division');
  }

  @override
  Widget build(BuildContext context) {
    if (division == 0) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.all(8.0), child: _buildCard());
  }

  Card _buildCard() {
    return Card(
      color: colors.surfaceBright,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              l10n.date,
              style: texts.titleLarge?.copyWith(color: colors.onSurface),
            ),
            BlocListener<SearchBloc, SearchState>(
              listener: (BuildContext context, state) {
                setState(_prepareSliderData);
              },
              child: Builder(
                builder: (ctx) {
                  final searchBloc = ctx.watch<SearchBloc>();
                  return Column(
                    spacing: 8,
                    children: [
                      _buildMinMax(),
                      _buildRangeSlider(searchBloc),
                      _buildFilterValues(searchBloc),
                    ],
                  );
                },
              ),
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

  RangeSlider _buildRangeSlider(SearchBloc searchBloc) {
    final maxSliderValue = defaultMax.difference(defaultMin).inDays.toDouble();

    return RangeSlider(
      max: maxSliderValue,
      values: values,
      divisions: division,
      labels: rangeLabels,
      onChanged: (RangeValues value) => updateRange(searchBloc, value),
    );
  }

  void updateRange(SearchBloc searchBloc, RangeValues value) {
    final calcMin = defaultMin.add(Duration(days: value.start.floor()));
    final calcMax = defaultMin.add(Duration(days: value.end.ceil()));

    searchBloc
      ..add(UpdateMinDate(calcMin))
      ..add(UpdateMaxDate(calcMax));

    setState(() {
      values = value;
    });
  }
}
