import 'package:mal/features/calendar/domain/repositories/day_sums.dart';

abstract class CalendarRepository {
  Future<List<DaySums>> getSelectedMonthSums(int year, int month);
}
