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
      limit: 8,
      offset: offset,
      orderBy: '"date" DESC',
    );
    return res;
  }
}
