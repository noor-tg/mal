import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:mal/features/calendar/domain/repositories/day_sums.dart';
import 'package:mal/features/calendar/domain/bloc/calendar_bloc.dart';
import 'package:mal/utils.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

// Mock class for CalendarRepository
class MockCalendarRepository extends Mock implements CalendarRepository {}

void main() {
  group('CalendarBloc', () {
    late CalendarBloc calendarBloc;
    late MockCalendarRepository mockRepo;

    setUp(() {
      mockRepo = MockCalendarRepository();
      calendarBloc = CalendarBloc(repo: mockRepo);
    });

    tearDown(() {
      calendarBloc.close();
    });

    test('initial state is CalendarState with initial status', () {
      expect(calendarBloc.state, equals(const CalendarState()));
    });

    group('FetchSelectedMonthData', () {
      final mockDaySumsList = <DaySums>[
        DaySums(incomes: 1000, expenses: 500, date: DateTime(2024)),
        DaySums(incomes: 2000, expenses: 800, date: DateTime(2024, 1, 2)),
        DaySums(incomes: 1500, expenses: 600, date: DateTime(2024, 1, 3)),
      ];

      blocTest<CalendarBloc, CalendarState>(
        'emits [loading, success] when getSelectedMonthSums succeeds',
        build: () {
          when(
            () => mockRepo.getSelectedMonthSums(2024, 1, any()),
          ).thenAnswer((_) async => mockDaySumsList);
          return calendarBloc;
        },
        act: (bloc) => bloc.add(FetchSelectedMonthData(2024, 1, uuid.v4())),
        expect: () => <CalendarState>[
          const CalendarState(status: BlocStatus.loading),
          CalendarState(
            status: BlocStatus.success,
            selectedMonthData: mockDaySumsList,
          ),
        ],
        verify: (_) {
          verify(() => mockRepo.getSelectedMonthSums(2024, 1, any())).called(1);
        },
      );

      blocTest<CalendarBloc, CalendarState>(
        'emits [loading, failure] when getSelectedMonthSums throws exception',
        build: () {
          when(
            () => mockRepo.getSelectedMonthSums(2024, 1, any()),
          ).thenThrow(Exception('Failed to fetch data'));
          return calendarBloc;
        },
        act: (bloc) => bloc.add(FetchSelectedMonthData(2024, 1, uuid.v4())),
        expect: () => <CalendarState>[
          const CalendarState(status: BlocStatus.loading),
          const CalendarState(
            status: BlocStatus.failure,
            errorMessage: 'Exception: Failed to fetch data',
          ),
        ],
        verify: (_) {
          verify(() => mockRepo.getSelectedMonthSums(2024, 1, any())).called(1);
        },
      );

      final uid = uuid.v4();
      blocTest<CalendarBloc, CalendarState>(
        'emits [loading, success] with empty list when no data is available',
        build: () {
          when(
            () => mockRepo.getSelectedMonthSums(2024, 2, uid),
          ).thenAnswer((_) async => <DaySums>[]);
          return calendarBloc;
        },
        act: (bloc) => bloc.add(FetchSelectedMonthData(2024, 2, uid)),
        expect: () => <CalendarState>[
          const CalendarState(status: BlocStatus.loading),
          const CalendarState(status: BlocStatus.success),
        ],
        verify: (_) {
          verify(() => mockRepo.getSelectedMonthSums(2024, 2, uid)).called(1);
        },
      );

      blocTest<CalendarBloc, CalendarState>(
        'handles multiple consecutive fetch requests correctly',
        build: () {
          when(
            () => mockRepo.getSelectedMonthSums(2024, 1, uid),
          ).thenAnswer((_) async => mockDaySumsList);
          when(
            () => mockRepo.getSelectedMonthSums(2024, 2, uid),
          ).thenAnswer((_) async => <DaySums>[]);
          return calendarBloc;
        },
        act: (bloc) {
          bloc
            ..add(FetchSelectedMonthData(2024, 1, uid))
            ..add(FetchSelectedMonthData(2024, 2, uid));
        },
        expect: () => <CalendarState>[
          const CalendarState(status: BlocStatus.loading),
          CalendarState(
            status: BlocStatus.success,
            selectedMonthData: mockDaySumsList,
          ),
          const CalendarState(status: BlocStatus.loading),
          const CalendarState(status: BlocStatus.success),
        ],
        verify: (_) {
          verify(() => mockRepo.getSelectedMonthSums(2024, 1, uid)).called(1);
          verify(() => mockRepo.getSelectedMonthSums(2024, 2, uid)).called(1);
        },
      );

      blocTest<CalendarBloc, CalendarState>(
        'handles network timeout error gracefully',
        build: () {
          when(() => mockRepo.getSelectedMonthSums(2024, 1, any())).thenThrow(
            TimeoutException('Network timeout', const Duration(seconds: 30)),
          );
          return calendarBloc;
        },
        act: (bloc) => bloc.add(FetchSelectedMonthData(2024, 1, uuid.v4())),
        expect: () => <CalendarState>[
          const CalendarState(status: BlocStatus.loading),
          const CalendarState(
            status: BlocStatus.failure,
            errorMessage:
                'TimeoutException after 0:00:30.000000: Network timeout',
          ),
        ],
        verify: (_) {
          verify(() => mockRepo.getSelectedMonthSums(2024, 1, any())).called(1);
        },
      );
    });

    group('CalendarState', () {
      test('supports value equality', () {
        expect(const CalendarState(), equals(const CalendarState()));
      });

      test('props are correct', () {
        const state = CalendarState(
          status: BlocStatus.success,
          errorMessage: 'error',
        );

        expect(
          state.props,
          equals(<Object?>[BlocStatus.success, 'error', const [], const []]),
        );
      });

      test('copyWith returns object with updated values', () {
        const state = CalendarState();
        final newData = <DaySums>[
          DaySums(incomes: 1000, expenses: 500, date: DateTime(2024)),
        ];

        final updatedState = state.copyWith(
          status: BlocStatus.success,
          selectedMonthData: newData,
          errorMessage: 'test error',
        );

        expect(updatedState.status, BlocStatus.success);
        expect(updatedState.selectedMonthData, newData);
        expect(updatedState.errorMessage, 'test error');
      });

      test('copyWith retains old values when new values are not provided', () {
        const state = CalendarState(
          status: BlocStatus.success,
          errorMessage: 'original error',
        );

        final updatedState = state.copyWith(status: BlocStatus.loading);

        expect(updatedState.status, BlocStatus.loading);
        expect(updatedState.selectedMonthData, []);
        expect(updatedState.errorMessage, isNull);
      });

      test('copyWith can set errorMessage to null', () {
        const state = CalendarState(errorMessage: 'some error');
        // ignore: avoid_redundant_argument_values
        final updatedState = state.copyWith(errorMessage: null);

        expect(updatedState.errorMessage, isNull);
      });
    });

    group('CalendarEvent', () {
      test('FetchSelectedMonthData supports value equality', () {
        expect(
          FetchSelectedMonthData(2024, 1, uuid.v4()),
          equals(FetchSelectedMonthData(2024, 1, uuid.v4())),
        );
      });

      test('FetchSelectedMonthData props are correct', () {
        final event = FetchSelectedMonthData(2024, 1, uuid.v4());
        expect(event.props, [2024, 1]);
      });

      test('FetchSelectedMonthData with different values are not equal', () {
        expect(
          FetchSelectedMonthData(2024, 1, uuid.v4()),
          isNot(equals(FetchSelectedMonthData(2024, 2, uuid.v4()))),
        );
      });
    });
  });
}
