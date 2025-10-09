import 'dart:math';

import 'package:mal/constants.dart';
import 'package:mal/features/user/data/repositories/sql_repository.dart'
    as user;
import 'package:mal/l10n/app_localizations_ar.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/shared/data/models/user.dart';
import 'package:mal/shared/db.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/logger.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite_common/sqlite_api.dart';

final categories = [
  {'title': 'طعام', 'type': expenseType},
  {'title': 'ملابس', 'type': expenseType},
  {'title': 'خدمات', 'type': expenseType},
  {'title': 'أخرى', 'type': expenseType},
  {'title': 'مرتب', 'type': incomeType},
  {'title': 'عمل حر', 'type': incomeType},
  {'title': 'بيع منتج', 'type': incomeType},
  {'title': 'تنفيذ خدمة', 'type': incomeType},
  {'title': 'أخرى', 'type': incomeType},
];

Future<void> generateData() async {
  final db = await createOrOpenDB();
  final user = await fakeStoredUser();
  await generateCategories(db, user.uid);
  await generateEntries(db, user.uid);
}

Future<void> generateEntries(Database db, String userUid) async {
  final List<Entry> entries = [];
  await db.delete('entries');
  for (int i = 0; i < 200; i++) {
    entries.add(fakeEntry(userUid: userUid));
  }
  for (final entry in entries) {
    await db.insert('entries', entry.toMap());
  }
}

String sentence() {
  final lorem = AppLocalizationsAr().lorem_ipsum;
  final randomStart = Random().nextInt(lorem.length - 21);
  return lorem.substring(randomStart, randomStart + Random().nextInt(20));
}

Entry fakeEntry({String? userUid}) {
  final random = Random();
  final category = categories[Random().nextInt(categories.length - 1)];
  return Entry(
    userUid: userUid ?? uuid.v4(),
    description: sentence(),
    amount: Random().nextInt(1000),
    category: category['title'] as String,
    type: category['type'] as String,
    date: DateTime(
      2025,
      [10, 9, 8, 7, 6, 5][Random().nextInt(6)],
      random.nextInt(30),
      random.nextInt(24),
      random.nextInt(60),
      random.nextInt(60),
    ).toIso8601String(),
  );
}

Map<String, String> fakeUser() {
  final names = ['محمد', 'احمد', 'ابوبكر', 'عمر', 'عثمان', 'علي'];
  return {
    'name': names[Random().nextInt(names.length - 1)],
    'pin': '1234',
    'salt': '12234135324234324234',
  };
}

Future<User> fakeStoredUser() async {
  final data = fakeUser();
  final repo = user.SqlRepository();

  logger.i(data);
  await repo.register(name: data['name'] as String, pin: '1234');
  return (await repo.getUserByName(data['name'] as String))!;
}

Future<void> generateCategories(Database db, String userUid) async {
  await db.delete('categories');
  for (final category in categories) {
    await db.insert('categories', {
      'uid': uuid.v4(),
      'title': category['title'],
      'type': category['type'],
      'user_uid': userUid,
    });
  }
}

Category fakeCategory({String? userUid}) {
  return Category(
    userUid: userUid ?? uuid.v4(),
    title: sentence(),
    type: types[Random().nextInt(types.length)],
  );
}

Future<void> clearCategories() async {
  final db = await Db.use();
  await db.delete('categories');
}

Future<void> generateTodayEntry() async {
  var entry = fakeEntry();
  entry = entry.copyWith(date: DateTime.now().toIso8601String());
  final db = await Db.use();
  await db.insert('entries', entry.toMap());
}
