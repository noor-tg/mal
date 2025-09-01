import 'package:mal/constants.dart';
import 'package:mal/shared/query_builder.dart';
import 'package:mal/shared/where.dart';

class SqlProvider {
  Future<List<Map<String, Object?>>> getIncomesSumsByDate({
    required Where where,
  }) {
    return QueryBuilder('entries')
        .whereLike(where.field, where.value! as String)
        .where('type', '=', incomeType)
        .sumBy('amount', 'DATE(date) as "date"');
  }

  Future<List<Map<String, Object?>>> getExpensesSumsByDate({
    required Where where,
  }) {
    return QueryBuilder('entries')
        .whereLike(where.field, where.value! as String)
        .where('type', '=', expenseType)
        .sumBy('amount', 'DATE(date) as date');
  }
}
