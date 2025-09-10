import 'dart:math';

import 'package:faker/faker.dart';
import 'package:mal/constants.dart';
import 'package:mal/features/user/data/repositories/sql_repository.dart'
    as user;
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/shared/data/models/user.dart';
import 'package:mal/shared/db.dart';
import 'package:mal/utils.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite_common/sqlite_api.dart';

final random = RandomGenerator(seed: 63833423);
final faker = Faker.withGenerator(random);

final categories = [
  Category(title: 'طعام', type: expenseType),
  Category(title: 'ملابس', type: expenseType),
  Category(title: 'خدمات', type: expenseType),
  Category(title: 'أخرى', type: expenseType),
];

Future<void> generateData() async {
  final db = await createOrOpenDB();
  await generateCategories(db);
  await generateEntries(db);
}

Future<void> generateEntries(Database db) async {
  final List<Entry> entries = [];
  await db.delete('entries');
  for (int i = 0; i < 200; i++) {
    entries.add(fakeEntry());
  }
  for (final entry in entries) {
    await db.insert('entries', entry.toMap());
  }
}

Entry fakeEntry({String? userUid}) {
  final random = Random();
  return Entry(
    userUid: userUid ?? uuid.v4(),
    description: faker.lorem.sentence(),
    amount: Random().nextInt(1000),
    category: categories[Random().nextInt(categories.length - 1)].title,
    type: types[Random().nextInt(types.length)],
    date: DateTime(
      [2024, 2025][random.nextInt(2)],
      7,
      random.nextInt(30),
      random.nextInt(24),
      random.nextInt(60),
      random.nextInt(60),
    ).toIso8601String(),
  );
}

Map<String, String> fakeUser() {
  return {
    'name': faker.internet.userName(),
    'pin': faker.internet.macAddress(),
    'salt': faker.internet.macAddress(),
  };
}

Future<User?> fakeStoredUser() async {
  final data = fakeUser();
  final repo = user.SqlRepository();

  await repo.register(name: data['name'] as String, pin: '1234');
  return repo.getUserByName(data['name'] as String);
}

Future<void> generateCategories(Database db) async {
  await db.delete('categories');
  for (final category in categories) {
    await db.insert('categories', {
      'uid': category.uid,
      'title': category.title,
      'type': category.type,
    });
  }
}

Category fakeCategory() {
  return Category(
    title: faker.lorem.sentence(),
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
