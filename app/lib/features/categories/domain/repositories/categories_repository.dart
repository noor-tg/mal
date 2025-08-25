import 'package:mal/result.dart';
import 'package:mal/shared/data/models/category.dart';

abstract class CategoriesRepository {
  Future<Result<Category>> find({String? where, List<dynamic>? whereArgs});
  Future<Category> store(Category category);
  Future<void> remove(String uid);
}
