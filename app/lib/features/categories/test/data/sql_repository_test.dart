// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/categories/data/repositories/sql_repository.dart';
import 'package:mal/test/unit_utils.dart';

void main() async {
  group('Categories SQL Repository', () {
    setUpAll(() async {
      await GeneralSetup.init();
    });
    test('> get categories > default all', () async {
      final repo = SqlRepository();
      // query using sql provider
      final result = await repo.find();
      // check results
      expect(result.count, 4);
      expect(result.list[0].title, categories[3].title);
    });
  });
}
