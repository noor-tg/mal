// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/categories/data/repositories/sql_repository.dart';
import 'package:mal/shared/query_builder.dart';
import 'package:mal/test/unit_utils.dart';
import 'package:mal/utils.dart';

void main() async {
  group('Categories SQL Repository', () {
    setUpAll(() async {
      await GeneralSetup.init();
    });
    test('> get categories > default all', () async {
      final repo = SqlRepository();
      final userInfo = await QueryBuilder(
        'users',
      ).sortBy('date', SortingDirection.asc).getAll();
      final categories = await QueryBuilder('categories').getAll();
      // query using sql provider
      final result = await repo.find(
        userUid: userInfo.isNotEmpty
            ? userInfo.first['uid'] as String
            : uuid.v4(),
      );
      // check results
      expect(result.count, 4);
      expect(result.list[0].title, categories[3]['title'] as String);
    });
  });
}
