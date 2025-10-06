import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/search/domain/bloc/filters.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/utils.dart';

class TypeFilter extends StatelessWidget {
  const TypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: context.colors.surfaceBright,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                context.l10n.type,
                style: context.texts.titleLarge?.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              BlocBuilder<SearchBloc, SearchState>(
                builder: (BuildContext context, state) {
                  return RadioGroup(
                    onChanged: (String? value) {
                      _onSelected(value, context);
                    },
                    groupValue: state.filters.type.name,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        RadioListTile(
                          title: Text(context.l10n.all),
                          value: EntryType.all.name,
                        ),
                        RadioListTile(
                          title: Text(context.l10n.expense),
                          value: EntryType.expense.name,
                        ),
                        RadioListTile(
                          title: Text(context.l10n.income),
                          value: EntryType.income.name,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSelected(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) return;

    if (value == EntryType.expense.name) {
      context.read<SearchBloc>().add(FilterByExpense());
    }
    if (value == EntryType.income.name) {
      context.read<SearchBloc>().add(FilterByIncome());
    }
    if (value == EntryType.all.name) {
      context.read<SearchBloc>().add(ClearFilterByType());
    }
  }
}
