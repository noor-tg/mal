import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/search/data/repositores/sql_respository.dart';
import 'package:mal/features/search/domain/bloc/filters.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/result.dart';
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
      expect(res, isA<Result<Entry>>());
      expect(res.list, isA<List<Entry>>());
      if (res.list.isNotEmpty) {
        final entry = res.list.first;
        expect(entry.uid.length, uuid.v4().length);
        expect(types, contains(entry.type));
        expect(entry.amount, greaterThan(0));

        expect(entry, isA<Entry>());
        expect(entry.uid, isA<String>());
        expect(entry.type, isA<String>());
        expect(entry.category, isA<String>());
        expect(entry.date, isA<String>());
        expect(entry.amount, isA<int>());
      }
    });

    test('expect empty list when offset is byond result total', () async {
      final totals = await db.query('entries');
      final res = await repo.searchEntries(term: '', offset: totals.length);

      expect(res.list, isEmpty);
      expect(res.count, 200);
    });

    test(
      'expect all results returned from latest to oldest when there is no search term',
      () async {
        final res = await repo.searchEntries(term: '');

        expect(res.count, greaterThan(0));
        expect(res.list.first, isA<Entry>());

        final latest = DateTime.parse(res.list.first.date);
        final older = DateTime.parse(res.list[1].date);
        expect(latest.isAfter(older), true);
      },
    );

    test('search by type', () async {
      // when filter by type
      final res = await repo.searchEntries(term: types[0]);
      // then all result should be related to this type
      for (final entry in res.list) {
        expect(entry.type, types[0]);
      }
      // other type search result should not contain first type filter
      final other = await repo.searchEntries(term: types[1]);

      for (final entry in other.list) {
        expect(entry.type, isNot(types[0]));
      }
    });

    test('search by category', () async {
      final random = Random();
      final category = categories[random.nextInt(categories.length)].title;
      final res = await repo.searchEntries(term: category);
      for (final entry in res.list) {
        expect(entry.category, category);
      }
      final filteredCategories = categories
          .where((cat) => cat.title != category)
          .toList();
      final otherCategory =
          filteredCategories[random.nextInt(filteredCategories.length)].title;
      for (final entry in res.list) {
        expect(entry.category, isNot(otherCategory));
      }
    });
  });
  advancedSearchTests();
}

void advancedSearchTests() {
  group('Advanced Search', () {
    late SqlRespository repo;
    // late Database db;
    setUpAll(() async {
      await dotenv.load();
      // db = await Db.use();
      await generateData();
      repo = SqlRespository();
    });
    test('filter by categories correctly', () async {
      // prepare
      final res = await repo.advancedSearch(
        SearchState(
          filters: Filters.withCurrentYear(
            categories: [categories[0].title, categories[1].title],
          ),
        ),
      );
      expect(res, isA<Result<Entry>>());
      expect(res.list.length, greaterThan(0));
      expect([
        categories[0].title,
        categories[1].title,
      ], contains(res.list.first.category));
      expect(categories[2].title, isNot(equals(res.list.last.category)));
    });
    test('filter by type correctly', () async {
      // prepare
      final res = await repo.advancedSearch(
        SearchState(filters: Filters.withCurrentYear(type: EntryType.income)),
      );
      expect(res, isA<Result<Entry>>());
      expect(res.list.length, greaterThan(0));
      expect(res.list.first.type, 'دخل');
      expect(res.list.last.type, 'دخل');
    });
    test('filter by amount range', () async {
      // prepare
      final res = await repo.advancedSearch(
        SearchState(
          filters: Filters.withCurrentYear(
            amountRange: const Range(min: 0, max: 100),
          ),
        ),
      );
      expect(res, isA<Result<Entry>>());
      expect(res.list.length, greaterThan(0));
      expect(res.list.first.amount, lessThanOrEqualTo(100));
      expect(res.list.last.amount, lessThanOrEqualTo(100));
    });
    test('filter by date range', () async {
      // prepare
      final res = await repo.advancedSearch(
        SearchState(filters: Filters.withCurrentYear()),
      );
      final now = DateTime.now();
      expect(res, isA<Result<Entry>>());
      expect(res.list.length, greaterThan(0));
      expect(
        DateTime.parse(res.list.first.date).isAfter(DateTime(now.year)),
        true,
      );
    });
    test('check for default applied sorting (date desc)', () async {
      // prepare
      final res = await repo.advancedSearch(
        SearchState(filters: Filters.withCurrentYear()),
      );
      expect(res, isA<Result<Entry>>());
      expect(res.list.length, greaterThan(0));
      expect(
        DateTime.parse(
          res.list.first.date,
        ).isAfter(DateTime.parse(res.list.last.date)),
        true,
      );
    });
  });
}
