import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/features/entries/domain/repositories/entries_repository.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/utils.dart';

part 'entries_event.dart';
part 'entries_state.dart';

class EntriesBloc extends Bloc<EntriesEvent, EntriesState> {
  late EntriesRepository repo;

  EntriesBloc({required this.repo}) : super(const EntriesState()) {
    on<StoreEntry>(_onStoreEntry);
    on<EditEntry>(_onEditEntry);
    on<RemoveEntry>(_onRemoveEntry);
    on<LoadTodayEntries>(_onLoadToday);
  }

  Future<void> _onStoreEntry(
    StoreEntry event,
    Emitter<EntriesState> emit,
  ) async {
    emit(
      state.copyWith(status: EntriesStatus.loading, currentEntry: event.entry),
    );
    try {
      final stored = await repo.store(state.currentEntry!);
      final today = DateTime.now().toIso8601String().substring(0, 10);
      emit(
        state.copyWith(
          status: EntriesStatus.success,
          // ignore: avoid_redundant_argument_values
          currentEntry: null,
        ),
      );
      if (stored.date.contains(today)) {
        add(LoadTodayEntries());
      }
    } catch (err, trace) {
      logger
        ..e(err)
        ..t(trace);
      emit(
        state.copyWith(
          status: EntriesStatus.failure,
          errorMessage: err.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadToday(
    LoadTodayEntries event,
    Emitter<EntriesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EntriesStatus.loading));

      final result = await repo.today();

      emit(state.copyWith(today: result.list, status: EntriesStatus.success));
    } catch (err, trace) {
      logger
        ..e(err)
        ..t(trace);
      emit(
        state.copyWith(
          status: EntriesStatus.failure,
          errorMessage: err.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onEditEntry(
    EditEntry event,
    Emitter<EntriesState> emit,
  ) async {
    emit(state.copyWith(status: EntriesStatus.loading));
    try {
      final stored = await repo.edit(event.entry);
      final today = DateTime.now().toIso8601String().substring(0, 10);
      emit(
        state.copyWith(
          status: EntriesStatus.success,
          // ignore: avoid_redundant_argument_values
          currentEntry: null,
        ),
      );
      if (stored.date.contains(today)) {
        add(LoadTodayEntries());
      }
    } catch (err, trace) {
      logger
        ..e(err)
        ..t(trace);
      emit(
        state.copyWith(
          status: EntriesStatus.failure,
          errorMessage: err.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onRemoveEntry(
    RemoveEntry event,
    Emitter<EntriesState> emit,
  ) async {
    emit(state.copyWith(status: EntriesStatus.loading));
    try {
      await repo.remove(event.entry.uid);
      final today = DateTime.now().toIso8601String().substring(0, 10);
      emit(
        state.copyWith(
          status: EntriesStatus.success,
          // ignore: avoid_redundant_argument_values
          currentEntry: null,
        ),
      );
      if (event.entry.date.contains(today)) {
        add(LoadTodayEntries());
      }
    } catch (err, trace) {
      logger
        ..e(err)
        ..t(trace);
      emit(
        state.copyWith(
          status: EntriesStatus.failure,
          errorMessage: err.toString(),
        ),
      );
    }
  }
}
