// ignore: depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/reports/domain/entities/sums.dart';
import 'package:mal/features/reports/domain/repositories/reports_repository.dart';
import 'package:mal/features/reports/domain/bloc/daily_sums/daily_sums_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

class MockReportsRepository extends Mock implements ReportsRepository {}

void main() {
  group('DailySumsBloc', () {
    late ReportsRepository mockRepo;
    late DailySumsBloc dailySumsBloc;

    setUp(() {
      mockRepo = MockReportsRepository();
      dailySumsBloc = DailySumsBloc(repo: mockRepo);
    });

    tearDown(() {
      dailySumsBloc.close();
    });

    test('initial state is correct', () {
      expect(dailySumsBloc.state, equals(const DailySumsState()));
    });

    group('RequestDailySumsData', () {
      const mockSums = Sums(
        incomes: [1000, 1500, 2000],
        expenses: [500, 800, 600],
      );

      blocTest<DailySumsBloc, DailySumsState>(
        'emits [loading, success] when data is fetched successfully',
        build: () {
          when(() => mockRepo.dailySums()).thenAnswer((_) async => mockSums);
          return dailySumsBloc;
        },
        act: (bloc) => bloc.add(RequestDailySumsData()),
        expect: () => [
          const DailySumsState(status: BlocStatus.loading),
          const DailySumsState(status: BlocStatus.success, list: mockSums),
        ],
        verify: (_) {
          verify(() => mockRepo.dailySums()).called(1);
        },
      );

      blocTest<DailySumsBloc, DailySumsState>(
        'emits [loading, failure] when repository throws exception',
        build: () {
          when(
            () => mockRepo.dailySums(),
          ).thenThrow(Exception('Network error'));
          return dailySumsBloc;
        },
        act: (bloc) => bloc.add(RequestDailySumsData()),
        expect: () => [
          const DailySumsState(status: BlocStatus.loading),
          const DailySumsState(
            status: BlocStatus.failure,
            errorMessage: 'Exception: Network error',
          ),
        ],
        verify: (_) {
          verify(() => mockRepo.dailySums()).called(1);
        },
      );

      const emptySums = Sums(incomes: [], expenses: []);
      blocTest<DailySumsBloc, DailySumsState>(
        'emits [loading, success] with empty lists when repository returns empty data',
        build: () {
          when(() => mockRepo.dailySums()).thenAnswer((_) async => emptySums);
          return dailySumsBloc;
        },
        act: (bloc) => bloc.add(RequestDailySumsData()),
        expect: () => [
          const DailySumsState(status: BlocStatus.loading),
          const DailySumsState(status: BlocStatus.success, list: emptySums),
        ],
        verify: (_) {
          verify(() => mockRepo.dailySums()).called(1);
        },
      );

      blocTest<DailySumsBloc, DailySumsState>(
        'emits [loading, failure] when repository throws generic error',
        build: () {
          when(() => mockRepo.dailySums()).thenThrow('Connection timeout');
          return dailySumsBloc;
        },
        act: (bloc) => bloc.add(RequestDailySumsData()),
        expect: () => [
          const DailySumsState(status: BlocStatus.loading),
          const DailySumsState(
            status: BlocStatus.failure,
            errorMessage: 'Connection timeout',
          ),
        ],
        verify: (_) {
          verify(() => mockRepo.dailySums()).called(1);
        },
      );

      blocTest<DailySumsBloc, DailySumsState>(
        'handles multiple consecutive requests correctly',
        build: () {
          when(() => mockRepo.dailySums()).thenAnswer((_) async => mockSums);
          return dailySumsBloc;
        },
        act: (bloc) {
          bloc
            ..add(RequestDailySumsData())
            ..add(RequestDailySumsData());
        },
        expect: () => [
          const DailySumsState(status: BlocStatus.loading),
          const DailySumsState(status: BlocStatus.success, list: mockSums),
          const DailySumsState(status: BlocStatus.loading),
          const DailySumsState(status: BlocStatus.success, list: mockSums),
        ],
        verify: (_) {
          verify(() => mockRepo.dailySums()).called(2);
        },
      );
    });

    group('DailySumsState', () {
      test('supports value equality', () {
        const state1 = DailySumsState();
        const state2 = DailySumsState();
        expect(state1, equals(state2));
      });

      test('props are correct', () {
        const state = DailySumsState(
          list: Sums(incomes: [100], expenses: [50]),
          status: BlocStatus.success,
          errorMessage: 'test error',
        );

        expect(
          state.props,
          equals([
            const Sums(incomes: [100], expenses: [50]),
            BlocStatus.success,
            'test error',
          ]),
        );
      });

      test('copyWith works correctly', () {
        const originalState = DailySumsState();
        const newSums = Sums(incomes: [100], expenses: [50]);

        final updatedState = originalState.copyWith(
          status: BlocStatus.success,
          list: newSums,
          errorMessage: 'test error',
        );

        expect(updatedState.status, equals(BlocStatus.success));
        expect(updatedState.list, equals(newSums));
        expect(updatedState.errorMessage, equals('test error'));
      });

      test('copyWith retains original values when null is passed', () {
        const originalState = DailySumsState(
          status: BlocStatus.success,
          list: Sums(incomes: [100], expenses: [50]),
          errorMessage: 'original error',
        );

        final updatedState = originalState.copyWith();

        expect(updatedState.status, equals(originalState.status));
        expect(updatedState.list, equals(originalState.list));
        expect(updatedState.errorMessage, equals(originalState.errorMessage));
      });

      test('default constructor sets correct initial values', () {
        const state = DailySumsState();

        expect(state.status, equals(BlocStatus.initial));
        expect(state.list, equals(const Sums(incomes: [], expenses: [])));
        expect(state.errorMessage, isNull);
      });
    });
  });
}
