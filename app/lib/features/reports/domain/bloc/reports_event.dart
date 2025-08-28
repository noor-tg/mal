part of 'reports_bloc.dart';

sealed class ReportsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTotals extends ReportsEvent {}
