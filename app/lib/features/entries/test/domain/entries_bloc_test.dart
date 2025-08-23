// ignore: depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/entries/domain/repositories/entries_repository.dart';
import 'package:mal/shared/data/models/entry.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

class MockRepo extends Mock implements EntriesRepository {}

class MockEntry extends Mock implements Entry {}

void main() {
  group('$EntriesBloc >', () {
    addNewEntryTest();
  });
}

void addNewEntryTest() {
  final entry = MockEntry();
  final repo = MockRepo();
  setUpAll(() {
    registerFallbackValue(MockRepo());
    registerFallbackValue(MockEntry());
  });

  blocTest<EntriesBloc, EntriesState>(
    'when send StoreEntry Event. entry should be stored correctly',
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
      EntriesState(status: EntriesStatus.success, all: [entry]),
    ],
    verify: (bloc) {
      // Verify that the repository store method was called with the correct entry
      verify(() => repo.store(entry)).called(1);
    },
  );
}
