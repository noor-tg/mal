import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/models/category.dart';
import 'package:mal/utils.dart';

class CategoriesNotifier extends StateNotifier<List<Category>> {
  CategoriesNotifier() : super([]);

  void addCategory(String title, String type) async {
    final category = Category(title: title, type: type);

    final db = await createOrOpenDB();

    await db.insert('categories', {
      'uid': category.uid,
      'title': category.title,
      'type': category.type,
    });

    state = [category, ...state];
  }

  Future<void> loadCategories() async {
    final db = await createOrOpenDB();
    final data = await db.query('categories');

    state = data
        .map(
          (row) => Category(
            uid: row['uid'] as String,
            title: row['title'] as String,
            type: row['type'] as String,
          ),
        )
        .toList();
  }
}

final categoriesProvider = StateNotifierProvider((ref) => CategoriesNotifier());
