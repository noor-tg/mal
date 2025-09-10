// ignore: depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/reports/domain/bloc/totals/totals_bloc.dart';
import 'package:mal/features/reports/domain/entities/totals.dart';
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
  group('$TotalsBloc >', () {
    final mockRepo = MockReportsRepository();
    final reportsBloc = TotalsBloc(repo: mockRepo);
    setUp(() {
      registerFallbackValue(mockRepo);
    });

    test('initial state is correct', () {
      expect(reportsBloc.state, const TotalsState());
      expect(reportsBloc.state.status, BlocStatus.initial);
    });
  });
}

void loadTotalsSuccessTest() {
  final mockRepo = MockReportsRepository();
  final reportsBloc = TotalsBloc(repo: mockRepo);
  setUp(() {
    registerFallbackValue(mockRepo);
  });
  const mockTotals = Totals(balance: 0, incomes: 0, expenses: 0);
  blocTest<TotalsBloc, TotalsState>(
    'emits [loading, success] when repo.totals() succeeds',
    build: () {
      when(() => mockRepo.totals(any())).thenAnswer((_) async => mockTotals);
      return reportsBloc;
    },
    act: (bloc) => bloc.add(RequestTotalsData(uuid.v4())),
    expect: () => [
      const TotalsState(status: BlocStatus.loading),
      const TotalsState(status: BlocStatus.success, totals: mockTotals),
    ],
    verify: (_) {
      verify(() => mockRepo.totals(any())).called(1);
    },
  );
}

void loadTotalsFailsTest() {
  final mockRepo = MockReportsRepository();
  final reportsBloc = TotalsBloc(repo: mockRepo);
  setUp(() {
    registerFallbackValue(mockRepo);
  });
  blocTest<TotalsBloc, TotalsState>(
    'emits [loading, failure] when repo.totals() throws exception',
    build: () {
      when(() => mockRepo.totals(any())).thenThrow(Exception('db error'));
      return reportsBloc;
    },
    act: (bloc) => bloc.add(RequestTotalsData(uuid.v4())),
    expect: () => [
      const TotalsState(status: BlocStatus.loading),
      const TotalsState(
        status: BlocStatus.failure,
        errorMessage: 'Exception: db error',
      ),
    ],
    verify: (_) {
      verify(() => mockRepo.totals(any())).called(1);
    },
  );
}

void loadTotalsMultipleEventsTest() {
  final mockRepo = MockReportsRepository();
  final reportsBloc = TotalsBloc(repo: mockRepo);
  const mockTotals = Totals(balance: 0, incomes: 0, expenses: 0);
  setUp(() {
    registerFallbackValue(mockRepo);
  });
  blocTest<TotalsBloc, TotalsState>(
    'handles multiple LoadTotals events correctly',
    build: () {
      when(() => mockRepo.totals(any())).thenAnswer((_) async => mockTotals);
      return reportsBloc;
    },
    act: (bloc) {
      bloc
        ..add(RequestTotalsData(uuid.v4()))
        ..add(RequestTotalsData(uuid.v4()));
    },
    expect: () => [
      const TotalsState(status: BlocStatus.loading),
      const TotalsState(status: BlocStatus.success, totals: mockTotals),
      const TotalsState(status: BlocStatus.loading),
      const TotalsState(status: BlocStatus.success, totals: mockTotals),
    ],
    verify: (_) {
      verify(() => mockRepo.totals(any())).called(2);
    },
  );
}
