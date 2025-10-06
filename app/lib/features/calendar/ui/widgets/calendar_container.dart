import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mal/features/calendar/domain/bloc/calendar_bloc.dart';
import 'package:mal/features/calendar/domain/repositories/day_sums.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/dates.dart';
import 'package:table_calendar/table_calendar.dart' as calendar;

class CalendarContainer extends StatelessWidget {
  CalendarContainer({
    super.key,
    required this.focusedDay,
    required this.calendarFormat,
    required this.eventLoader,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.calendarCellBuilder,
    required this.state,
    this.selectedDay,
  });

  final CalendarState state;
  final Widget? Function(DateTime day, CalendarState state, Color borderColor)
  calendarCellBuilder;

  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final void Function(dynamic format) onFormatChanged;
  final void Function(DateTime focusedDay) onPageChanged;

  final DateTime? selectedDay;
  final List<DaySums> Function(dynamic day) eventLoader;
  final DateTime focusedDay;
  final calendar.CalendarFormat calendarFormat;

  final availableCalendarFormats = const {
    calendar.CalendarFormat.month: 'شهر',
    calendar.CalendarFormat.twoWeeks: 'أسبوعين',
    calendar.CalendarFormat.week: 'أسبوع',
  };

  final calendarStyle = calendar.CalendarStyle(
    outsideDaysVisible: false,
    weekendTextStyle: TextStyle(color: Colors.red[600]),
    holidayTextStyle: TextStyle(color: Colors.red[600]),
    selectedDecoration: BoxDecoration(
      // color: Colors.blue[600],
      border: BoxBorder.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(8),
    ),
    todayDecoration: BoxDecoration(
      border: BoxBorder.all(color: Colors.orange),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.colors.surfaceBright),
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
        focusedDay: focusedDay,
        calendarFormat: calendarFormat,
        eventLoader: eventLoader,
        startingDayOfWeek: calendar.StartingDayOfWeek.monday,
        calendarStyle: calendarStyle,
        selectedDayPredicate: (day) {
          return calendar.isSameDay(selectedDay, day);
        },
        onDaySelected: onDaySelected,
        onFormatChanged: onFormatChanged,
        onPageChanged: onPageChanged,
        calendarBuilders: calendar.CalendarBuilders(
          // Custom builder to show income/expense amounts
          defaultBuilder: (context, day, focusedDay) {
            return calendarCellBuilder(
              day,
              state,
              context.colors.surfaceContainerHigh,
            );
          },
          selectedBuilder: (context, day, focusedDay) {
            return calendarCellBuilder(day, state, context.colors.primary);
          },
          todayBuilder: (context, day, focusedDay) {
            return calendarCellBuilder(day, state, Colors.orange);
          },
        ),
      ),
    );
  }
}
