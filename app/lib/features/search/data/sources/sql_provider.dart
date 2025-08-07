import 'package:mal/constants.dart';
import 'package:mal/shared/db.dart';

class SqlProvider {
  final table = 'entries';
  final String searchWhere =
      '"type" = ? or "category" like ? or "description" like ?';

  Future<List<Map<String, dynamic>>> searchEntries({
    String term = '',
    int offset = 0,
  }) async {
    final db = await Db.use();
    final search = '%$term%';
    final res = await db.query(
      table,
      where: searchWhere,
      whereArgs: [term, search, search],
      limit: kSearchLimit,
      offset: offset,
      orderBy: '"date" DESC',
    );
    return res;
  }

  Future<int> searchEntriesCount({String term = ''}) async {
    final db = await Db.use();
    final search = '%$term%';
    final res = await db.query(
      table,
      columns: ['count(uid) as total'],
      where: searchWhere,
      whereArgs: [term, search, search],
    );
    return res.isEmpty ? 0 : res.first['total'] as int;
  }
}
