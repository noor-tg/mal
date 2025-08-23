import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/features/entries/domain/repositories/entries_repository.dart';
import 'package:mal/shared/data/models/entry.dart';

part 'entries_event.dart';
part 'entries_state.dart';

class EntriesBloc extends Bloc<EntriesEvent, EntriesState> {
  late EntriesRepository repo;

  EntriesBloc({required this.repo}) : super(const EntriesState()) {
    on<StoreEntry>(_onStoreEntry);
    on<LoadAll>(_onLoadAll);
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
      emit(
        state.copyWith(
          status: EntriesStatus.success,
          all: [stored, ...state.all],
          // ignore: avoid_redundant_argument_values
          currentEntry: null,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          status: EntriesStatus.failure,
          errorMessage: err.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadAll(LoadAll event, Emitter<EntriesState> emit) async {
    emit(state.copyWith(status: EntriesStatus.loading));

    final result = await repo.find();

    emit(state.copyWith(all: result.list, status: EntriesStatus.success));
  }
}
