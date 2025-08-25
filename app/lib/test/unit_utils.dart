import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mal/data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class GeneralSetup {
  static bool _isInited = false;

  static init() async {
    if (_isInited) return;

    await dotenv.load(fileName: '.env.test');
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await generateData();
    _isInited = true;
  }
}
