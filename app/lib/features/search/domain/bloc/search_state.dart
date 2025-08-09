part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    Result<Entry>? result,
    this.term = '',
    this.offset = 0,
    this.status = SearchStatus.initial,
    this.noMoreData = false,
    this.errorMessage = '',
    Filters? filters,
  }) : result = result ?? const Result<Entry>(list: [], count: 0),
       filters = filters ?? const Filters();

  // different states
  final SearchStatus status;

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
  ];

  SearchState copyWith({
    String? term,
    int? offset,
    Result<Entry>? result,
    SearchStatus? status,
    bool? noMoreData,
    String? errorMessage,
    Filters? filters,
  }) {
    return SearchState(
      term: term ?? this.term,
      offset: offset ?? this.offset,
      status: status ?? this.status,
      result: result ?? this.result,
      noMoreData: noMoreData ?? this.noMoreData,
      errorMessage: errorMessage ?? this.errorMessage,
      filters: filters ?? this.filters,
    );
  }
}
