// ignore: depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/reports/domain/bloc/reports_bloc.dart';
import 'package:mal/features/reports/domain/repositories/reports_repository.dart';
import 'package:mal/utils.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

// Mock class for ReportsRepository
class MockReportsRepository extends Mock implements ReportsRepository {}

void main() {
  checkInitValuesTest();

  group('LoadTotals', () {
    loadTotalsSuccessTest();
    loadTotalsFailsTest();
    loadTotalsMultipleEventsTest();
  });
}

void checkInitValuesTest() {
  group('$ReportsBloc >', () {
    final mockRepo = MockReportsRepository();
    final reportsBloc = ReportsBloc(repo: mockRepo);
    setUp(() {
      registerFallbackValue(mockRepo);
    });

    test('initial state is correct', () {
      expect(reportsBloc.state, const ReportsState());
      expect(reportsBloc.state.totalsStatus, BlocStatus.initial);
    });
  });
}

void loadTotalsSuccessTest() {
  final mockRepo = MockReportsRepository();
  final reportsBloc = ReportsBloc(repo: mockRepo);
  setUp(() {
    registerFallbackValue(mockRepo);
  });
  const mockTotals = Totals(balance: 0, incomes: 0, expenses: 0);
  blocTest<ReportsBloc, ReportsState>(
    'emits [loading, success] when repo.totals() succeeds',
    build: () {
      when(mockRepo.totals).thenAnswer((_) async => mockTotals);
      return reportsBloc;
    },
    act: (bloc) => bloc.add(LoadTotals()),
    expect: () => [
      const ReportsState(totalsStatus: BlocStatus.loading),
      const ReportsState(totalsStatus: BlocStatus.success, totals: mockTotals),
    ],
    verify: (_) {
      verify(mockRepo.totals).called(1);
    },
  );
}

void loadTotalsFailsTest() {
  final mockRepo = MockReportsRepository();
  final reportsBloc = ReportsBloc(repo: mockRepo);
  setUp(() {
    registerFallbackValue(mockRepo);
  });
  blocTest<ReportsBloc, ReportsState>(
    'emits [loading, failure] when repo.totals() throws exception',
    build: () {
      when(mockRepo.totals).thenThrow(Exception('db error'));
      return reportsBloc;
    },
    act: (bloc) => bloc.add(LoadTotals()),
    expect: () => [
      const ReportsState(totalsStatus: BlocStatus.loading),
      const ReportsState(
        totalsStatus: BlocStatus.failure,
        errorMessage: 'Exception: db error',
      ),
    ],
    verify: (_) {
      verify(mockRepo.totals).called(1);
    },
  );
}

void loadTotalsMultipleEventsTest() {
  final mockRepo = MockReportsRepository();
  final reportsBloc = ReportsBloc(repo: mockRepo);
  const mockTotals = Totals(balance: 0, incomes: 0, expenses: 0);
  setUp(() {
    registerFallbackValue(mockRepo);
  });
  blocTest<ReportsBloc, ReportsState>(
    'handles multiple LoadTotals events correctly',
    build: () {
      when(mockRepo.totals).thenAnswer((_) async => mockTotals);
      return reportsBloc;
    },
    act: (bloc) {
      bloc
        ..add(LoadTotals())
        ..add(LoadTotals());
    },
    expect: () => [
      const ReportsState(totalsStatus: BlocStatus.loading),
      const ReportsState(totalsStatus: BlocStatus.success, totals: mockTotals),
      const ReportsState(totalsStatus: BlocStatus.loading),
      const ReportsState(totalsStatus: BlocStatus.success, totals: mockTotals),
    ],
    verify: (_) {
      verify(mockRepo.totals).called(2);
    },
  );
}
