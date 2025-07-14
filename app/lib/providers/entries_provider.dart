import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/models/entry.dart';
import 'package:mal/utils.dart';

class EntriesNotifier extends StateNotifier<List<Entry>> {
  EntriesNotifier() : super([]);

  void saveEntry({
    required String description,
    required String type,
    required int amount,
    required String category,
    required String date,
  }) async {
    final entry = Entry(
      description: description,
      type: type,
      amount: amount,
      category: category,
      date: date,
    );

    final db = await createOrOpenDB();

    await db.insert('entries', {
      'uid': entry.uid,
      'description': entry.description,
      'type': entry.type,
      'category': entry.category,
      'date': entry.date,
      'amount': entry.amount,
    });

    state = [entry, ...state];
  }

  Future<void> loadEntries() async {
    try {
      final db = await createOrOpenDB();

      final data = await db.query('entries', orderBy: 'date desc');
      state = data
          .map(
            (row) => Entry(
              uid: row['uid'] as String,
              description: row['description'] as String,
              date: row['date'] as String,
              category: row['category'] as String,
              amount: row['amount'] as int,
              type: row['type'] as String,
            ),
          )
          .toList();
    } catch (err) {
      print('error in provider');
      print(err);
    }
  }

  removeEntry(String uid) async {
    final db = await createOrOpenDB();

    await db.delete('entries', where: 'uid = ?', whereArgs: [uid]);
    await loadEntries();
  }
}

final entriesProvider = StateNotifierProvider((ref) => EntriesNotifier());
