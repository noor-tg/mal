import 'package:flutter/material.dart';
import 'package:mal/features/calendar/domain/bloc/calendar_bloc.dart';
import 'package:mal/features/calendar/domain/repositories/day_sums.dart';
import 'package:mal/features/calendar/ui/views/calendar_cell.dart';
import 'package:mal/features/calendar/ui/views/calendar_container.dart';
import 'package:mal/features/calendar/ui/views/calendar_day_bar.dart';
import 'package:mal/features/calendar/ui/views/calendar_day_section.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:table_calendar/table_calendar.dart' as calendar;
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  calendar.CalendarFormat _calendarFormat = calendar.CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
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
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (BuildContext ctx, CalendarState state) => Container(
        decoration: BoxDecoration(color: Colors.grey.withAlpha(50)),
        child: Column(
          children: [
            CalendarContainer(
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
            CalendarDayBar(state: state, net: net, selectedDay: _selectedDay),
            if (state.selectedDayData.isNotEmpty)
              CalendarDaySection(state: state),
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

  void onFormatChanged(format) {
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
