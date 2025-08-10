import 'dart:math';

import 'package:faker/faker.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/utils.dart';

final random = RandomGenerator(seed: 63833423);
final faker = Faker.withGenerator(random);

final types = ['دخل', 'منصرف'];

final categories = [
  Category(title: 'طعام', type: types[0]),
  Category(title: 'ملابس', type: types[0]),
  Category(title: 'خدمات', type: types[0]),
  Category(title: 'أخرى', type: types[0]),
];

List<Entry> entries = [];

Future<void> generateData() async {
  final db = await createOrOpenDB();
  await db.delete('categories');
  await db.delete('entries');
  final random = Random();
  for (int i = 0; i < 200; i++) {
    entries.add(
      Entry(
        description: faker.lorem.sentence(),
        amount: Random().nextInt(100),
        category: categories[Random().nextInt(categories.length - 1)].title,
        type: types[Random().nextInt(types.length)],
        date: DateTime(
          2025,
          7,
          random.nextInt(30),
          random.nextInt(24),
          random.nextInt(60),
          random.nextInt(60),
        ).toIso8601String(),
      ),
    );
  }
  final batch = db.batch();
  for (final category in categories) {
    batch.insert('categories', {
      'uid': category.uid,
      'title': category.title,
      'type': category.type,
    });
  }
  for (final entry in entries) {
    batch.insert('entries', entry.toMap());
  }
  await batch.commit();
}
