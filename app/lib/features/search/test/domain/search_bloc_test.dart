import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/search/data/repositores/sql_respository.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/shared/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group(SearchBloc, () {
    late SearchBloc searchBloc;
    late Database db;
    late List<Map<String, dynamic>> all;
    setUpAll(() async {
      databaseFactory = databaseFactoryFfi;
      await dotenv.load();
      db = await Db.use();
      await generateData();
      all = await db.query('entries');
    });
    late Result<Entry> result;
    setUp(() async {
      final repo = SqlRespository();
      result = await repo.searchEntries(term: types[0]);
      searchBloc = SearchBloc(searchRepo: SqlRespository());
    });
    test('init state correct', () {
      expect(searchBloc.state.status, SearchStatus.initial);
    });

    blocTest<SearchBloc, SearchState>(
      'emit [loading, success] when send search event',
      build: () => searchBloc,
      act: (bloc) => bloc.add(SearchEvent(term: types[0], offset: 0)),
      wait: const Duration(milliseconds: 1),
      expect: () => [
        equals(const SearchState(status: SearchStatus.loading)),
        equals(
          SearchState(
            status: SearchStatus.success,
            term: types[0],
            result: result,
          ),
        ),
      ],
    );
    blocTest<SearchBloc, SearchState>(
      'emit loading, success with noMoreData when send search event with offset more than total',
      build: () => searchBloc,
      act: (bloc) => bloc.add(SearchEvent(term: types[0], offset: all.length)),
      wait: const Duration(milliseconds: 1),
      expect: () => [
        equals(const SearchState(status: SearchStatus.loading)),
        equals(
          SearchState(
            status: SearchStatus.success,
            term: types[0],
            offset: 200,
            noMoreData: true,
            result: const Result(list: [], count: 0),
          ),
        ),
      ],
    );
  });
}
