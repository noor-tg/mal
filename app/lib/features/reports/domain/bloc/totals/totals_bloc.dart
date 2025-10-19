import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/reports/domain/entities/totals.dart';
import 'package:mal/features/reports/domain/repositories/reports_repository.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/logger.dart';

part 'totals_event.dart';
part 'totals_state.dart';

class TotalsBloc extends Bloc<TotalsEvent, TotalsState> {
  TotalsBloc({required this.repo}) : super(const TotalsState()) {
    on<RequestTotalsData>(_onLoadTotals);
  }

  final ReportsRepository repo;

  FutureOr<void> _onLoadTotals(
    RequestTotalsData event,
    Emitter<TotalsState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    await sleep(2);
    try {
      final totals = await repo.totals(event.userUid);

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
