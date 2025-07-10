import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String moneyFormat(BuildContext context, int value) {
  return NumberFormat.decimalPattern('ar_SA').format(value);
}

class MalPage {
  MalPage({
    required this.widget,
    required this.title,
    required this.icon,
    required this.actions,
  });

  final String title;
  final Widget widget;
  final Icon icon;
  final List<Widget> actions;
}
