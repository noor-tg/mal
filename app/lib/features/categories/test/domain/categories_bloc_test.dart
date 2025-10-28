// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/domain/repositories/categories_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

class MockRepo extends Mock implements CategoriesRepository {}

void main() {
  group('$CategoriesBloc >', () {
    addNewCategoryTest();
    removeCategoryTest();
  });
}

void removeCategoryTest() {
  setUpAll(() {
    registerFallbackValue(MockRepo());
    registerFallbackValue(fakeCategory());
  });
}

void addNewCategoryTest() {
  final category = fakeCategory();
  final userUid = category.userUid;
  setUpAll(() {
    registerFallbackValue(MockRepo());
    registerFallbackValue(category);
    registerFallbackValue(userUid);
  });
}
