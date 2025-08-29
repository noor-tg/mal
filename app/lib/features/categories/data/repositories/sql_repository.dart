import 'package:mal/features/categories/data/sources/sql_provider.dart';
import 'package:mal/features/categories/domain/repositories/categories_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/category.dart';

class SqlRepository extends CategoriesRepository {
  SqlProvider sqlProvider = SqlProvider();

  @override
  Future<Result<Category>> find({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final list = await sqlProvider.queryList(
      where: where,
      whereArgs: whereArgs,
    );

    final count = await sqlProvider.queryCount(
      where: where,
      whereArgs: whereArgs,
    );

    final data = List.generate(list.length, (i) => Category.fromMap(list[i]));

    return Result(list: data, count: count);
  }

  @override
  Future<Category> store(Category category) async {
    try {
      final result = await find(
        where: 'title = ? AND type = ?',
        whereArgs: [category.title, category.type],
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
