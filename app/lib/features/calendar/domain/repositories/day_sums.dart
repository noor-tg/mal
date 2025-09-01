import 'package:equatable/equatable.dart';

class DaySums extends Equatable {
  final int incomes;
  final int expenses;
  final DateTime date;

  const DaySums({
    required this.incomes,
    required this.expenses,
    required this.date,
  });

  @override
  List<Object?> get props => [incomes, expenses, date];

  static DaySums fromMap(Map<String, Object?> map) {
    return DaySums(
      incomes: map['incomes'] as int,
      expenses: map['expenses'] as int,
      date: DateTime.parse(map['date'] as String),
    );
  }
}
