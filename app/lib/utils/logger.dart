import 'dart:convert';
import 'package:logger/logger.dart';

extension JsonLogger on Logger {
  void json(dynamic object, {String? indent}) {
    const encoder = JsonEncoder.withIndent('  ');
    if (object is String) {
      try {
        final decoded = jsonDecode(object);
        d(encoder.convert(decoded));
      } catch (e) {
        d(object); // If it's not valid JSON, log as-is
      }
    } else {
      d(encoder.convert(object));
    }
  }
}

// Usage
final logger = Logger();
