import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

const uuid = Uuid();
final formatter = DateFormat.yMd();

String moneyFormat(BuildContext context, int value) {
  return NumberFormat.decimalPattern('ar_SA').format(value);
}

class MalPage {
  MalPage({
    required this.widget,
    required this.title,
    required this.icon,
    required this.actions,
  });

  final String title;
  final Widget widget;
  final Icon icon;
  final List<Widget> actions;
}

Future<sql.Database> createOrOpenDB() async {
  final dbPath = await sql.getDatabasesPath();
  return sql.openDatabase(
    path.join(dbPath, 'mal.db'),
    onCreate: (db, version) async {
      final batch = db.batch();

      categoriesMigrateUp(batch);
      entriesMigrateUp(batch);

      await batch.commit();
      print('database updated');
    },
    version: 1,
  );
}

void entriesMigrateUp(sql.Batch batch) {
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

void categoriesMigrateUp(sql.Batch batch) {
  batch.execute('''
    CREATE TABLE categories(
       uid text primary key,
       title text,
       type text
    );
  ''');
}
