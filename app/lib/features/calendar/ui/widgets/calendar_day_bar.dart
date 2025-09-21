import 'package:flutter/material.dart';
import 'package:mal/features/calendar/domain/bloc/calendar_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class CalendarDayBar extends StatelessWidget {
  final CalendarState state;
  final DateTime? selectedDay;
  final int Function(CalendarState state) net;

  const CalendarDayBar({
    super.key,
    required this.state,
    this.selectedDay,
    required this.net,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title =
        '${l10n.entries} ${selectedDay != null ? toDate(selectedDay!) : ""}';
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            net(state) == 0 ? '' : moneyFormat(net(state).toInt()),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: net(state) > 0 ? Colors.green[700] : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }
}
