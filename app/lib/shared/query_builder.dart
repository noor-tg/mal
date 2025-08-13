import 'package:mal/features/search/domain/bloc/sorting.dart';
import 'package:mal/shared/db.dart';

class QueryBuilder {
  final String _table;
  String? _sortBy;

  String? _filterQuery;
  final List<Object?> _whereArgs = [];

  int _limit = 10;
  int _offset = 0;

  // getters
  String get table => _table;
  String? get gsortBy => _sortBy;
  String? get filterQuery => _filterQuery;
  int get goffset => _offset;
  int get glimit => _limit;
  List<Object?> get whereArgs => _whereArgs;

  QueryBuilder(String table) : _table = table;

  QueryBuilder where(String column, String param, String value) {
    _filterQuery ??= '';
    final otherFilterExist = _filterQuery != null && _filterQuery != '';

    if (column.trim().isNotEmpty && param.trim().isNotEmpty) {
      _filterQuery =
          '$_filterQuery ${otherFilterExist ? 'AND' : ''} $column $param ?'
              .trim();
      _whereArgs.add(value);
    }
    return this;
  }

  QueryBuilder whereLike(String column, String value) {
    _filterQuery ??= '';
    final otherFilterExist = _filterQuery != null && _filterQuery != '';

    if (column.trim().isNotEmpty && value.trim().isNotEmpty) {
      _filterQuery =
          '$_filterQuery ${otherFilterExist ? 'AND' : ''} $column LIKE ?'
              .trim();
      // WARNING: this could cause sql injection. how to fix it ?
      _whereArgs.add('%$value%');
    }
    return this;
  }

  QueryBuilder whereIn(String column, List<String> values) {
    _filterQuery ??= '';
    final otherFilterExist = _filterQuery != null && _filterQuery != '';

    if (column.isNotEmpty && values.isNotEmpty) {
      final placeholder = values.length > 1
          ? values.map((_) => '?').join(', ')
          : '?';
      _filterQuery =
          '$_filterQuery ${otherFilterExist ? 'AND' : ''} $column in ($placeholder)'
              .trim();
      _whereArgs.addAll(values);
    }
    return this;
  }

  QueryBuilder whereBetween<T>(String column, T min, T max) {
    _filterQuery ??= '';
    final otherFilterExist = _filterQuery != null && _filterQuery != '';

    if (column.trim().isNotEmpty &&
        min.toString().trim().isNotEmpty &&
        max.toString().trim().isNotEmpty) {
      _filterQuery =
          '$_filterQuery ${otherFilterExist ? 'AND' : ''} $column >= ? AND $column <= ?'
              .trim();
      _whereArgs
        ..add(min)
        ..add(max);
    }
    return this;
  }

  Future<List<Map<String, Object?>>> getAll() async {
    final db = await Db.use();
    final res = await db.query(
      _table,
      where: _filterQuery,
      whereArgs: _whereArgs,
      limit: _limit,
      offset: _offset,
      orderBy: _sortBy,
    );

    return res;
  }

  Future<Map<String, Object?>> getOne() async {
    final db = await Db.use();
    final res = await db.query(
      _table,
      where: _filterQuery,
      whereArgs: _whereArgs,
      limit: 1,
      offset: _offset,
    );

    return res.first;
  }

  QueryBuilder limit(int value) {
    _limit = value;

    return this;
  }

  QueryBuilder offset(int value) {
    _offset = value;

    return this;
  }

  QueryBuilder sortBy(String field, SortingDirection direction) {
    _sortBy = '"$field" ${direction.name}';

    return this;
  }
}
