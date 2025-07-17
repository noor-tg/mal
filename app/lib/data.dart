import 'dart:math';

import 'package:mal/models/category.dart';
import 'package:mal/models/entry.dart';

import 'package:faker/faker.dart';
import 'package:mal/utils.dart';

final random = RandomGenerator(seed: 63833423);
final faker = Faker.withGenerator(random);

final categories = [
  Category(title: 'طعام', type: 'منصرف'),
  Category(title: 'ملابس', type: 'منصرف'),
  Category(title: 'خدمات', type: 'منصرف'),
  Category(title: 'أخرى', type: 'منصرف'),
];

final types = ['دخل', 'منصرف'];

List<Entry> entries = [];

Future<void> generateData() async {
  final db = await createOrOpenDB();
  await db.delete('categories');
  await db.delete('entries');
  for (int i = 0; i < 200; i++) {
    entries.add(
      Entry(
        description: faker.lorem.sentence(),
        amount: Random().nextInt(100),
        category: categories[Random().nextInt(categories.length - 1)].title,
        type: types[Random().nextInt(types.length)],
        date: faker.date
            .dateTimeBetween(
              DateTime(2025, 7),
              DateTime(2025, 7, DateTime.now().day),
            )
            .toIso8601String(),
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
    batch.insert('entries', {
      'uid': entry.uid,
      'description': entry.description,
      'type': entry.type,
      'category': entry.category,
      'date': entry.date,
      'amount': entry.amount,
    });
  }
  await batch.commit();
}
