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
