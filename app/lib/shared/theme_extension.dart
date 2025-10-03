import 'package:flutter/material.dart';

/// Extension on BuildContext for easy theme access
extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get texts => theme.textTheme;
}
