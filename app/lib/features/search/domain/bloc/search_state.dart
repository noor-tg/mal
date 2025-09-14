part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  SearchState({
    Result<Entry>? result,
    this.term = '',
    this.offset = 0,
    this.status = SearchStatus.initial,
    this.noMoreData = false,
    this.errorMessage = '',
    Filters? filters,
    Sorting? sorting,
  }) : result = result ?? const Result<Entry>(list: [], count: 0),
       filters = filters ?? Filters.withCurrentYear(),
       sorting = sorting ?? const Sorting();

  // different states
  final SearchStatus status;
  final Sorting sorting;

  // all of these are defaults . so if currnt values equal it . there is no active advanced search
  bool get simpleSearchActive =>
      filters.categories.isNotEmpty &&
      filters.amountRange.min == 0 &&
      filters.amountRange.max == 0 &&
      // first day of year
      filters.dateRange.min.difference(DateTime(DateTime.now().year)).inDays ==
          0 &&
      filters.dateRange.max.difference(DateTime.now()).inDays == 0 &&
      filters.type == EntryType.all &&
      sorting.field == SortingField.date &&
      sorting.direction == SortingDirection.desc;

  // always exist
  final String term;
  final int offset;
  final Result<Entry> result;

  // changed when no more data fetched from repo
  final bool noMoreData;

  // not empty when status is failure
  final String errorMessage;

  final Filters filters;

  @override
  List<Object> get props => [
    term,
    offset,
    result,
    status,
    noMoreData,
    errorMessage,
    filters,
    sorting,
  ];

  SearchState copyWith({
    String? term,
    int? offset,
    Result<Entry>? result,
    SearchStatus? status,
    bool? noMoreData,
    String? errorMessage,
    Filters? filters,
    Sorting? sorting,
  }) {
    return SearchState(
      term: term ?? this.term,
      offset: offset ?? this.offset,
      status: status ?? this.status,
      result: result ?? this.result,
      noMoreData: noMoreData ?? this.noMoreData,
      errorMessage: errorMessage ?? this.errorMessage,
      filters: filters ?? this.filters,
      sorting: sorting ?? this.sorting,
    );
  }

  @override
  String toString() {
    return 'SearchState('
        'term: $term, \n'
        'offset: $offset, \n'
        'status: $status, \n'
        'result: ${result.list.length} entries (count: ${result.count}), \n'
        'noMoreData: $noMoreData, \n'
        'errorMessage: $errorMessage, \n'
        'filters: $filters, \n'
        'sorting: $sorting, \n'
        'simpleSearchActive: $simpleSearchActive \n'
        ')';
  }
}
