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

class SimpleSearch extends SearchEvent {
  const SimpleSearch({super.term, super.offset});
}

class SetTerm extends SearchEvent {
  const SetTerm({super.term});
}

class ClearSearch extends SearchEvent {}

class LoadMore extends SearchEvent {}

class ToggleCategory extends SearchEvent {
  const ToggleCategory({required this.category});

  final String category;
}

class UpdateMinAmount extends SearchEvent {
  const UpdateMinAmount(this.amountValue);

  final int amountValue;
}

class UpdateMaxAmount extends SearchEvent {
  const UpdateMaxAmount(this.amountValue);

  final int amountValue;
}

class UpdateMinDate extends SearchEvent {
  const UpdateMinDate(this.dateValue);

  final DateTime dateValue;
}

class UpdateMaxDate extends SearchEvent {
  const UpdateMaxDate(this.dateValue);

  final DateTime dateValue;
}

class FilterByExpense extends SearchEvent {}

class FilterByIncome extends SearchEvent {}

class ClearFilterByType extends SearchEvent {}

class SortBy extends SearchEvent {
  const SortBy({
    super.term,
    super.offset,
    required this.field,
    this.direction = SortingDirection.asc,
  });

  final SortingField field;
  final SortingDirection direction;
}

class ReverseSortDirection extends SearchEvent {}

class ApplyFilters extends SearchEvent {}

class ClearFilters extends SearchEvent {}
