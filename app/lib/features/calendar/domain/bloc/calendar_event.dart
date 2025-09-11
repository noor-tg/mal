part of 'calendar_bloc.dart';

sealed class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class FetchSelectedMonthData extends CalendarEvent {
  final int year;
  final int month;
  final String userUid;

  const FetchSelectedMonthData(this.year, this.month, this.userUid);

  @override
  List<Object> get props => [year, month];
}

class FetchSelectedDayData extends CalendarEvent {
  final DateTime date;

  final String userUid;

  const FetchSelectedDayData(this.date, this.userUid);

  @override
  List<Object> get props => [date];
}
