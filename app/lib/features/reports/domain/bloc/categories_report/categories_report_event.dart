part of 'categories_report_bloc.dart';

sealed class CategoriesReportEvent extends Equatable {
  const CategoriesReportEvent();

  @override
  List<Object> get props => [];
}

class RequestIncomesPieReportData extends CategoriesReportEvent {}

class RequestExpensesPieReportData extends CategoriesReportEvent {}
