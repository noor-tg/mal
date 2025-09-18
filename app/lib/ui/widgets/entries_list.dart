import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/ui/widgets/entry_details.dart';

class EntriesList extends StatelessWidget {
  final List<Entry> entries;

  const EntriesList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Card.filled(
      color: Colors.white,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) => ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) {
                  final entriesBloc = context.read<EntriesBloc>();
                  return BlocProvider.value(
                    value: entriesBloc,
                    child: EntryDetails(entry: entries[index]),
                  );
                },
              ),
            );
          },
          title: Text(
            entries[index].description.length > 25
                ? entries[index].description.substring(0, 26)
                : entries[index].description,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          subtitle: Text(
            entries[index].category,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Text(
            entries[index].prefixedAmount(l10n!.income),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: entries[index].color(l10n.income),
            ),
          ),
        ),
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1,
          thickness: 2,
          indent: 16,
          endIndent: 16,
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
