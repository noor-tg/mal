part of 'categories_report_bloc.dart';

sealed class CategoriesReportEvent extends Equatable {
  const CategoriesReportEvent();

  @override
  List<Object> get props => [];
}

class RequestIncomesPieReportData extends CategoriesReportEvent {
  const RequestIncomesPieReportData(this.userUid);

  final String userUid;

  @override
  List<Object> get props => [userUid];
}

class RequestExpensesPieReportData extends CategoriesReportEvent {
  const RequestExpensesPieReportData(this.userUid);

  final String userUid;

  @override
  List<Object> get props => [userUid];
}
