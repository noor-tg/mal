import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/ui/mal_app.dart';

void main() async {
  runApp(await initMalApp());
}

Future<Widget> initMalApp() async {
  await dotenv.load();
  return const ProviderScope(child: MalApp());
}
