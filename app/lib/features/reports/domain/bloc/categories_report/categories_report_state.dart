part of 'categories_report_bloc.dart';

class CategoriesReportState extends Equatable {
  const CategoriesReportState({
    List<CategoryReport>? incomesData,
    List<CategoryReport>? expensesData,
    this.status = BlocStatus.initial,
    this.errorMessage,
  }) : incomesData = incomesData ?? const [],
       expensesData = expensesData ?? const [];

  final List<CategoryReport> incomesData;
  final List<CategoryReport> expensesData;
  final BlocStatus status;

  @override
  List<Object?> get props => [incomesData, expensesData, status, errorMessage];

  final String? errorMessage;

  CategoriesReportState copyWith({
    BlocStatus? status,
    List<CategoryReport>? incomesData,
    List<CategoryReport>? expensesData,
    String? errorMessage,
  }) {
    return CategoriesReportState(
      incomesData: incomesData ?? this.incomesData,
      expensesData: expensesData ?? this.expensesData,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
