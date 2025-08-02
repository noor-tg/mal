import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepo;

  SearchBloc({required this.searchRepo}) : super(const SearchState()) {
    on<SimpleSearch>(_onSimpleSearch);
    on<ClearSearch>(_onClearSearch);
    on<LoadMore>(_onLoadMore);
  }

  FutureOr<void> _onSimpleSearch(
    SearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final result = await searchRepo.searchEntries(
        term: event.term,
        offset: event.offset,
      );
      if (result.count == 0) {
        return emit(
          state.copyWith(
            term: event.term,
            offset: event.offset,
            status: SearchStatus.success,
            noMoreData: true,
          ),
        );
      }
      return emit(
        state.copyWith(
          term: event.term,
          offset: event.offset,
          result: result,
          status: SearchStatus.success,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        status: SearchStatus.initial,
        result: const Result(list: [], count: 0),
        term: '',
        offset: 0,
        errorMessage: '',
      ),
    );
  }

  FutureOr<void> _onLoadMore(LoadMore event, Emitter<SearchState> emit) async {
    await _onSimpleSearch(
      SearchEvent(term: state.term, offset: state.offset + 8),
      emit,
    );
  }
}
