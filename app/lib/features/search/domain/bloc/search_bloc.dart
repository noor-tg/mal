import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/constants.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/search/domain/bloc/filters.dart';
import 'package:mal/features/search/domain/bloc/sorting.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/logger.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepo;

  SearchBloc({required this.searchRepo}) : super(SearchState()) {
    on<SetTerm>(_onSetTerm);
    on<SimpleSearch>(_onSimpleSearch);
    on<ClearSearch>(_onClearSearch);
    on<LoadMore>(_onLoadMore);
    // advanced filters
    on<ToggleCategory>(_ontoggleCategory);
    on<UpdateMinAmount>(_onUpdateMinAmount);
    on<UpdateMaxAmount>(_onUpdateMaxAmount);
    on<UpdateMinDate>(_onUpdateMinDate);
    on<UpdateMaxDate>(_onUpdateMaxDate);
    on<FilterByExpense>(_onFilterByExpense);
    on<FilterByIncome>(_onFilterByIncome);
    on<ClearFilterByType>(_onClearFilterByType);
    // sorting
    on<SortBy>(_onSortBy);
    on<ReverseSortDirection>(_onReverseSortDirection);
    // actions
    on<ApplyFilters>(_onApplyFilters);
    on<ClearFilters>(_onClearFilters);
    on<FetchEntriesCategoriesList>(_onFetchEntriesCategoriesList);
    on<FetchMaxAmount>(_onFetchMaxAmount);
    on<FetchDateBoundries>(_onFetchDateBoundries);
  }

  FutureOr<void> _onSimpleSearch(
    SimpleSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: SearchStatus.loading));

    try {
      late Result<Entry> result;
      result = await searchRepo.searchEntries(
        term: event.term,
        offset: event.offset,
        userUid: event.userUid,
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
      emit(
        state.copyWith(
          term: event.term,
          offset: event.offset,
          result: result,
          status: SearchStatus.success,
        ),
      );
    } catch (error, trace) {
      logger
        ..e(error)
        ..t(trace);
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
      late Result<Entry> result;
      if (state.simpleSearchActive) {
        result = await searchRepo.searchEntries(
          term: event.term,
          offset: event.offset,
          userUid: event.userUid,
        );
      } else {
        result = await searchRepo.advancedSearch(state, event.userUid);
      }
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
      emit(
        state.copyWith(
          term: event.term,
          offset: offset,
          result: Result(
            list: [...state.result.list, ...result.list],
            count: result.count,
          ),
          status: SearchStatus.success,
        ),
      );
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

    emit(
      state.copyWith(
        filters: Filters.withCurrentYear(categories: currentCategories),
      ),
    );
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

  FutureOr<void> _onUpdateMinDate(
    UpdateMinDate event,
    Emitter<SearchState> emit,
  ) {
    DateTime currentMax = state.filters.dateRange.max;

    if (event.dateValue.isAfter(currentMax)) {
      currentMax = event.dateValue;
    }

    emit(
      state.copyWith(
        filters: state.filters.copyWith(
          dateRange: Range(min: event.dateValue, max: currentMax),
        ),
      ),
    );
  }

  FutureOr<void> _onUpdateMaxDate(
    UpdateMaxDate event,
    Emitter<SearchState> emit,
  ) {
    DateTime currentMin = state.filters.dateRange.min;

    if (currentMin.isAfter(event.dateValue)) {
      currentMin = event.dateValue;
    }

    emit(
      state.copyWith(
        filters: state.filters.copyWith(
          dateRange: Range(min: currentMin, max: event.dateValue),
        ),
      ),
    );
  }

  FutureOr<void> _onFilterByExpense(
    FilterByExpense event,
    Emitter<SearchState> emit,
  ) {
    emit(
      state.copyWith(filters: state.filters.copyWith(type: EntryType.expense)),
    );
  }

  FutureOr<void> _onFilterByIncome(
    FilterByIncome event,
    Emitter<SearchState> emit,
  ) {
    emit(
      state.copyWith(filters: state.filters.copyWith(type: EntryType.income)),
    );
  }

  FutureOr<void> _onClearFilterByType(
    ClearFilterByType event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(filters: state.filters.copyWith(type: EntryType.all)));
  }

  FutureOr<void> _onSortBy(SortBy event, Emitter<SearchState> emit) {
    if (state.sorting.field == event.field) {
      emit(
        state.copyWith(
          sorting: state.sorting.copyWith(
            direction: state.sorting.direction == SortingDirection.asc
                ? SortingDirection.desc
                : SortingDirection.asc,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          sorting: state.sorting.copyWith(
            field: event.field,
            direction: event.direction,
          ),
        ),
      );
    }
  }

  FutureOr<void> _onReverseSortDirection(
    ReverseSortDirection event,
    Emitter<SearchState> emit,
  ) {
    emit(
      state.copyWith(
        sorting: state.sorting.copyWith(
          direction: state.sorting.direction == SortingDirection.asc
              ? SortingDirection.desc
              : SortingDirection.asc,
        ),
      ),
    );
  }

  FutureOr<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final result = await searchRepo.advancedSearch(state, event.userUid);
      emit(state.copyWith(result: result, status: SearchStatus.success));
    } catch (err) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: err.toString(),
        ),
      );
      logger.t(err);
    }
  }

  FutureOr<void> _onClearFilters(
    ClearFilters event,
    Emitter<SearchState> emit,
  ) {
    emit(
      state.copyWith(
        status: SearchStatus.initial,
        sorting: const Sorting(),
        result: const Result(list: [], count: 0),
        offset: 0,
        filters: state.filters.copyWith(
          categories: [],
          amountRange: Range(min: 0, max: state.maxAmount),
          dateRange: state.dateRange, // Use actual DB boundaries!
          type: EntryType.all,
        ),
      ),
    );
  }

  FutureOr<void> _onSetTerm(SetTerm event, Emitter<SearchState> emit) {
    emit(state.copyWith(term: event.term));
  }

  FutureOr<void> _onFetchEntriesCategoriesList(
    FetchEntriesCategoriesList event,
    Emitter<SearchState> emit,
  ) async {
    try {
      // get list
      final categories = await searchRepo.fetchCategories();
      // set to search state
      emit(state.copyWith(categories: categories));
    } catch (e, t) {
      logger
        ..e(e)
        ..t(t);
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onFetchMaxAmount(
    FetchMaxAmount event,
    Emitter<SearchState> emit,
  ) async {
    try {
      // get list
      final maxAmount = await searchRepo.fetchMaxAmount();
      // set to search state
      emit(state.copyWith(maxAmount: maxAmount));
    } catch (e, t) {
      logger
        ..e(e)
        ..t(t);
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onFetchDateBoundries(
    FetchDateBoundries event,
    Emitter<SearchState> emit,
  ) async {
    try {
      // get list
      final Range<DateTime> range = await searchRepo.fetchDateBoundries();
      // set to search state
      emit(
        state.copyWith(
          dateRange: range,
          filters: state.filters.copyWith(dateRange: range),
        ),
      );
    } catch (e, t) {
      logger
        ..e(e)
        ..t(t);
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
