import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({
    super.key,
    required DateTime? date,
    required this.selectDate,
  }) : _date = date;

  final DateTime? _date;

  final void Function() selectDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withAlpha(30),
          ),
          onPressed: selectDate,
          child: Row(
            children: [
              Text(
                _date == null
                    ? AppLocalizations.of(context)!.notSelected
                    : formatter.format(_date),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.calendar_month),
            ],
          ),
        ),
      ],
    );
  }
}
