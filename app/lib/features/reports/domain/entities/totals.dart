import 'package:equatable/equatable.dart';

class Totals extends Equatable {
  final int balance;
  final int incomes;
  final int expenses;

  const Totals({
    required this.balance,
    required this.incomes,
    required this.expenses,
  });

  @override
  List<Object?> get props => [balance, incomes, expenses];
}
