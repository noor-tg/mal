import 'package:mal/features/reports/data/sources/sql_provider.dart';
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
}
