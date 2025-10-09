import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mal/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mal/ui/mal_app.dart';
// ignore: unused_import
import 'package:mal/data.dart';
// ignore: unused_import
import 'package:mal/utils.dart';
// ignore: unused_import
import 'package:mal/shared/db.dart';

void main() async {
  runApp(await initMalApp());
}

Future<Widget> initMalApp() async {
  await initializeDateFormatting();
  await dotenv.load();
  final prefs = await SharedPreferences.getInstance();
  final seenOnBoarding = prefs.getBool(PrefsKeys.seen_onboarding.name) ?? false;

  // await Db.deleteOldDatabase();
  // await generateData();
  // await prefs.remove('seen_onboarding');
  // await prefs.remove('last_auth_user');
  // logger.i(prefs.getKeys());
  return MalApp(seenOnBoard: seenOnBoarding);
}
