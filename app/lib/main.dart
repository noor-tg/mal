import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mal/ui/mal_app.dart';

void main() async {
  runApp(await initMalApp());
}

Future<Widget> initMalApp() async {
  await initializeDateFormatting();
  await dotenv.load();
  return const MalApp();
}
