import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mal/utils.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class Db {
  static sql.Database? _database;

  static Future<sql.Database> use() async {
    if (_database != null) return _database!;

    String? dbName;
    final dbFile = dbName = dotenv.env['DB_PATH'] ?? ':memory:';
    if (!dbFile.contains('memory')) {
      final dbPath = await sql.getDatabasesPath();
      dbName = path.join(dbPath, dbFile);
    }

    _database = await sql.openDatabase(
      dbName,
      onCreate: (db, version) async {
        final batch = db.batch();

        _categoriesMigrateUp(batch);
        _entriesMigrateUp(batch);

        await batch.commit();
        logger.i('database updated');
      },
      version: 1,
    );
    return _database!;
  }

  static void _entriesMigrateUp(sql.Batch batch) {
    batch.execute('''CREATE TABLE entries(
      uid text primary key,
      description text,
      type text,
      category text,
      date TEXT DEFAULT (datetime('now')),
      amount int
  );
  ''');
  }

  static void _categoriesMigrateUp(sql.Batch batch) {
    batch.execute('''
    CREATE TABLE categories(
       uid text primary key,
       title text,
       type text
    );
  ''');
  }
}
