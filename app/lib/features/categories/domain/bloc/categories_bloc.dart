import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/features/categories/domain/repositories/categories_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/category.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository repo;

  CategoriesBloc({required this.repo}) : super(const CategoriesState()) {
    on<AppInit>(_onLoadAll);
  }

  FutureOr<void> _onLoadAll(
    CategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    final result = await repo.find();

    emit(state.copyWith(categories: result));
  }
}
