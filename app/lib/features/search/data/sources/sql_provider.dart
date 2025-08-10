import 'package:mal/constants.dart';
import 'package:mal/features/search/domain/bloc/filters.dart';
import 'package:mal/features/search/domain/bloc/sorting.dart';
import 'package:mal/shared/db.dart';
import 'package:mal/utils.dart';

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

  Future<List<Map<String, dynamic>>> getListByFilters({
    required String term,
    required int offset,
    required Filters filters,
    required Sorting sorting,
  }) async {
    final db = await Db.use();
    final search = '%$term%';
    List<String> whereArgs = [];
    String where = '';
    // search by description
    if (term.isNotEmpty) {
      whereArgs.add(search);
      where = '$where description = ?';
    }
    // search by type
    if (filters.type != EntryType.all) {
      switch (filters.type) {
        case EntryType.expense:
          where = '$where ${where.isNotEmpty ? 'AND' : ''} type = ?';
          whereArgs.add('منصرف');
          break;
        case EntryType.income:
          where = '$where ${where.isNotEmpty ? 'AND' : ''} type = ?';
          whereArgs.add('دخل');
          break;
        case EntryType.all:
      }
    }
    // search by categories
    if (filters.categories.isNotEmpty) {
      final categoriesPlaceholder = filters.categories.length > 1
          ? filters.categories.map((_) => '?').join(', ')
          : '?';
      where =
          '$where ${where.isNotEmpty ? 'AND' : ''} category IN ($categoriesPlaceholder)';
      whereArgs = [...whereArgs, ...filters.categories];
    }
    if (filters.amountRange.max > 0) {
      where =
          '$where ${where.isNotEmpty ? 'AND' : ''} amount >= ? AND amount <= ?';
      whereArgs = [
        ...whereArgs,
        filters.amountRange.min.toString(),
        filters.amountRange.max.toString(),
      ];
    }
    // date range is applied by defulat . because there is no clear condition to apply it
    where = '$where ${where.isNotEmpty ? 'AND' : ''} date >= ? AND date <= ?';
    whereArgs = [
      ...whereArgs,
      filters.dateRange.min.toIso8601String(),
      filters.dateRange.max.toIso8601String(),
    ];

    final res = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      limit: kSearchLimit,
      offset: offset,
      orderBy: '"${sorting.field.name}" ${sorting.direction.name}',
    );
    return res;
  }
}
