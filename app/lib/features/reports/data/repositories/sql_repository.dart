import 'dart:math';

import 'package:mal/constants.dart';
import 'package:mal/features/reports/constants.dart';
import 'package:mal/features/reports/data/sources/sql_provider.dart';
import 'package:mal/features/reports/domain/entities/category_report.dart';
import 'package:mal/features/reports/domain/entities/sums.dart';
import 'package:mal/features/reports/domain/entities/totals.dart';
import 'package:mal/features/reports/domain/repositories/reports_repository.dart';
import 'package:mal/utils.dart';

class SqlRepository extends ReportsRepository {
  final sqlProvider = SqlProvider();

  @override
  Future<Totals> totals(String userUid) async {
    try {
      final incomeSum = await sqlProvider.incomesTotal(userUid);
      final expensesSum = await sqlProvider.expensesTotal(userUid);
      final balance = incomeSum - expensesSum;

      return Totals(
        balance: balance,
        incomes: incomeSum,
        expenses: expensesSum,
      );
    } catch (err, trace) {
      logger
        ..e(err)
        ..t(trace);
      rethrow;
    }
  }

  @override
  Future<Sums> dailySums(String userUid) async {
    final incomeSums = await sqlProvider.daySums(incomeType, userUid);
    final expensesSums = await sqlProvider.daySums(expenseType, userUid);

    final List<int> incomes = [];
    final List<int> expenses = [];

    final days = getCurrentMonthDays();

    for (final day in days) {
      incomes.add(getDaySum(incomeSums, day));
      expenses.add(getDaySum(expensesSums, day));
    }

    return Sums(incomes: incomes, expenses: expenses);
  }

  int getDaySum(List<Map<String, Object?>> list, String day) {
    final dayIncome = list
        .where((row) => (row['by_date'] as String).substring(8) == day)
        .toList();
    return dayIncome.isNotEmpty ? dayIncome.first['sum'] as int : 0;
  }

  @override
  Future<List<CategoryReport>> getCategoriesPrecents(
    String type,
    String userUid,
  ) async {
    final List<CategoryReport> data = [];

    final categoriesSums = await sqlProvider.sumByCategoryAndType(
      type,
      userUid,
    );

    final total = await sqlProvider.sumEntriesByType(type, userUid);

    final random = Random();

    if (categoriesSums.isNotEmpty) {
      for (final item in categoriesSums) {
        data.add(
          CategoryReport(
            title: item['category'] as String,
            precentage: (item['sum'] as int) / (total[0]['sum'] as int) * 100,
            value: item['sum'] as int,
            color: colors[random.nextInt(colors.length)],
          ),
        );
      }
    }

    return data;
  }
}
