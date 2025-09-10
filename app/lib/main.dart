import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mal/ui/mal_app.dart';
// ignore: unused_import
import 'package:mal/utils.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'package:mal/shared/db.dart';

void main() async {
  await initializeDateFormatting();
  runApp(await initMalApp());
}

Future<Widget> initMalApp() async {
  await dotenv.load();
  await Db.deleteOldDatabase();
  final prefs = await SharedPreferences.getInstance();
  // logger.i(prefs.getKeys());
  await prefs.remove('last_auth_user');
  return const MalApp();
}
