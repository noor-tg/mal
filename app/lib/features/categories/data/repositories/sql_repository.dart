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

    final count = list.length;

    final data = List.generate(
      list.length,
      (i) => Category.fromMap({
        'title': list[i]['category'] as String,
        'type': list[i]['type'] as String,
        'user_uid': list[i]['user_uid'] as String,
      }),
    );

    return Result(list: data, count: count);
  }
}
