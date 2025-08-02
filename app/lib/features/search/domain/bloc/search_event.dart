part of 'search_bloc.dart';

class SearchEvent extends Equatable {
  const SearchEvent({String? term, int? offset})
    : offset = offset ?? 0,
      term = term ?? '';

  final String term;
  final int offset;

  @override
  List<Object> get props => [offset, term];
}
