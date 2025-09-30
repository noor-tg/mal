import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/shared/query_builder.dart';
import 'package:mal/ui/widgets/entry_form.dart';
import 'package:mal/ui/widgets/mal_title.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/dates.dart';

class EntryDetails extends StatefulWidget {
  const EntryDetails({super.key, required this.entry});

  final Entry entry;

  @override
  State<EntryDetails> createState() => _EntryDetailsState();
}

class _EntryDetailsState extends State<EntryDetails> {
  late Entry entry;
  @override
  void initState() {
    super.initState();
    entry = widget.entry;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.type),
        actions: [
          IconButton.filled(
            tooltip: l10n.remove,
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.withAlpha(30),
            ),
            color: Colors.red,
            icon: const Icon(Icons.delete),
            onPressed: () {
              final entriesBloc = context.read<EntriesBloc>();

              // ignore: cascade_invocations
              entriesBloc.add(RemoveEntry(entry));
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).clearSnackBars();
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.entryRemovedSuccessfully),
                  duration: const Duration(seconds: 7),
                  action: SnackBarAction(
                    onPressed: () {
                      entriesBloc.add(StoreEntry(entry));
                    },
                    label: l10n.reset,
                  ),
                ),
              );
              Navigator.of(context).pop();
            },
          ),
          box8,
          IconButton.filled(
            tooltip: l10n.edit,
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue.withAlpha(30),
            ),
            color: Colors.blue,
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final entriesBloc = context.read<EntriesBloc>();
              final result = await showModalBottomSheet<bool>(
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (ctx) => BlocProvider.value(
                  value: entriesBloc,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.90,
                    child: EntryForm(entry: entry),
                  ),
                ),
              );
              if (result == true) {
                final result = await QueryBuilder(
                  'entries',
                ).where('uid', '=', entry.uid).getOne();
                setState(() {
                  entry = Entry.fromMap(result!);
                });
              }
            },
          ),
          box16,
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,

        color: Colors.grey.shade200,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card.filled(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          moneyFormat(entry.amount),
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        box16,
                        Card.filled(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(30),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '# ${entry.category}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              box16,
              MalTitle(text: l10n.title),
              box8,
              Card.filled(
                color: Colors.white,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Text(entry.description),
                ),
              ),
              box16,
              MalTitle(text: l10n.date),
              box8,
              Card.filled(
                color: Colors.white,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatDateWithEnglishNumbers(entry.date)),
                      box16,
                      Text(relativeTime(entry.date)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
