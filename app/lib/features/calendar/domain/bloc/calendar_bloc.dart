import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:mal/features/calendar/domain/repositories/day_sums.dart';
import 'package:mal/utils.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarRepository repo;
  CalendarBloc({required this.repo}) : super(const CalendarState()) {
    on<FetchSelectedMonthData>(_onFetchSelectedMonthData);
  }

  FutureOr<void> _onFetchSelectedMonthData(
    event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading, selectedMonthData: []));
    try {
      final data = await repo.getSelectedMonthSums(event.year, event.month);

      emit(state.copyWith(status: BlocStatus.success, selectedMonthData: data));
    } catch (err, trace) {
      logger
        ..e(err)
        ..t(trace);
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          selectedMonthData: [],
          errorMessage: err.toString(),
        ),
      );
    }
  }
}
