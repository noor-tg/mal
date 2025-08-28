import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/reports/domain/repositories/reports_repository.dart';
import 'package:mal/utils.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc(this.repo) : super(const ReportsState()) {
    on<LoadTotals>(_onLoadTotals);
  }

  final ReportsRepository repo;

  FutureOr<void> _onLoadTotals(
    LoadTotals event,
    Emitter<ReportsState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final totals = await repo.totals();

      emit(state.copyWith(status: BlocStatus.success, totals: totals));
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
