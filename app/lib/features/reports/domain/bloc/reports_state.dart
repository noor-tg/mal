part of 'reports_bloc.dart';

class ReportsState extends Equatable {
  const ReportsState({
    Totals? totals,
    this.status = BlocStatus.initial,
    this.errorMessage,
  }) : totals = totals ?? const Totals(balance: 0, incomes: 0, expenses: 0);

  final Totals totals;
  final BlocStatus status;

  @override
  List<Object> get props => [totals, status];

  final String? errorMessage;

  ReportsState copyWith({
    BlocStatus? status,
    Totals? totals,
    String? errorMessage,
  }) {
    return ReportsState(
      totals: totals ?? this.totals,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
