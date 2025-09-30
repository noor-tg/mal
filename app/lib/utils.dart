import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mal/shared/db.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart' as sql;

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

void errorSnakbar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.orange.shade800,
    ),
  );
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
