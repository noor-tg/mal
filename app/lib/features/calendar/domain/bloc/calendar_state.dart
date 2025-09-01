part of 'calendar_bloc.dart';

class CalendarState extends Equatable {
  const CalendarState({
    this.selectedMonthData = const [],
    this.selectedDayData = const [],
    this.status = BlocStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    selectedMonthData,
    selectedDayData,
  ];

  final BlocStatus status;
  final String? errorMessage;
  final List<DaySums> selectedMonthData;
  final List<Entry> selectedDayData;

  CalendarState copyWith({
    BlocStatus? status,
    String? errorMessage,
    List<DaySums>? selectedMonthData,
    List<Entry>? selectedDayData,
  }) {
    return CalendarState(
      selectedMonthData: selectedMonthData ?? this.selectedMonthData,
      selectedDayData: selectedDayData ?? this.selectedDayData,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
