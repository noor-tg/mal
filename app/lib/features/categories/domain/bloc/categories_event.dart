part of 'categories_bloc.dart';

sealed class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

class AppInit extends CategoriesEvent {}

class SeedCategoriedWhenEmpty extends CategoriesEvent {}

class StoreCategory extends CategoriesEvent {
  final Category category;
  const StoreCategory(this.category);
}

class RemoveCategory extends CategoriesEvent {
  final String uid;
  const RemoveCategory(this.uid);
}
