import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/search/data/repositores/sql_respository.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/shared/db.dart';
import 'package:mal/utils.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    databaseFactory = databaseFactoryFfi;
  });
  group('search repository > ', () {
    late SqlRespository repo;
    late Database db;
    setUpAll(() async {
      await dotenv.load();
      db = await Db.use();
      await generateData();
      repo = SqlRespository();
    });

    test('simple search by description, category or type', () async {
      final res = await repo.searchEntries(term: 'h');
      expect(res, isNotEmpty);
      expect(res, isA<List<Entry>>());
      if (res.isNotEmpty) {
        final entry = res.first;
        expect(entry.uid.length, uuid.v4().length);
        expect(['منصرف', 'دخل'], contains(res.first.type));
        expect(entry.amount, greaterThan(0));

        expect(entry, isA<Entry>());
        expect(entry.uid, isA<String>());
        expect(entry.type, isA<String>());
        expect(entry.category, isA<String>());
        expect(entry.date, isA<String>());
        expect(entry.amount, isA<int>());
      }
    });

    test('expect empty list when there is no related result', () async {
      final totals = await db.query('entries');
      final res = await repo.searchEntries(term: 'h', offset: totals.length);

      expect(res, isEmpty);
    });

    test(
      'expect all results returned from latest to oldest when there is no search term',
      () async {
        final res = await repo.searchEntries(term: '');

        expect(res.length, greaterThan(0));
        expect(res.first, isA<Entry>());

        final latest = DateTime.parse(res[0].date);
        final older = DateTime.parse(res[1].date);
        expect(latest.isAfter(older), true);
      },
    );
  });
}
