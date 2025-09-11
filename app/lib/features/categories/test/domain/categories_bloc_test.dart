// ignore: depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/domain/repositories/categories_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/category.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

class MockRepo extends Mock implements CategoriesRepository {}

void main() {
  // ignore: unnecessary_lambdas
  group('$CategoriesBloc >', () {
    addNewCategoryTest();
    removeCategoryTest();
  });
}

void removeCategoryTest() {
  final category = fakeCategory();
  final repo = MockRepo();
  setUpAll(() {
    registerFallbackValue(MockRepo());
    registerFallbackValue(fakeCategory());
  });

  blocTest<CategoriesBloc, CategoriesState>(
    'when send RemoveCategory event. category should be removed from categories state',
    build: () => CategoriesBloc(repo: repo),
    setUp: () {
      // Mock the repository store method to succeed
      when(() => repo.remove(any())).thenAnswer((_) {
        return Future.value();
      });
      when(() => repo.find(userUid: any(named: 'userUid'))).thenAnswer((
        _,
      ) async {
        return const Result<Category>(list: [], count: 0);
      });
    },
    act: (bloc) => bloc.add(RemoveCategory(category.uid)),
    expect: () => [
      const CategoriesState(status: BlocStatus.loading),
      const CategoriesState(
        status: BlocStatus.success,
        categories: Result(list: [], count: 0),
      ),
    ],
    verify: (bloc) {
      verify(() => repo.remove(category.uid)).called(1);
    },
  );
}

void addNewCategoryTest() {
  final category = fakeCategory();
  final repo = MockRepo();
  final userUid = category.userUid;
  setUpAll(() {
    registerFallbackValue(MockRepo());
    registerFallbackValue(category);
    registerFallbackValue(userUid);
  });

  blocTest<CategoriesBloc, CategoriesState>(
    'when send StoreCategory event. category should be added to categories state',
    build: () => CategoriesBloc(repo: repo),
    setUp: () {
      // Mock the repository store method to succeed
      when(() => repo.store(any())).thenAnswer((_) async {
        return category;
      });
      when(() => repo.find(userUid: any(named: 'userUid'))).thenAnswer((
        _,
      ) async {
        return Result<Category>(list: [category], count: 1);
      });
    },
    act: (bloc) => bloc.add(StoreCategory(category)),
    expect: () => [
      const CategoriesState(status: BlocStatus.loading),
      const CategoriesState(status: BlocStatus.success),
      CategoriesState(
        status: BlocStatus.success,
        categories: Result(list: [category], count: 1),
      ),
    ],
    verify: (bloc) {
      verify(() => repo.store(any())).called(1);
    },
  );
}
