import 'package:mal/constants.dart';
import 'package:mal/features/search/domain/bloc/sorting.dart';
import 'package:mal/shared/query_builder.dart';

class SqlProvider {
  Future<int> incomesTotal(String userUid) async {
    final incomes = await QueryBuilder('entries')
        .where('type', '=', incomeType)
        .where('user_uid', '=', userUid)
        .sumBy('amount', 'type');

    return incomes.isNotEmpty ? incomes.first['sum'] as int : 0;
  }

  Future<int> expensesTotal(String userUid) async {
    final expenses = await QueryBuilder('entries')
        .where('type', '=', expenseType)
        .where('user_uid', '=', userUid)
        .sumBy('amount', 'type');

    return expenses.isNotEmpty ? expenses.first['sum'] as int : 0;
  }

  Future<dynamic> daySums(String type, String userUid) async {
    return QueryBuilder('entries')
        .where('type', '=', type)
        .where('user_uid', '=', userUid)
        .sumBy('amount', 'date("date") as by_date');
  }

  Future<List<Map<String, Object?>>> sumByCategoryAndType(
    String type,
    String userUid,
  ) async {
    return QueryBuilder('entries')
        .where('type', '=', type)
        .where('user_uid', '=', userUid)
        .sortBy('sum', SortingDirection.desc)
        .sumBy('amount', 'category');
  }

  Future<List<Map<String, Object?>>> sumEntriesByType(
    String type,
    String userUid,
  ) async {
    return QueryBuilder('entries')
        .where('type', '=', type)
        .where('user_uid', '=', userUid)
        .sumBy('amount', 'type');
  }
}
