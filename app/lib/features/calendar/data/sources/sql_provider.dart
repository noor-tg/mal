import 'package:mal/constants.dart';
import 'package:mal/shared/query_builder.dart';
import 'package:mal/shared/where.dart';

class SqlProvider {
  Future<List<Map<String, Object?>>> getIncomesSumsByDate({
    required Where where,
    required String userUid,
  }) {
    return QueryBuilder('entries')
        .whereLike(where.field, where.value! as String)
        .where('type', '=', incomeType)
        .where('user_uid', '=', userUid)
        .sumBy('amount', 'DATE(date) as "date"');
  }

  Future<List<Map<String, Object?>>> getExpensesSumsByDate({
    required Where where,
    required String userUid,
  }) {
    return QueryBuilder('entries')
        .whereLike(where.field, where.value! as String)
        .where('type', '=', expenseType)
        .where('user_uid', '=', userUid)
        .sumBy('amount', 'DATE(date) as date');
  }
}
