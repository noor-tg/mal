part of 'calendar_bloc.dart';

class CalendarState extends Equatable {
  const CalendarState({
    this.selectedMonthData = const [],
    this.status = BlocStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, errorMessage, selectedMonthData];

  final BlocStatus status;
  final String? errorMessage;
  final List<DaySums> selectedMonthData;

  CalendarState copyWith({
    BlocStatus? status,
    String? errorMessage,
    List<DaySums>? selectedMonthData,
  }) {
    return CalendarState(
      selectedMonthData: selectedMonthData ?? this.selectedMonthData,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
