part of 'daily_sums_bloc.dart';

class DailySumsState extends Equatable {
  const DailySumsState({
    Sums? list,
    this.status = BlocStatus.initial,
    this.errorMessage,
  }) : list = list ?? const Sums(incomes: [], expenses: []);

  final Sums list;
  final BlocStatus status;

  @override
  List<Object?> get props => [list, status, errorMessage];

  final String? errorMessage;

  DailySumsState copyWith({
    BlocStatus? status,
    Sums? list,
    String? errorMessage,
  }) {
    return DailySumsState(
      list: list ?? this.list,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
