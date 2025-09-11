import 'package:mal/features/categories/data/sources/sql_provider.dart';
import 'package:mal/features/categories/domain/repositories/categories_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/shared/where.dart';

class SqlRepository extends CategoriesRepository {
  SqlProvider sqlProvider = SqlProvider();

  @override
  Future<Result<Category>> find({
    List<Where> whereList = const [],
    required String userUid,
  }) async {
    final list = await sqlProvider.queryList(
      whereList: whereList,
      userUid: userUid,
    );

    final count = await sqlProvider.queryCount(
      whereList: whereList,
      userUid: userUid,
    );

    final data = List.generate(list.length, (i) => Category.fromMap(list[i]));

    return Result(list: data, count: count);
  }

  @override
  Future<Category> store(Category category) async {
    try {
      final result = await find(
        whereList: [
          Where(field: 'title', oprand: '=', value: category.title),
          Where(field: 'type', oprand: '=', value: category.type),
        ],
        userUid: category.userUid,
      );

      if (result.list.isEmpty) {
        await sqlProvider.store(category.toMap());
      }

      return category;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> remove(String uid) async {
    try {
      await sqlProvider.remove(uid);
    } catch (err) {
      rethrow;
    }
  }
}
