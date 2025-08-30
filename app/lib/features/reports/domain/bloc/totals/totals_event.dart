part of 'totals_bloc.dart';

sealed class TotalsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RequestTotalsData extends TotalsEvent {}
