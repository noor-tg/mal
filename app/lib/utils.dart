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
