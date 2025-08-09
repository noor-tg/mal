part of 'categories_bloc.dart';

class CategoriesState extends Equatable {
  const CategoriesState({Result<Category>? categories})
    : categories = categories ?? const Result(list: [], count: 0);

  final Result<Category> categories;

  @override
  List<Object> get props => [categories];

  CategoriesState copyWith({Result<Category>? categories}) {
    return CategoriesState(categories: categories ?? this.categories);
  }
}
