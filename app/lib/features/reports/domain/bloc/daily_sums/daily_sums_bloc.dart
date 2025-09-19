import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/reports/domain/entities/sums.dart';
import 'package:mal/features/reports/domain/repositories/reports_repository.dart';
import 'package:mal/utils/logger.dart';

part 'daily_sums_event.dart';
part 'daily_sums_state.dart';

class DailySumsBloc extends Bloc<DailySumsEvent, DailySumsState> {
  DailySumsBloc({required this.repo}) : super(const DailySumsState()) {
    on<RequestDailySumsData>(_onRequestDailySumsData);
  }

  final ReportsRepository repo;

  FutureOr<void> _onRequestDailySumsData(
    RequestDailySumsData event,
    Emitter<DailySumsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        list: const Sums(incomes: [], expenses: []),
      ),
    );
    try {
      final dailySums = await repo.dailySums(event.userUid);

      emit(state.copyWith(status: BlocStatus.success, list: dailySums));
    } catch (err, trace) {
      logger
        ..e(err)
        ..t(trace);
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          errorMessage: err.toString(),
        ),
      );
    }
  }
}
