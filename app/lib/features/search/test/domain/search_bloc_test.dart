// import 'package:flutter_dotenv/flutter_dotenv.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mal/data.dart';
// import 'package:mal/features/search/data/repositores/sql_respository.dart';
// import 'package:mal/features/search/domain/bloc/search_bloc.dart';
// import 'package:mal/result.dart';
// import 'package:mal/shared/data/models/entry.dart';
// import 'package:mal/shared/db.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/features/search/domain/bloc/filters.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

class MockRepo extends Mock implements SearchRepository {}

void main() {
  group('$SearchBloc >', advancedSearchGroup);
  // group(SearchBloc, () {
  //   late SearchBloc searchBloc;
  //   late Database db;
  //   // ignore: unused_local_variable
  //   late List<Map<String, dynamic>> all;

  //   setUpAll(() async {
  //     databaseFactory = databaseFactoryFfi;
  //     await dotenv.load();
  //     db = await Db.use();
  //     await generateData();
  //     all = await db.query('entries');
  //   });

  //   late Result<Entry> result;

  //   setUp(() async {
  //     final repo = SqlRespository();
  //     result = await repo.searchEntries(term: types[0]);
  //     searchBloc = SearchBloc(searchRepo: SqlRespository());
  //   });

  //   test('init state correct', () {
  //     expect(searchBloc.state.status, SearchStatus.initial);
  //   });

  //   blocTest<SearchBloc, SearchState>(
  //     'emit [loading, success] when send search event',
  //     build: () => searchBloc,
  //     act: (bloc) => bloc.add(SimpleSearch(term: types[0], offset: 0)),
  //     wait: const Duration(milliseconds: 10),
  //     expect: () => [
  //       equals(SearchState(status: SearchStatus.loading)),
  //       equals(
  //         SearchState(
  //           status: SearchStatus.success,
  //           term: types[0],
  //           result: result,
  //         ),
  //       ),
  //     ],
  //   );

  // TODO: fix this test
  // blocTest<SearchBloc, SearchState>(
  //   'emit next items in offset when send loadmore event',
  //   build: () => searchBloc,
  //   act: (bloc) => bloc.add(LoadMore()),
  //   wait: const Duration(milliseconds: 10),
  //   expect: () => [
  //     equals(
  //       SearchState(
  //         status: SearchStatus.success,
  //         offset: 10,
  //         result: Result(list: searchBloc.state.result.list, count: 200),
  //       ),
  //     ),
  //   ],
  // );
  // });
}

advancedSearchGroup() {
  group('Advanced Search >', () {
    late SearchRepository repo;
    late SearchBloc searchBloc;
    setUp(() {
      // prepare default values for Search bloc
      repo = MockRepo();
      searchBloc = SearchBloc(searchRepo: repo);
    });
    test('check for init categories values', () {
      // check state as unit test for init values (categories list)
      expect(searchBloc.state, const SearchState());
      expect(searchBloc.state.filters.categories, []);
    });
    blocTest<SearchBloc, SearchState>(
      'when send toggleCategory Event filters should change accordingly',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const ToggleCategory(category: 'food')),
      expect: () => [
        const SearchState(filters: Filters(categories: ['food'])),
      ],
    );
  });
}
