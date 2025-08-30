import 'package:equatable/equatable.dart';

class DaySums extends Equatable {
  final String day;
  final int incomes;
  final int expenses;

  const DaySums({
    required this.day,
    required this.incomes,
    required this.expenses,
  });

  @override
  List<Object?> get props => [day, incomes, expenses];
}
