import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/utils.dart';

final List<Color> colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.brown,
  Colors.grey,
  Colors.black,
  Colors.white,
  Colors.teal,
  Colors.cyan,
  Colors.indigo,
  Colors.lime,
  Colors.amber,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.blueGrey,
];

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
      logger
        ..e('error in provider')
        ..e(err);
    }
  }

  removeCategory(String uid) async {
    final db = await createOrOpenDB();

    await db.delete('categories', where: 'uid = ?', whereArgs: [uid]);
    await loadCategories();
  }
}

final categoriesProvider = StateNotifierProvider((ref) => CategoriesNotifier());

Future<List<Map<String, dynamic>>> getPieData(String type) async {
  final List<Map<String, dynamic>> data = [];

  final db = await createOrOpenDB();

  final res = await db.query(
    'entries',
    columns: ['category', 'sum(amount) as sum'],
    groupBy: 'category',
    where: 'type = ?',
    whereArgs: [type],
    orderBy: 'sum DESC',
  );

  final total = await db.query(
    'entries',
    columns: ['sum(amount) as sum'],
    where: 'type = ?',
    whereArgs: [type],
  );

  final random = Random();

  if (res.isNotEmpty) {
    for (final item in res) {
      data.add({
        'title': item['category'] as String,
        'precentage': (item['sum'] as int) / (total[0]['sum'] as int) * 100,
        'value': item['sum'] as int,
        'color': colors[random.nextInt(colors.length)],
      });
    }
  }

  return data;
}
