part of 'daily_sums_bloc.dart';

sealed class DailySumsEvent extends Equatable {
  const DailySumsEvent();

  @override
  List<Object> get props => [];
}

class RequestDailySumsData extends DailySumsEvent {}
