import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/constants.dart';
import 'package:mal/data.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/categories/domain/repositories/categories_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/shared/db.dart';
import 'package:mal/utils.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository repo;

  CategoriesBloc({required this.repo}) : super(const CategoriesState()) {
    on<AppInit>(_onLoadAll);
    on<SeedCategoriedWhenEmpty>(_onSeedCategoriesWhenEmpty);
    on<StoreCategory>(_onStoreCategory);
    on<RemoveCategory>(_onRemoveCategory);
  }

  FutureOr<void> _onLoadAll(
    CategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    final result = await repo.find(userUid: event.userUid);

    emit(state.copyWith(categories: result));
  }

  FutureOr<void> _onSeedCategoriesWhenEmpty(
    SeedCategoriedWhenEmpty event,
    Emitter<CategoriesState> emit,
  ) async {
    final db = await Db.use();
    final categories = await repo.find(userUid: event.userUid);
    if (categories.list.isEmpty) {
      await generateCategories(db, event.userUid);
    }
  }

  Future<void> _onStoreCategory(
    StoreCategory event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      await repo.store(event.category);

      emit(state.copyWith(status: BlocStatus.success));

      add(AppInit(event.category.userUid));
    } catch (err, trace) {
      logger
        ..e(err)
        ..t(trace);
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          errorMessage: err.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onRemoveCategory(
    RemoveCategory event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      await repo.remove(event.uid);

      emit(state.copyWith(status: BlocStatus.success));

      add(AppInit(event.userUid));
    } catch (err, trace) {
      logger
        ..e(err)
        ..t(trace);
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          errorMessage: err.toString(),
        ),
      );
    }
  }
}
