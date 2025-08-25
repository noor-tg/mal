import 'package:mal/shared/db.dart';

class SqlProvider {
  final table = 'categories';

  Future<List<Map<String, Object?>>> queryList({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await Db.use();
    final res = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: '"title" ASC',
    );
    return res;
  }

  Future<int> queryCount({String? where, List<dynamic>? whereArgs}) async {
    final db = await Db.use();

    final res = await db.query(
      table,
      columns: ['count(uid) as total'],
      where: where,
      whereArgs: whereArgs,
    );

    return res.isNotEmpty ? res.first['total'] as int : 0;
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
