import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mal/shared/db.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:mal/l10n/app_localizations.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

String moneyFormat(int value) {
  return NumberFormat.decimalPattern('ar_SA').format(value);
}

Future<sql.Database> createOrOpenDB() async {
  return Db.use();
}

List<String> getCurrentMonthDays() {
  final now = DateTime.now();
  // Generate list of date strings
  final List<String> days = [];
  for (int day = 1; day <= now.day; day++) {
    // Format day with zero padding and create date string
    final dayStr = day.toString().padLeft(2, '0');
    days.add(dayStr);
  }

  return days;
}

const box4 = SizedBox(height: 4, width: 4);
const box8 = SizedBox(height: 8, width: 8);
const box16 = SizedBox(height: 16, width: 16);
const box24 = SizedBox(height: 24, width: 24);
const box32 = SizedBox(height: 32, width: 32);

DateTime now() {
  return DateTime.now();
}

String toDate(DateTime d) {
  return d.toString().substring(0, 10);
}

String formatDateWithEnglishNumbers(String date) {
  final formatted = DateFormat.yMMMMEEEEd('ar').format(DateTime.parse(date));

  // Map of Arabic-Indic digits to Western digits
  const arabicToEnglish = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  String result = formatted;
  arabicToEnglish.forEach((arabic, english) {
    result = result.replaceAll(arabic, english);
  });

  return result;
}

// theme for stateless
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get texts => theme.textTheme;
}

// l10n for stateless
extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

// for stateful widgets
extension ThemeStateExtension<T extends StatefulWidget> on State<T> {
  // theme
  ThemeData get theme => Theme.of(context);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get texts => theme.textTheme;

  // l10n
  AppLocalizations get l10n => AppLocalizations.of(context)!;
}
