import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mal/constants.dart';
import 'package:mal/features/calendar/domain/bloc/calendar_bloc.dart';
import 'package:mal/features/calendar/domain/repositories/day_sums.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/widgets/entries_list.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/dates.dart';
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

  final calendarStyle = calendar.CalendarStyle(
    outsideDaysVisible: false,
    weekendTextStyle: TextStyle(color: Colors.red[600]),
    holidayTextStyle: TextStyle(color: Colors.red[600]),
    selectedDecoration: BoxDecoration(
      color: Colors.blue[600],
      borderRadius: BorderRadius.circular(8),
    ),
    todayDecoration: BoxDecoration(
      color: Colors.orange[400],
      borderRadius: BorderRadius.circular(8),
    ),
    markerDecoration: const BoxDecoration(color: Colors.transparent),
  );

  final daysOfWeekStyle = const calendar.DaysOfWeekStyle(
    weekdayStyle: TextStyle(fontSize: 12), // Adjust font size if needed
    weekendStyle: TextStyle(fontSize: 12),
  );

  final headerStyle = calendar.HeaderStyle(
    titleTextFormatter: (date, locale) {
      // Custom formatter: English year, localized month
      final monthName = DateFormat.MMMM(locale).format(date);
      final year = DateFormat.y('en').format(date); // Force English year
      return '$monthName $year';
    },
  );

  final availableCalendarFormats = const {
    calendar.CalendarFormat.month: 'شهر',
    calendar.CalendarFormat.twoWeeks: 'أسبوعين',
    calendar.CalendarFormat.week: 'أسبوع',
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    context.read<CalendarBloc>().add(
      FetchSelectedMonthData(_focusedDay.year, _focusedDay.month),
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
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (BuildContext ctx, CalendarState state) => Container(
        decoration: BoxDecoration(color: Colors.grey.withAlpha(50)),
        child: Column(
          children: [
            // Calendar Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(100),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: calendar.TableCalendar<DaySums>(
                locale: 'ar',
                availableCalendarFormats: availableCalendarFormats,
                headerStyle: headerStyle,
                daysOfWeekHeight: 40,
                daysOfWeekStyle: daysOfWeekStyle,
                rowHeight: 72, // Default is around 52, increase as needed
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(
                  now().year,
                  now().month,
                  monthLength(now().year, now().month),
                ),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                eventLoader: (day) => _getTransactionsForDay(day, state),
                startingDayOfWeek: calendar.StartingDayOfWeek.monday,
                calendarStyle: calendarStyle,
                selectedDayPredicate: (day) {
                  return calendar.isSameDay(_selectedDay, day);
                },
                onDaySelected: onDaySelected,
                onFormatChanged: onFormatChanged,
                onPageChanged: onPageChanged,
                calendarBuilders: calendar.CalendarBuilders(
                  // Custom builder to show income/expense amounts
                  defaultBuilder: (context, day, focusedDay) {
                    return calendarCellBuilder(day, state);
                  },
                ),
              ),
            ),

            // Divider with selected date info
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${l10n.entries} ${_selectedDay != null ? "${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}" : ""}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    net(state) == 0 ? '' : moneyFormat(net(state).toInt()),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: net(state) > 0
                          ? Colors.green[700]
                          : Colors.red[700],
                    ),
                  ),
                ],
              ),
            ),
            if (state.selectedDayData.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: EntriesList(entries: state.selectedDayData),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Container calendarCellBuilder(DateTime day, CalendarState state) {
    final totals = _getDailyTotals(day, state);
    final hasTransactions = totals.incomes > 0 || totals.expenses > 0;

    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: calendar.isSameDay(_selectedDay, day)
            ? Colors.blue[600]
            : (calendar.isSameDay(DateTime.now(), day)
                  ? Colors.orange[400]
                  : Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              color:
                  calendar.isSameDay(_selectedDay, day) ||
                      calendar.isSameDay(DateTime.now(), day)
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (hasTransactions) ...[
            if (totals.incomes > 0)
              Text(
                '+${approximate(totals.incomes.toInt())}',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color:
                      calendar.isSameDay(_selectedDay, day) ||
                          calendar.isSameDay(DateTime.now(), day)
                      ? Colors.white
                      : Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (totals.expenses > 0)
              Text(
                '-${approximate(totals.expenses.toInt())}',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color:
                      calendar.isSameDay(_selectedDay, day) ||
                          calendar.isSameDay(DateTime.now(), day)
                      ? Colors.white
                      : Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ],
      ),
    );
  }

  void onFormatChanged(format) {
    if (_calendarFormat != format) {
      setState(() {
        _calendarFormat = format;
      });
    }
  }

  void onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
    context.read<CalendarBloc>().add(
      FetchSelectedMonthData(_focusedDay.year, _focusedDay.month),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!calendar.isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
    context.read<CalendarBloc>().add(FetchSelectedDayData(_selectedDay!));
  }
}
