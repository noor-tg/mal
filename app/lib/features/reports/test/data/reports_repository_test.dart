// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/reports/data/repositories/sql_repository.dart';
import 'package:mal/test/unit_utils.dart';

void main() async {
  group('Reports SQL Repository', () {
    setUpAll(() async {
      await GeneralSetup.init();
    });
    test('> get all totals', () async {
      final user = await fakeStoredUser();
      final repo = SqlRepository();
      // query using sql provider
      final result = await repo.totals(user!.uid);
      // check results
      expect(result.balance, isA<int>());
      expect(result.incomes, isA<int>());
      expect(result.expenses, isA<int>());
    });
    test('> calc month sums', () async {
      final repo = SqlRepository();
      final user = await fakeStoredUser();
      // query using sql provider
      final result = await repo.dailySums(user!.uid);
      // check results
      expect(result.incomes, isA<List<int>>());
      expect(result.incomes.length, greaterThan(0));
      expect(result.expenses, isA<List<int>>());
      expect(result.expenses.length, greaterThan(0));
    });
    // test('> calc income categories sums', () async {}, skip: true);
    // test('> calc expenses categories sums', () async {}, skip: true);
  });
}
