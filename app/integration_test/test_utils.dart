import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

Matcher hasTitleIn(List<String> allowed) {
  return predicate<PatrolFinder>((pf) {
    final elements = pf.evaluate();
    if (elements.isEmpty) return false;

    for (final e in elements) {
      final widget = e.widget;
      if (widget is AppBar && widget.title is Text) {
        final title = (widget.title as Text).data ?? '';
        return allowed.contains(title);
      }
    }
    return false;
  }, 'AppBar title should be one of $allowed');
}
