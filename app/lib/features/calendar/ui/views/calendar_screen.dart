import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mal/features/calendar/domain/bloc/calendar_bloc.dart';
import 'package:mal/features/calendar/domain/repositories/day_sums.dart';
import 'package:mal/features/calendar/ui/widgets/calendar_cell.dart';
import 'package:mal/features/calendar/ui/widgets/calendar_container.dart';
import 'package:mal/features/calendar/ui/widgets/calendar_day_bar.dart';
import 'package:mal/features/calendar/ui/widgets/calendar_day_section.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/tour/domain/showcase_cubit.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:table_calendar/table_calendar.dart' as calendar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/utils.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  calendar.CalendarFormat _calendarFormat = calendar.CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late StreamSubscription<EntriesState> stream;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    fetchData();
    stream = context.read<EntriesBloc>().stream.listen((state) {
      if (OperationType.values.contains(state.operationType)) {
        if (!mounted) return;
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  void fetchData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;
    context.read<CalendarBloc>().add(
      FetchSelectedMonthData(
        _focusedDay.year,
        _focusedDay.month,
        authState.user.uid,
      ),
    );
    context.read<CalendarBloc>().add(
      FetchSelectedDayData(_selectedDay!, authState.user.uid),
    );
  }

  List<DaySums> _getTransactionsForDay(DateTime day, CalendarState state) {
    return state.selectedMonthData
        .where((row) => row.date.difference(day).inDays == 0)
        .toList();
  }

  // Calculate daily totals for display
  DaySums _getDailyTotals(DateTime day, CalendarState state) {
    final list = state.selectedMonthData
        .where((row) => row.date.difference(day).inDays == 0)
        .toList();
    return list.isNotEmpty
        ? list.first
        : DaySums(incomes: 0, expenses: 0, date: day);
  }

  int net(CalendarState state) {
    final totals = _getDailyTotals(_selectedDay!, state);
    return totals.incomes - totals.expenses;
  }

  @override
  Widget build(BuildContext context) {
    final showcaseState = context.watch<ShowcaseCubit>().state;

    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (BuildContext ctx, CalendarState state) => Container(
        decoration: BoxDecoration(color: context.colors.surfaceContainer),
        child: Column(
          children: [
            Showcase(
              key: showcaseState.keys.calendarInfo,
              description: l10n.showCaseDescriptionCalendarInfo,
              child: CalendarContainer(
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                eventLoader: (day) => _getTransactionsForDay(day, state),
                selectedDay: _selectedDay,
                onDaySelected: onDaySelected,
                onFormatChanged: onFormatChanged,
                onPageChanged: onPageChanged,
                state: state,
                calendarCellBuilder: calendarCellBuilder,
              ),
            ),
            Showcase(
              key: showcaseState.keys.dayHeader,
              description: l10n.showCaseDescriptionDayHeader,
              child: CalendarDayBar(
                state: state,
                net: net,
                selectedDay: _selectedDay,
              ),
            ),
            if (state.selectedDayData.isNotEmpty)
              Showcase(
                key: showcaseState.keys.dayList,
                description: l10n.showCaseDescriptionDayList,
                child: CalendarDaySection(state: state),
              ),
          ],
        ),
      ),
    );
  }

  Widget calendarCellBuilder(
    DateTime date,
    CalendarState state,
    Color borderColor,
  ) {
    final totals = _getDailyTotals(date, state);
    final hasTransactions = totals.incomes > 0 || totals.expenses > 0;

    return CalendarCell(
      hasTransactions: hasTransactions,
      totals: totals,
      date: date,
      borderColor: borderColor,
    );
  }

  void onFormatChanged(dynamic format) {
    if (_calendarFormat == format) return;
    setState(() {
      _calendarFormat = format;
    });
  }

  void onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthAuthenticated) return;

    context.read<CalendarBloc>().add(
      FetchSelectedMonthData(
        _focusedDay.year,
        _focusedDay.month,
        authState.user.uid,
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (calendar.isSameDay(_selectedDay, selectedDay)) return;

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthAuthenticated) return;

    context.read<CalendarBloc>().add(
      FetchSelectedDayData(_selectedDay!, authState.user.uid),
    );
  }
}
