import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String moneyFormat(BuildContext context, int value) {
  return NumberFormat.decimalPattern('ar_SA').format(value);
}
