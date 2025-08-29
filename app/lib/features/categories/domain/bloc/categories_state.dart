part of 'categories_bloc.dart';

class CategoriesState extends Equatable {
  const CategoriesState({
    this.errorMessage,
    this.status = BlocStatus.initial,
    Result<Category>? categories,
  }) : categories = categories ?? const Result(list: [], count: 0);

  final Result<Category> categories;

  final BlocStatus status;

  final String? errorMessage;

  List<Category> get expenses =>
      categories.list.where((cat) => cat.type == expenseType).toList();

  List<Category> get income =>
      categories.list.where((cat) => cat.type == incomeType).toList();

  @override
  List<Object?> get props => [categories, status, errorMessage];

  CategoriesState copyWith({
    Result<Category>? categories,
    BlocStatus? status,
    String? errorMessage,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
