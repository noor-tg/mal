import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
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
            onPressed: () => _onRemoveEntry(context),
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
              _onEditEntry();
            },
          ),
          box16,
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,

        color: colors.surfaceContainer,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMountCard(context),
              box16,
              MalTitle(text: l10n.title),
              box8,
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Text(entry.description),
                ),
              ),
              box16,
              MalTitle(text: l10n.date),
              box8,
              _buildDateCard(),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildDateCard() {
    return Card(
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
    );
  }

  Card _buildMountCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Center(
          child: Column(
            children: [
              Text(
                moneyFormat(entry.amount),
                style: texts.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              box16,
              Card(
                color: colors.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '# ${entry.category}',
                    style: TextStyle(
                      fontSize: 18,
                      color: colors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRemoveEntry(BuildContext context) {
    final entriesBloc = context.read<EntriesBloc>()..add(RemoveEntry(entry));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
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
  }

  void _onEditEntry() async {
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
    if (result != true) return;
    final out = await QueryBuilder(
      'entries',
    ).where('uid', '=', entry.uid).getOne();
    setState(() {
      entry = Entry.fromMap(out!);
    });
  }
}
