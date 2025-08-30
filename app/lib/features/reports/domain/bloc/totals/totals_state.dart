part of 'totals_bloc.dart';

class TotalsState extends Equatable {
  const TotalsState({
    Totals? totals,
    this.status = BlocStatus.initial,
    this.errorMessage,
  }) : totals = totals ?? const Totals(balance: 0, incomes: 0, expenses: 0);

  final Totals totals;
  final BlocStatus status;

  @override
  List<Object?> get props => [totals, status, errorMessage];

  final String? errorMessage;

  TotalsState copyWith({
    BlocStatus? status,
    Totals? totals,
    String? errorMessage,
  }) {
    return TotalsState(
      totals: totals ?? this.totals,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
