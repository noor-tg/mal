part of 'categories_bloc.dart';

sealed class CategoriesEvent extends Equatable {
  final String userUid;

  const CategoriesEvent(this.userUid);

  @override
  List<Object> get props => [userUid];
}

class AppInit extends CategoriesEvent {
  const AppInit(super.userUid);
}

class SeedCategoriedWhenEmpty extends CategoriesEvent {
  const SeedCategoriedWhenEmpty(super.userUid);
}

class StoreCategory extends CategoriesEvent {
  final Category category;
  StoreCategory(this.category) : super(category.userUid);
}

class RemoveCategory extends CategoriesEvent {
  final String uid;
  const RemoveCategory(this.uid) : super('');
}
