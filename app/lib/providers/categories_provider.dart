import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/models/category.dart';
import 'package:mal/utils.dart';

class CategoriesNotifier extends StateNotifier<Map<String, List<Category>>> {
  CategoriesNotifier() : super({'income': [], 'expenses': []});

  void addCategory(String title, String type) async {
    final category = Category(title: title, type: type);

    final db = await createOrOpenDB();

    await db.insert('categories', {
      'uid': category.uid,
      'title': category.title,
      'type': category.type,
    });

    await loadCategories();
    // state = [category, ...state];
  }

  Future<void> loadCategories() async {
    try {
      final db = await createOrOpenDB();

      final incomeCategories = await db.query(
        'categories',
        where: 'type = ?',
        whereArgs: ['دخل'],
      );

      final expensesCategories = await db.query(
        'categories',
        where: 'type = ?',
        whereArgs: ['منصرف'],
      );

      state = {
        'income': incomeCategories
            .map(
              (row) => Category(
                uid: row['uid'] as String,
                title: row['title'] as String,
                type: row['type'] as String,
              ),
            )
            .toList(),
        'expenses': expensesCategories
            .map(
              (row) => Category(
                uid: row['uid'] as String,
                title: row['title'] as String,
                type: row['type'] as String,
              ),
            )
            .toList(),
      };
    } catch (err) {
      print('error in provider');
      print(err);
    }
  }

  removeCategory(String uid) async {
    final db = await createOrOpenDB();

    await db.delete('categories', where: 'uid = ?', whereArgs: [uid]);
    await loadCategories();
  }
}

final categoriesProvider = StateNotifierProvider((ref) => CategoriesNotifier());
