import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/ui/widgets/entry_details.dart';
import 'package:mal/utils.dart';

class EntriesList extends StatelessWidget {
  final List<Entry> entries;

  const EntriesList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Card(
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
            style: context.texts.titleMedium?.copyWith(
              color: context.colors.onSurface,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entries[index].category,
                style: context.texts.bodyLarge?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                toDate(DateTime.parse(entries[index].date)),
                style: context.texts.bodyLarge?.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          isThreeLine: true,
          trailing: Text(
            entries[index].prefixedAmount(context.l10n.income),
            style: context.texts.bodyLarge?.copyWith(
              color: entries[index].color(context.l10n.income),
            ),
          ),
        ),
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1,
          thickness: 2,
          indent: 16,
          endIndent: 16,
          color: context.colors.onSurfaceVariant.withAlpha(50),
        ),
      ),
    );
  }
}
