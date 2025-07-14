import 'package:flutter/material.dart';
import 'package:mal/utils.dart';

class Entry {
  Entry({
    required this.description,
    required this.date,
    required this.amount,
    required this.category,
    required this.type,
    String? uid,
  }) : uid = uid ?? uuid.v4();

  final String uid;
  final String description;
  final String date;
  final int amount;
  final String category;
  final String type;

  String prefixedAmount(String incomeL10n) =>
      '${amount.toString()} ${type == incomeL10n ? "+" : "-"}';

  Color color(String incomeL10n) =>
      type == incomeL10n ? Colors.green : Colors.red;
}
