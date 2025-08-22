// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/entries/data/repositories/sql_repository.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/shared/db.dart';
import 'package:mal/shared/where.dart';
import 'package:mal/test/unit_utils.dart';

void main() {
  group('Entries SQL Repository', () {
    setUpAll(() async {
      await GeneralSetup.init();
    });
    storeSingleEntryTest();
    updateSingleEntryTest();
    removeSingleEntryTest();
    getSingleEntryTest();
    getManyEntriesTest();
  });
}

void getManyEntriesTest() {
  test('> get many Entries', () async {
    final repo = SqlRepository();
    final entry = fakeEntry();
    // query using sql provider
    await repo.store(entry);
    // update
    final result = await repo.find([
      Where(field: 'uid', oprand: '=', value: entry.uid),
    ]);
    expect(result.list.isNotEmpty, true);
    expect(result.count, greaterThan(0));
  });
}

void getSingleEntryTest() {
  test('> get single Entry', () async {
    final repo = SqlRepository();
    final entry = fakeEntry();
    // query using sql provider
    await repo.store(entry);
    // update
    final result = await repo.findOne(entry.uid);
    expect(result.uid, entry.uid);
  });
}

void removeSingleEntryTest() {
  test('> remove single Entry', () async {
    final db = await Db.use();
    final repo = SqlRepository();
    final entry = fakeEntry();
    // query using sql provider
    await repo.store(entry);
    // update
    final result = await repo.remove(entry);
    // check results
    final storedEntry = await db.query(
      'entries',
      where: 'uid = ?',
      whereArgs: [entry.uid],
    );
    expect(storedEntry.isEmpty, true);
    expect(result, true);
  });
}

void updateSingleEntryTest() {
  test('> update single Entry', () async {
    final db = await Db.use();
    final repo = SqlRepository();
    final entry = fakeEntry();
    // query using sql provider
    await repo.store(entry);
    // update
    final result = await repo.edit(entry.copyWith(description: 'test'));
    // check results
    expect(result.uid, entry.uid);
    final storedEntry = await db.query(
      'entries',
      where: 'uid = ?',
      whereArgs: [entry.uid],
    );
    if (storedEntry.isNotEmpty) {
      final entryInfo = Entry.fromMap(storedEntry.first);
      expect(entryInfo.description, 'test');
    } else {
      throw Error();
    }
  });
}

void storeSingleEntryTest() {
  test('> store single Entry', () async {
    final db = await Db.use();
    final repo = SqlRepository();
    final entry = fakeEntry();
    // query using sql provider
    final result = await repo.store(entry);
    // check results
    expect(result.uid, entry.uid);
    final storedEntry = await db.query(
      'entries',
      where: 'uid = ?',
      whereArgs: [entry.uid],
    );
    if (storedEntry.isNotEmpty) {
      final entryInfo = Entry.fromMap(storedEntry.first);
      expect(entryInfo.uid, entry.uid);
    } else {
      throw Error();
    }
  });
}
