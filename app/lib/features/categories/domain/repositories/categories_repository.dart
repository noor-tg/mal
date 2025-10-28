import 'package:mal/result.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/shared/where.dart';

abstract class CategoriesRepository {
  Future<Result<Category>> find({
    List<Where> whereList = const [],
    required String userUid,
  });
}
