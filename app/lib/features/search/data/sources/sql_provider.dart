import 'package:mal/constants.dart';
import 'package:mal/shared/db.dart';

class SqlProvider {
  Future<List<Map<String, dynamic>>> searchEntries({
    String term = '',
    int offset = 0,
  }) async {
    final db = await Db.use();
    final search = '%$term%';
    final res = await db.query(
      'entries',
      where: '"type" = ? or "category" like ? or "description" like ?',
      whereArgs: [term, search, search],
      limit: kSearchLimit,
      offset: offset,
      orderBy: '"date" DESC',
    );
    return res;
  }

  Future<int> searchEntriesCount({String term = '', int offset = 0}) async {
    final db = await Db.use();
    final search = '%$term%';
    final res = await db.query(
      columns: ['count(uid) as total'],
      'entries',
      where: '"type" = ? or "category" like ? or "description" like ?',
      whereArgs: [term, search, search],
      offset: offset,
    );
    return res.isEmpty ? 0 : res.first['total'] as int;
  }
}
