import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/constants.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/reports/domain/entities/category_report.dart';
import 'package:mal/features/reports/domain/repositories/reports_repository.dart';
import 'package:mal/utils.dart';

part 'categories_report_event.dart';
part 'categories_report_state.dart';

class CategoriesReportBloc
    extends Bloc<CategoriesReportEvent, CategoriesReportState> {
  final ReportsRepository repo;

  CategoriesReportBloc({required this.repo})
    : super(const CategoriesReportState()) {
    on<RequestIncomesPieReportData>(_onRequestIncomesCategoresReportData);
    on<RequestExpensesPieReportData>(_onRequestExpensesCategoresReportData);
  }

  FutureOr<void> _onRequestIncomesCategoresReportData(
    RequestIncomesPieReportData event,
    Emitter<CategoriesReportState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final data = await repo.getCategoriesPrecents(incomeType, event.userUid);

      emit(state.copyWith(status: BlocStatus.success, incomesData: data));
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

  FutureOr<void> _onRequestExpensesCategoresReportData(
    RequestExpensesPieReportData event,
    Emitter<CategoriesReportState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final data = await repo.getCategoriesPrecents(expenseType, event.userUid);

      emit(state.copyWith(status: BlocStatus.success, expensesData: data));
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
