import 'package:equatable/equatable.dart';

class Sums extends Equatable {
  final List<int> incomes;
  final List<int> expenses;

  const Sums({required this.incomes, required this.expenses});

  @override
  List<Object?> get props => [incomes, expenses];
}
