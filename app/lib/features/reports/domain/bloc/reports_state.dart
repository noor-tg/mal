part of 'reports_bloc.dart';

class ReportsState extends Equatable {
  const ReportsState({
    Totals? totals,
    this.totalsStatus = BlocStatus.initial,
    this.errorMessage,
  }) : totals = totals ?? const Totals(balance: 0, incomes: 0, expenses: 0);

  final Totals totals;
  final BlocStatus totalsStatus;

  @override
  List<Object> get props => [totals, totalsStatus];

  final String? errorMessage;

  ReportsState copyWith({
    BlocStatus? totalsStatus,
    Totals? totals,
    String? errorMessage,
  }) {
    return ReportsState(
      totals: totals ?? this.totals,
      totalsStatus: totalsStatus ?? this.totalsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
