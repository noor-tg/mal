import 'package:mal/utils.dart';

int monthLength(int year, int month) {
  final beginningNextMonth = (month < 12)
      ? DateTime(year, month + 1)
      : DateTime(year + 1);
  final lastDayOfMonth = beginningNextMonth.subtract(const Duration(days: 1));
  return lastDayOfMonth.day;
}

List<String> getMonthDays(int year, int month) {
  // Generate list of date strings
  final List<String> days = [];
  for (int day = 1; day <= monthLength(year, month); day++) {
    // Format day with zero padding and create date string
    final dayStr = day.toString().padLeft(2, '0');
    days.add(dayStr);
  }

  return days;
}

bool compareDate(String isoDate, String dayFormated) {
  return DateTime.parse(isoDate).day == int.parse(dayFormated);
}

DateTime todayEnd(DateTime now) =>
    DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

String relativeTime(String date) {
  final dateTime = DateTime.parse(date);

  final diffInDays = now().difference(dateTime).inDays;
  final diffInHours = now().difference(dateTime).inHours;
  final diffInMinutes = now().difference(dateTime).inMinutes;
  final diffInSeconds = now().difference(dateTime).inSeconds;

  if (diffInDays > 364) {
    return 'منذ ${(diffInDays / 364).floor()} سنة';
  }

  if (diffInDays > 31) {
    return 'منذ ${(diffInDays / 30).floor()} شهر';
  }

  if (diffInDays >= 7) {
    return 'منذ ${(diffInDays / 7).floor()} أسبوع';
  }

  if (diffInDays < 7 && diffInDays > 1) {
    return 'منذ $diffInDays أيام';
  }

  if (diffInHours <= 24 && diffInHours >= 1) {
    return 'منذ $diffInHours ساعات';
  }

  if (diffInMinutes < 60 && diffInMinutes >= 1) {
    return 'منذ $diffInMinutes دقائق';
  }

  if (diffInSeconds < 60) {
    return 'منذ $diffInSeconds ثواني';
  }

  return dateTime.toIso8601String().substring(0, 10);
}
