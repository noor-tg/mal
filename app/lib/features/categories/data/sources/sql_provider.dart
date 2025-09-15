import 'package:mal/enums.dart';
import 'package:mal/shared/db.dart';
import 'package:mal/shared/query_builder.dart';
import 'package:mal/shared/where.dart';

class SqlProvider {
  final table = 'categories';

  Future<List<Map<String, Object?>>> queryList({
    List<Where> whereList = const [],
    required String userUid,
  }) async {
    final qb = QueryBuilder('categories').where('user_uid', '=', userUid);

    for (final where in whereList) {
      qb.where(where.field, where.oprand, where.value);
    }

    return qb.sortBy('title', SortingDirection.asc).getAll();
  }

  Future<int> queryCount({
    List<Where> whereList = const [],
    required String userUid,
  }) async {
    final qb = QueryBuilder('categories').where('user_uid', '=', userUid);

    for (final where in whereList) {
      qb.where(where.field, where.oprand, where.value);
    }

    return qb.count();
  }

  Future<void> store(Map<String, Object?> data) async {
    final db = await Db.use();

    await db.insert(table, data);
  }

  Future<void> remove(String uid) async {
    final db = await Db.use();

    await db.delete(table, where: 'uid = ?', whereArgs: [uid]);
  }
}
