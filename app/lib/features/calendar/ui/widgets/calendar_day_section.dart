import 'package:flutter/material.dart';
import 'package:mal/features/calendar/domain/bloc/calendar_bloc.dart';
import 'package:mal/ui/widgets/entries_list.dart';
import 'package:mal/utils.dart';

class CalendarDaySection extends StatelessWidget {
  final CalendarState state;

  const CalendarDaySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              EntriesList(entries: state.selectedDayData),
              box64,
            ],
          ),
        ),
      ),
    );
  }
}
