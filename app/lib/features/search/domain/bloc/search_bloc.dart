import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/constants.dart';
import 'package:mal/features/search/domain/bloc/filters.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/utils.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepo;

  SearchBloc({required this.searchRepo}) : super(const SearchState()) {
    on<SimpleSearch>(_onSimpleSearch);
    on<ClearSearch>(_onClearSearch);
    on<LoadMore>(_onLoadMore);
    on<ToggleCategory>(_ontoggleCategory);
    on<UpdateMinAmount>(_onUpdateMinAmount);
    on<UpdateMaxAmount>(_onUpdateMaxAmount);
  }

  FutureOr<void> _onSimpleSearch(
    SearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: SearchStatus.loading));
    await searchRoutine(event, emit, (result) {
      emit(
        state.copyWith(
          term: event.term,
          offset: event.offset,
          result: result,
          status: SearchStatus.success,
        ),
      );
    });
  }

  FutureOr<void> searchRoutine(
    SearchEvent event,
    Emitter<SearchState> emit,
    Function(Result<Entry> result) handleResult,
  ) async {
    try {
      final result = await searchRepo.searchEntries(
        term: event.term,
        offset: event.offset,
      );
      if (result.list.isEmpty) {
        return emit(
          state.copyWith(
            term: event.term,
            offset: event.offset > 0 ? event.offset - kSearchLimit : 0,
            status: SearchStatus.success,
            noMoreData: true,
          ),
        );
      }
      handleResult(result);
    } catch (error) {
      logger.t(error);
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

  Future<void> _onLoadMore(LoadMore event, Emitter<SearchState> emit) async {
    final offset = state.offset + kSearchLimit;
    try {
      await searchRoutine(SearchEvent(term: state.term, offset: offset), emit, (
        result,
      ) {
        emit(
          state.copyWith(
            term: state.term,
            offset: offset,
            result: Result(
              list: [...state.result.list, ...result.list],
              count: state.result.count,
            ),
            status: SearchStatus.success,
          ),
        );
      });
    } catch (err) {
      logger.e(err);
    }
  }

  FutureOr<void> _ontoggleCategory(
    ToggleCategory event,
    Emitter<SearchState> emit,
  ) async {
    // get current list filter categories
    final currentCategories = List<String>.from(state.filters.categories);

    if (currentCategories.contains(event.category)) {
      currentCategories.remove(event.category);
    } else {
      currentCategories.add(event.category);
    }

    emit(state.copyWith(filters: Filters(categories: currentCategories)));
  }

  FutureOr<void> _onUpdateMinAmount(
    UpdateMinAmount event,
    Emitter<SearchState> emit,
  ) {
    int currentMax = state.filters.amountRange.max;

    if (event.amountValue > currentMax) {
      currentMax = event.amountValue;
    }

    emit(
      state.copyWith(
        filters: state.filters.copyWith(
          amountRange: Range(min: event.amountValue, max: currentMax),
        ),
      ),
    );
  }

  FutureOr<void> _onUpdateMaxAmount(
    UpdateMaxAmount event,
    Emitter<SearchState> emit,
  ) {
    int currentMin = state.filters.amountRange.min;

    if (currentMin > event.amountValue) {
      currentMin = event.amountValue;
    }

    emit(
      state.copyWith(
        filters: state.filters.copyWith(
          amountRange: Range(min: currentMin, max: event.amountValue),
        ),
      ),
    );
  }
}
