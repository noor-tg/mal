part of 'calendar_bloc.dart';

sealed class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class FetchSelectedMonthData extends CalendarEvent {
  final int year;
  final int month;

  const FetchSelectedMonthData(this.year, this.month);

  @override
  List<Object> get props => [year, month];
}
