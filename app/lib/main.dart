import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/data.dart';
import 'package:mal/ui/mal_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await generateData();
  runApp(const ProviderScope(child: MalApp()));
}
