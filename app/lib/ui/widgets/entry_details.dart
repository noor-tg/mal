import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/models/entry.dart';
import 'package:mal/ui/widgets/mal_title.dart';
import 'package:mal/utils.dart';

class EntryDetails extends StatelessWidget {
  const EntryDetails({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(entry.type)),
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
                          entry.amount.toString(),
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
                          ).colorScheme.primary.withAlpha(50),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('# ${entry.category}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              box16,
              MalTitle(text: l10n!.description),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Text(entry.date.substring(0, 10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
