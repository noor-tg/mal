// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/categories/data/repositories/sql_repository.dart';
import 'package:mal/shared/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  group('Categories SQL Repository', () {
    late SqlRepository repo;
    // ignore: unused_local_variable
    late Database db;
    // late List<Map<String, dynamic>> all;

    setUpAll(() async {
      databaseFactory = databaseFactoryFfi;
      await dotenv.load();
      db = await Db.use();
      await generateData();
      repo = SqlRepository();
      // all = await db.query('categories');
    });

    test('> get categories > default all', () async {
      // query using sql provider
      final result = await repo.find();
      // check results
      expect(result.count, 4);
      expect(result.list[0].title, categories[3].title);
    });
  });
}
