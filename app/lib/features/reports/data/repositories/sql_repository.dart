import 'package:mal/constants.dart';
import 'package:mal/features/reports/data/sources/sql_provider.dart';
import 'package:mal/features/reports/domain/entities/sums.dart';
import 'package:mal/features/reports/domain/entities/totals.dart';
import 'package:mal/features/reports/domain/repositories/reports_repository.dart';
import 'package:mal/utils.dart';

class SqlRepository extends ReportsRepository {
  final sqlProvider = SqlProvider();

  @override
  Future<Totals> totals() async {
    try {
      final incomeSum = await sqlProvider.incomesTotal();
      final expensesSum = await sqlProvider.expensesTotal();
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
  Future<Sums> dailySums() async {
    final incomeSums = await sqlProvider.daySums(incomeType);
    final expensesSums = await sqlProvider.daySums(expenseType);

    // ignore: prefer_const_constructors
    final data = Sums(expenses: [], incomes: []);

    final days = getCurrentMonthDays();

    for (final day in days) {
      data.incomes.add(getDaySum(incomeSums, day));
      data.expenses.add(getDaySum(expensesSums, day));
    }

    return data;
  }

  int getDaySum(List<Map<String, Object?>> list, String day) {
    final dayIncome = list
        .where((row) => (row['by_date'] as String).substring(8) == day)
        .toList();
    return dayIncome.isNotEmpty ? dayIncome.first['sum'] as int : 0;
  }
}
