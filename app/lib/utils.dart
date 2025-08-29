import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:mal/shared/db.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart' as sql;

const uuid = Uuid();
final formatter = DateFormat.yMd();

String moneyFormat(BuildContext context, int value) {
  return NumberFormat.decimalPattern('ar_SA').format(value);
}

class MalPage {
  MalPage({
    required this.widget,
    required this.title,
    required this.icon,
    required this.actions,
  });

  final String title;
  final Widget Function(Key? key) widget;
  final Icon icon;
  final List<Widget> actions;
}

Future<sql.Database> createOrOpenDB() async {
  return Db.use();
}

class DaySums {
  final String day;
  final int income;
  final int expenses;

  DaySums({required this.day, required this.income, required this.expenses});
}

List<String> getCurrentMonthDays() {
  final now = DateTime.now();
  // Generate list of date strings
  final List<String> days = [];
  for (int day = 1; day <= now.day; day++) {
    // Format day with zero padding and create date string
    final dayStr = day.toString().padLeft(2, '0');
    days.add(dayStr);
  }

  return days;
}

class Sums {
  final List<int> incomes;
  final List<int> expenses;

  Sums({required this.incomes, required this.expenses});
}

Future<Sums> loadDailySums() async {
  final db = await createOrOpenDB();

  final incomeSums = await db.query(
    'entries',
    columns: ['sum(amount) as sum', 'date("date") as by_date'],
    where: 'type = ?',
    whereArgs: ['دخل'],
    groupBy: '"by_date"',
  );
  final expensesSums = await db.query(
    'entries',
    columns: ['sum(amount) as sum', 'date("date") as by_date'],
    where: 'type = ?',
    whereArgs: ['منصرف'],
    groupBy: '"by_date"',
  );

  final Sums data = Sums(expenses: [], incomes: []);

  final days = getCurrentMonthDays();
  for (final day in days) {
    final dayIncome = incomeSums
        .where((row) => (row['by_date'] as String).substring(8) == day)
        .toList();

    final dayExpenses = expensesSums
        .where((row) => (row['by_date'] as String).substring(8) == day)
        .toList();

    data.incomes.add(dayIncome.isNotEmpty ? dayIncome.first['sum'] as int : 0);
    data.expenses.add(
      dayExpenses.isNotEmpty ? dayExpenses.first['sum'] as int : 0,
    );
  }

  return data;
}

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

const box8 = SizedBox(height: 8, width: 8);
const box16 = SizedBox(height: 16, width: 16);
const box24 = SizedBox(height: 24, width: 24);

final logger = Logger();

DateTime now() {
  return DateTime.now();
}
