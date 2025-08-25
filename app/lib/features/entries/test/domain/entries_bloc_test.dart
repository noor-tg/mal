// ignore: depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/entries/domain/repositories/entries_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/shared/where.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

class MockRepo extends Mock implements EntriesRepository {}

class MockEntry extends Mock implements Entry {}

void main() {
  group('$EntriesBloc >', () {
    addNewEntryTest();
    loadAllEntriesTest();
    addNewEntryForTodayTest();
  });
}

void addNewEntryTest() {
  var entry = fakeEntry();
  entry = entry.copyWith(
    date: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
  );
  final repo = MockRepo();
  setUpAll(() {
    registerFallbackValue(MockRepo());
  });

  blocTest<EntriesBloc, EntriesState>(
    'when send StoreEntry Event. entry should be stored correctly. but today entries should not be updated',
    build: () => EntriesBloc(repo: repo),
    setUp: () {
      // Mock the repository store method to succeed
      when(() => repo.store(any())).thenAnswer((_) async {
        return entry;
      });
    },
    act: (bloc) => bloc.add(StoreEntry(entry)),
    expect: () => [
      EntriesState(status: EntriesStatus.loading, currentEntry: entry),
      const EntriesState(status: EntriesStatus.success),
    ],
    verify: (bloc) {
      // Verify that the repository store method was called with the correct entry
      verify(() => repo.store(entry)).called(1);
    },
  );
}

void loadAllEntriesTest() {
  final entry = MockEntry();
  final repo = MockRepo();
  setUpAll(() {
    registerFallbackValue(MockRepo());
    registerFallbackValue(MockEntry());
    registerFallbackValue(Where(field: 'uid', oprand: '=', value: '1234'));
  });

  blocTest<EntriesBloc, EntriesState>(
    'when send LoadTodayEntries Event. today state should be populated',
    build: () => EntriesBloc(repo: repo),
    setUp: () {
      // Mock the repository store method to succeed
      when(repo.today).thenAnswer((_) async {
        return Result<Entry>(list: [entry], count: 1);
      });
    },
    act: (bloc) => bloc.add(LoadTodayEntries()),
    expect: () => [
      const EntriesState(status: EntriesStatus.loading),
      EntriesState(status: EntriesStatus.success, today: [entry]),
    ],
    verify: (bloc) {
      verify(repo.today).called(1);
    },
  );
}

void addNewEntryForTodayTest() {
  var entry = fakeEntry();
  entry = entry.copyWith(date: DateTime.now().toIso8601String());
  final repo = MockRepo();
  setUpAll(() {
    registerFallbackValue(MockRepo());
  });

  blocTest<EntriesBloc, EntriesState>(
    'when send StoreEntry Event. entry should be stored correctly',
    build: () => EntriesBloc(repo: repo),
    setUp: () {
      // Mock the repository store method to succeed
      when(() => repo.store(any())).thenAnswer((_) async {
        return entry;
      });
      when(repo.today).thenAnswer((_) async {
        return Result<Entry>(list: [entry], count: 1);
      });
    },
    act: (bloc) => bloc.add(StoreEntry(entry)),
    expect: () => [
      EntriesState(status: EntriesStatus.loading, currentEntry: entry),
      const EntriesState(status: EntriesStatus.success),
      const EntriesState(status: EntriesStatus.loading),
      EntriesState(status: EntriesStatus.success, today: [entry]),
    ],
    verify: (bloc) {
      // Verify that the repository store method was called with the correct entry
      verify(() => repo.store(entry)).called(1);
      verify(repo.today).called(1);
    },
  );
}
