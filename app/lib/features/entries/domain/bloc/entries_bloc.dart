import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/features/entries/domain/repositories/entries_repository.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/utils/logger.dart';

part 'entries_event.dart';
part 'entries_state.dart';

class EntriesBloc extends Bloc<EntriesEvent, EntriesState> {
  late EntriesRepository repo;

  EntriesBloc({required this.repo}) : super(const EntriesState()) {
    on<StoreEntry>(_onStoreEntry);
    on<EditEntry>(_onEditEntry);
    on<RemoveEntry>(_onRemoveEntry);
    on<LoadTodayEntries>(_onLoadToday);
    on<LoadCategoryEntries>(_onLoadCategoryEntries);
  }

  Future<void> _onStoreEntry(
    StoreEntry event,
    Emitter<EntriesState> emit,
  ) async {
    emit(state.copyWith(status: EntriesStatus.loading));
    try {
      await repo.store(event.entry);
      emit(
        state.copyWith(
          operationType: OperationType.create,
          status: EntriesStatus.success,
        ),
      );
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

      final result = await repo.today(event.userUid);

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
      await repo.edit(event.entry);
      emit(
        state.copyWith(
          operationType: OperationType.update,
          status: EntriesStatus.success,
        ),
      );
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
      emit(
        state.copyWith(
          operationType: OperationType.remove,
          status: EntriesStatus.success,
        ),
      );
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

  Future<void> _onLoadCategoryEntries(
    LoadCategoryEntries event,
    Emitter<EntriesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EntriesStatus.loading));

      final result = await repo.byCategory(event.userUid, event.category);

      emit(
        state.copyWith(
          currentCategory: result.list,
          status: EntriesStatus.success,
        ),
      );
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
