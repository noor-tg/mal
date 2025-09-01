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
