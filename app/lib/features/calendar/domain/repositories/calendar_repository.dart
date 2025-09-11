import 'package:mal/features/calendar/domain/repositories/day_sums.dart';
import 'package:mal/shared/data/models/entry.dart';

abstract class CalendarRepository {
  Future<List<DaySums>> getSelectedMonthSums(
    int year,
    int month,
    String userUid,
  );

  Future<List<Entry>> getSelectedDayEntries(DateTime date, String userUid);
}
