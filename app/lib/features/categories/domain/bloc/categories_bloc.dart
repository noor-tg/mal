import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/data.dart';
import 'package:mal/features/categories/domain/repositories/categories_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/shared/db.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository repo;

  CategoriesBloc({required this.repo}) : super(const CategoriesState()) {
    on<AppInit>(_onLoadAll);
    on<SeedCategoriedWhenEmpty>(_onSeedCategoriesWhenEmpty);
  }

  FutureOr<void> _onLoadAll(
    CategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    final result = await repo.find();

    emit(state.copyWith(categories: result));
  }

  FutureOr<void> _onSeedCategoriesWhenEmpty(
    SeedCategoriedWhenEmpty event,
    Emitter<CategoriesState> emit,
  ) async {
    final db = await Db.use();
    final categories = await repo.find();
    if (categories.list.isEmpty) {
      await generateCategories(db);
    }
  }
}
