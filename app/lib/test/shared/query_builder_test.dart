// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mal/data.dart';
import 'package:mal/shared/query_builder.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    await dotenv.load();
    databaseFactory = databaseFactoryFfi;
    await generateData();
  });
  group(QueryBuilder, () {
    test(
      'set table on init, defaults for where , whereArgs, limit, offset',
      () async {
        final q = QueryBuilder('entries');

        expect(QueryBuilder, isNot(null));

        expect(q.table, isA<String>());
        expect(q.table, 'entries');

        expect(q.glimit, isA<int>());
        expect(q.glimit, 10);

        expect(q.goffset, isA<int>());
        expect(q.goffset, 0);

        expect(q.filterQuery, isA<String?>());
        expect(q.filterQuery, null);

        expect(q.whereArgs, isA<List<Object?>>());
        expect(q.whereArgs, []);

        expect(q.gsortBy, isA<String?>());
        expect(q.gsortBy, null);
      },
    );

    test('filter by single column', () {
      final q = QueryBuilder('entries');

      // ignore: cascade_invocations
      q.where('category', '=', 'test');

      expect(q.filterQuery, 'category = ?');
      expect(q.whereArgs, ['test']);
    });

    test('filter by like', () {
      final q = QueryBuilder('entries');

      // ignore: cascade_invocations
      q.whereLike('category', 'test');

      expect(q.filterQuery, 'category LIKE ?');
      expect(q.whereArgs, ['%test%']);
    });

    test('filter by in list', () {
      final q = QueryBuilder('entries');

      // ignore: cascade_invocations
      q.whereIn('category', ['ok', 'test']);

      expect(q.filterQuery, 'category in (?, ?)');
      expect(q.whereArgs, ['ok', 'test']);
    });

    test('filter by range', () {
      final q = QueryBuilder('entries');

      // ignore: cascade_invocations
      q.whereBetween<int>('amount', 0, 10);

      expect(q.filterQuery, 'amount >= ? AND amount <= ?');
      expect(q.whereArgs, [0, 10]);
    });

    test('when use where 2 times there is and in filterQuery', () {
      final q = QueryBuilder('entries');

      // ignore: cascade_invocations
      q.where('category', '=', 'test').where('description', '=', 'ok');

      expect(q.filterQuery, 'category = ? AND description = ?');
      expect(q.whereArgs, ['test', 'ok']);
    });

    test('get list from table', () async {
      final q = QueryBuilder('entries');

      final result = await q.getAll();
      expect(result, isA<List<Map<String, Object?>>>());
      expect(result.length, greaterThan(0));
    });

    test('get single row from table', () async {
      final q = QueryBuilder('entries');

      final result = await q.getOne();
      expect(result, isA<Map<String, Object?>>());
      expect(result['uid'], isA<String>());
    });
  });
}
