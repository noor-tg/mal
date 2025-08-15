// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:mal/data.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/features/search/domain/bloc/filters.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/domain/bloc/sorting.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

class MockRepo extends Mock implements SearchRepository {}

void main() {
  group('$SearchBloc >', () {
    advancedSearchByCategory();
    advancedSearchByAmountRange();
    advancedSearchByDateRange();
    advancedSearchByType();
    sorting();
    applyAdvancedFilters();
    clearAdvancedFilters();
  });
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

void clearAdvancedFilters() {
  late SearchRepository repo;
  late SearchBloc searchBloc;

  setUp(() {
    registerFallbackValue(FakeSearchState());

    // prepare default values for Search bloc
    repo = MockRepo();
    searchBloc = SearchBloc(searchRepo: repo);
  });
  blocTest<SearchBloc, SearchState>(
    'when send ClearFilters. then the state should be reset',
    build: () => searchBloc,
    act: (bloc) => bloc.add(ClearFilters()),
    expect: () => [SearchState()],
  );
}

class FakeSearchState extends Fake implements SearchState {}

void applyAdvancedFilters() {
  late SearchRepository repo;
  late SearchBloc searchBloc;

  setUp(() {
    registerFallbackValue(FakeSearchState());

    // prepare default values for Search bloc
    repo = MockRepo();
    searchBloc = SearchBloc(searchRepo: repo);
  });
  blocTest<SearchBloc, SearchState>(
    'when send ApplyFilters. then repository advancedSearch func should be called',
    build: () {
      const mockResult = Result<Entry>(list: [], count: 0);

      when(
        () => repo.advancedSearch(any()),
      ).thenAnswer((_) async => mockResult);
      return searchBloc;
    },
    act: (bloc) => bloc.add(ApplyFilters()),
    verify: (bloc) {
      verify(() => repo.advancedSearch(any())).called(1);
    },

    expect: () => [
      predicate<SearchState>((state) => state.status == SearchStatus.loading),
      predicate<SearchState>(
        (state) =>
            state.status == SearchStatus.success && state.result.count == 0,
      ),
    ],
  );
}

void sorting() {
  group('Sorting', () {
    late SearchRepository repo;
    late SearchBloc searchBloc;
    setUp(() {
      // prepare default values for Search bloc
      repo = MockRepo();
      searchBloc = SearchBloc(searchRepo: repo);
    });
    test('default sorting by date from latest to oldest', () {
      expect(searchBloc.state, SearchState());
      expect(searchBloc.state.sorting.field, SortingField.date);
      expect(searchBloc.state.sorting.direction, SortingDirection.desc);
    });
    blocTest<SearchBloc, SearchState>(
      'when SortByField Event is sent with amount value. Sorting field should be amount',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const SortBy(field: SortingField.amount)),
      expect: () => [
        SearchState(
          sorting: const Sorting(
            field: SortingField.amount,
            direction: SortingDirection.asc,
          ),
        ),
      ],
    );
    blocTest<SearchBloc, SearchState>(
      'when SortBy Event value equals existing sorting value. Sorting direction should be changed',
      build: () {
        searchBloc.add(const SortBy(field: SortingField.amount));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SortBy(field: SortingField.amount)),
      expect: () => [
        SearchState(
          sorting: const Sorting(
            field: SortingField.amount,
            direction: SortingDirection.asc,
          ),
        ),
        SearchState(sorting: const Sorting(field: SortingField.amount)),
      ],
    );
  });
}

void advancedSearchByType() {
  group('Advanced Search > By Type >', () {
    late SearchRepository repo;
    late SearchBloc searchBloc;
    setUp(() {
      // prepare default values for Search bloc
      repo = MockRepo();
      searchBloc = SearchBloc(searchRepo: repo);
    });
    test('check for init filter by type', () {
      expect(searchBloc.state, SearchState());
      expect(searchBloc.state.filters.type, EntryType.all);
    });
    blocTest<SearchBloc, SearchState>(
      'when send FilterByExpense Event is sent. filter type should be set to expense',
      build: () => searchBloc,
      act: (bloc) => bloc.add(FilterByExpense()),
      expect: () => [
        SearchState(filters: Filters.withCurrentYear(type: EntryType.expense)),
      ],
    );
    blocTest<SearchBloc, SearchState>(
      'when send FilterByIncome Event is sent. filter type should be set to income',
      build: () => searchBloc,
      act: (bloc) => bloc.add(FilterByIncome()),
      expect: () => [
        SearchState(filters: Filters.withCurrentYear(type: EntryType.income)),
      ],
    );
    blocTest<SearchBloc, SearchState>(
      'when send ClearFilterByType Event is sent. filter type should be set to all',
      build: () => searchBloc,
      act: (bloc) => bloc.add(ClearFilterByType()),
      expect: () => [SearchState(filters: Filters.withCurrentYear())],
    );
  });
}

void advancedSearchByDateRange() {
  group('Advanced Search > By Date range', () {
    late SearchRepository repo;
    late SearchBloc searchBloc;
    final now = DateTime.now();
    setUp(() {
      // prepare default values for Search bloc
      repo = MockRepo();
      searchBloc = SearchBloc(searchRepo: repo);
    });
    test('check for init date in filters', () {
      expect(searchBloc.state, SearchState());
      expect(searchBloc.state.filters.dateRange, isA<Range<DateTime>>());
      expect(
        searchBloc.state.filters.dateRange,
        Range(
          min: DateTime(now.year),
          max: DateTime(now.year, now.month, now.day),
        ),
      );
    });
    blocTest<SearchBloc, SearchState>(
      'when send UpdateMinDate event . min date state should be changed',
      build: () => searchBloc,
      act: (bloc) => bloc.add(UpdateMinDate(DateTime(now.year))),
      expect: () => [
        SearchState(
          filters: Filters(
            dateRange: Range(
              min: DateTime(now.year),
              max: DateTime(now.year, now.month, now.day),
            ),
          ),
        ),
      ],
    );
    blocTest<SearchBloc, SearchState>(
      'when send UpdateMaxDate event . max date state should be changed',
      build: () => searchBloc,
      act: (bloc) => bloc.add(UpdateMaxDate(DateTime(now.year, now.month))),
      expect: () => [
        SearchState(
          filters: Filters(
            dateRange: Range(
              min: DateTime(now.year),
              max: DateTime(now.year, now.month),
            ),
          ),
        ),
      ],
    );
  });
}

void advancedSearchByAmountRange() {
  group('Advanced Search > By Amount range', () {
    late SearchRepository repo;
    late SearchBloc searchBloc;
    setUp(() {
      // prepare default values for Search bloc
      repo = MockRepo();
      searchBloc = SearchBloc(searchRepo: repo);
    });
    test('check for init amount in filters', () {
      expect(searchBloc.state, SearchState());
      expect(searchBloc.state.filters.amountRange, isA<Range<int>>());
      expect(
        searchBloc.state.filters.amountRange,
        const Range<int>(min: 0, max: 0),
      );
    });
    blocTest<SearchBloc, SearchState>(
      'when send UpdateMinAmount event . min amount state should be changed',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const UpdateMinAmount(10)),
      expect: () => [
        SearchState(
          filters: Filters.withCurrentYear(
            amountRange: const Range(min: 10, max: 10),
          ),
        ),
      ],
    );
    blocTest<SearchBloc, SearchState>(
      'when send UpdateMaxAmount event . max amount state should be changed',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const UpdateMaxAmount(20)),
      expect: () => [
        SearchState(
          filters: Filters.withCurrentYear(
            amountRange: const Range(min: 0, max: 20),
          ),
        ),
      ],
    );
  });
}

advancedSearchByCategory() {
  group('Advanced Search > By Categories >', () {
    late SearchRepository repo;
    late SearchBloc searchBloc;
    setUp(() {
      // prepare default values for Search bloc
      repo = MockRepo();
      searchBloc = SearchBloc(searchRepo: repo);
    });
    test('check for init categories values', () {
      // check state as unit test for init values (categories list)
      expect(searchBloc.state, SearchState());
      expect(searchBloc.state.filters.categories, []);
    });
    blocTest<SearchBloc, SearchState>(
      'when send toggleCategory Event filters should change accordingly',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const ToggleCategory(category: 'food')),
      expect: () => [
        SearchState(
          filters: Filters.withCurrentYear(categories: const ['food']),
        ),
      ],
    );
  });
}
