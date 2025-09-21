import 'package:flutter/material.dart';
import 'package:mal/constants.dart';
import 'package:mal/features/calendar/domain/repositories/day_sums.dart';

class CalendarCell extends StatelessWidget {
  const CalendarCell({
    super.key,
    required this.hasTransactions,
    required this.totals,
    required this.date,
    required this.borderColor,
  });

  final Color borderColor;
  final bool hasTransactions;
  final DaySums totals;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date.day.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (hasTransactions) ...[
            if (totals.incomes > 0)
              Text(
                '+${approximate(totals.incomes.toInt())}',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (totals.expenses > 0)
              Text(
                '-${approximate(totals.expenses.toInt())}',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
