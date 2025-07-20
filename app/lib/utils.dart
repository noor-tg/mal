import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
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
  final Widget widget;
  final Icon icon;
  final List<Widget> actions;
}

Future<sql.Database> createOrOpenDB() async {
  final dbPath = await sql.getDatabasesPath();
  return sql.openDatabase(
    path.join(dbPath, 'mal.db'),
    onCreate: (db, version) async {
      final batch = db.batch();

      categoriesMigrateUp(batch);
      entriesMigrateUp(batch);

      await batch.commit();
      print('database updated');
    },
    version: 1,
  );
}

void entriesMigrateUp(sql.Batch batch) {
  batch.execute('''CREATE TABLE entries(
      uid text primary key,
      description text,
      type text,
      category text,
      date TEXT DEFAULT (datetime('now')),
      amount int
  );
  ''');
}

void categoriesMigrateUp(sql.Batch batch) {
  batch.execute('''
    CREATE TABLE categories(
       uid text primary key,
       title text,
       type text
    );
  ''');
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
  print('days');
  print(days);
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

  print(data);

  return data;
}

class Totals {
  final int balance;
  final int incomes;
  final int expenses;

  Totals({
    required this.balance,
    required this.incomes,
    required this.expenses,
  });
}
