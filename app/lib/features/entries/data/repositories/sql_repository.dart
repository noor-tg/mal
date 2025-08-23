import 'package:mal/features/entries/domain/repositories/entries_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/shared/db.dart';
import 'package:mal/shared/query_builder.dart';
import 'package:mal/shared/where.dart';

class SqlRepository extends EntriesRepository {
  @override
  Future<Entry> edit(Entry entry) async {
    final db = await Db.use();

    await db.update(
      'entries',
      entry.toMap(),
      where: 'uid = ?',
      whereArgs: [entry.uid],
    );

    return entry;
  }

  @override
  Future<Result<Entry>> find({List<Where>? where}) async {
    final listQb = QueryBuilder('entries');
    final countQb = QueryBuilder('entries');
    if (where != null) {
      for (final single in where) {
        if (single.oprand == '=') {
          listQb.where(single.field, single.oprand, single.value as String);
        }
        if (single.oprand == 'like') {
          listQb.whereLike(single.field, single.value as String);
        }
        if (single.oprand == 'between') {
          listQb.whereIn(single.field, single.value as List<String>);
        }
      }

      for (final single in where) {
        if (single.oprand == '=') {
          countQb.where(single.field, single.oprand, single.value as String);
        }
        if (single.oprand == 'like') {
          countQb.whereLike(single.field, single.value as String);
        }
        if (single.oprand == 'between') {
          countQb.whereIn(single.field, single.value as List<String>);
        }
      }
    }

    final data = await listQb.getAll();
    final list = List.generate(
      data.length,
      (index) => Entry.fromMap(data[index]),
    );
    final count = await countQb.count();

    return Result(list: list, count: count);
  }

  @override
  Future<Entry> findOne(String uid) async {
    final db = await Db.use();

    final stored = await db.query(
      'entries',
      where: 'uid = ?',
      whereArgs: [uid],
    );

    if (stored.isEmpty) throw Error();

    final entry = Entry.fromMap(stored.first);

    return entry;
  }

  @override
  Future<bool> remove(Entry entry) async {
    try {
      final db = await Db.use();

      await db.delete('entries', where: 'uid = ?', whereArgs: [entry.uid]);

      return true;
    } catch (err) {
      return false;
    }
  }

  @override
  Future<Entry> store(Entry entry) async {
    final db = await Db.use();

    await db.insert('entries', entry.toMap());

    return entry;
  }
}
