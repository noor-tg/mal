import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/models/entry.dart';
import 'package:mal/utils.dart';

class EntriesNotifier extends StateNotifier<List<Entry>> {
  EntriesNotifier() : super([]);

  void saveEntry({required Entry entry, required String operaton}) async {
    final db = await createOrOpenDB();

    if (operaton == 'insert') {
      await db.insert('entries', {
        'uid': entry.uid,
        'description': entry.description,
        'type': entry.type,
        'category': entry.category,
        'date': entry.date,
        'amount': entry.amount,
      });
    }
    if (operaton == 'update') {
      await db.update(
        'entries',
        {
          'uid': entry.uid,
          'description': entry.description,
          'type': entry.type,
          'category': entry.category,
          'date': entry.date,
          'amount': entry.amount,
        },
        where: 'uid = ?',
        whereArgs: [entry.uid],
      );
    }

    await loadEntries();
  }

  Future<void> loadEntries() async {
    try {
      final db = await createOrOpenDB();

      final data = await db.query('entries', orderBy: 'date desc', limit: 10);
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
      logger
        ..i('error in provider')
        ..i(err);
    }
  }

  removeEntry(String uid) async {
    final db = await createOrOpenDB();

    await db.delete('entries', where: 'uid = ?', whereArgs: [uid]);
    await loadEntries();
  }
}

final entriesProvider = StateNotifierProvider((ref) => EntriesNotifier());
