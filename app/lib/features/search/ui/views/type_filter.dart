import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/search/domain/bloc/filters.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';

class TypeFilter extends StatelessWidget {
  const TypeFilter({super.key, required this.l10n, required this.theme});

  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card.filled(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                l10n.type,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              BlocBuilder<SearchBloc, SearchState>(
                builder: (BuildContext context, state) {
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      RadioListTile(
                        title: Text(l10n.all),
                        value: EntryType.all.name,
                        groupValue: state.filters.type.name,
                        onChanged: (String? value) {
                          if (value == null) return;
                          if (value.trim().isEmpty) return;
                          context.read<SearchBloc>().add(ClearFilterByType());
                        },
                      ),
                      RadioListTile(
                        title: Text(l10n.expense),
                        value: EntryType.expense.name,
                        groupValue: state.filters.type.name,
                        onChanged: (String? value) {
                          if (value == null) return;
                          if (value.trim().isEmpty) return;
                          context.read<SearchBloc>().add(FilterByExpense());
                        },
                      ),
                      RadioListTile(
                        title: Text(l10n.income),
                        value: EntryType.income.name,
                        groupValue: state.filters.type.name,
                        onChanged: (String? value) {
                          if (value == null) return;
                          if (value.trim().isEmpty) return;
                          context.read<SearchBloc>().add(FilterByIncome());
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
