import 'package:mal/features/calendar/data/sources/sql_provider.dart';
import 'package:mal/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:mal/features/calendar/domain/repositories/day_sums.dart';
import 'package:mal/shared/where.dart';
import 'package:mal/utils.dart';

class SqlRepository extends CalendarRepository {
  final sqlProvider = SqlProvider();

  @override
  Future<List<DaySums>> getSelectedMonthSums(int year, int month) async {
    final formatedMonth = month < 10 ? '0$month' : '$month';

    final incomes = await sqlProvider.getIncomesSumsByDate(
      where: Where(
        field: 'date',
        oprand: 'like',
        value: '$year-$formatedMonth',
      ),
    );

    final expenses = await sqlProvider.getExpensesSumsByDate(
      where: Where(
        field: 'date',
        oprand: 'like',
        value: '$year-$formatedMonth',
      ),
    );

    final List<DaySums> list = [];

    final dates = getCurrentMonthDays();

    for (final day in dates) {
      final income = incomes
          .where((row) => compareDate(row['date'] as String, day))
          .toList();

      final expense = expenses
          .where((row) => compareDate(row['date'] as String, day))
          .toList();

      list.add(
        DaySums(
          date: DateTime(year, month, int.parse(day)),
          incomes: income.isNotEmpty ? income.first['sum'] as int : 0,
          expenses: expense.isNotEmpty ? expense.first['sum'] as int : 0,
        ),
      );
    }

    return list;
  }

  bool compareDate(String isoDate, String dayFormated) {
    return DateTime.parse(isoDate).day == int.parse(dayFormated);
  }
}
