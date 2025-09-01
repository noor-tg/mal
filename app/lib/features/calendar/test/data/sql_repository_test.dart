// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mal/data.dart';
import 'package:mal/features/calendar/data/repositories/sql_repository.dart'
    as calendar;
import 'package:mal/features/entries/data/repositories/sql_repository.dart'
    as entries;
import 'package:mal/test/unit_utils.dart';
import 'package:mal/utils.dart';

void main() {
  group('Entries SQL Repository', () {
    setUpAll(() async {
      await GeneralSetup.init();
    });
    getCurrentMonthDaysSumsTests();
  });
}

void getCurrentMonthDaysSumsTests() {
  test('> get current month days sums', () async {
    final calendarRepo = calendar.SqlRepository();
    final entriesRepo = entries.SqlRepository();

    var entry = fakeEntry();
    entry = entry.copyWith(date: now().toIso8601String());

    // query using sql provider
    await entriesRepo.store(entry);
    // update
    final list = await calendarRepo.getSelectedMonthSums(
      now().year,
      now().month,
    );

    expect(list.isNotEmpty, true);
    expect(list.length, greaterThan(0));
    logger.i(list);
  });
}
