import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/models/entry.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';
import 'package:mal/ui/widgets/entries_list.dart';
import 'package:mal/utils.dart';
import 'package:shimmer_effects_plus/shimmer_effects_plus.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String term = '';
  Object? currentError;
  bool isLoading = false;
  List<Entry> searchResults = [];

  @override
  void initState() {
    searchResults = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const NoDataCentered();

    if (isLoading) {
      body = ShimmerList(
        height: 80,
        radius: 8,
        subColor: Colors.white,
        mainColor: Colors.grey[300]!,
        qtyLine: 5,
      );
    }
    if (currentError != null) {
      return Text('error :: $currentError');
    }
    if (searchResults.isNotEmpty) {
      body = EntriesList(entries: searchResults);
    }

    return MalPageContainer(
      child: Column(
        children: [
          TextField(
            onChanged: (value) async {
              try {
                if (value.trim().isEmpty) return;
                setState(() {
                  isLoading = true;
                  searchResults = [];
                });
                final results = await searchEntries(value);
                setState(() {
                  searchResults = results;
                  isLoading = false;
                });
              } catch (error) {
                isLoading = false;
                searchResults = [];
                logger.e(error);
                currentError = error;
              }
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.tabSearchLabel,
              hintText: AppLocalizations.of(context)!.searchHint,
            ),
            autofocus: true,
          ),
          box24,
          body,
        ],
      ),
    );
  }

  Future<List<Entry>> searchEntries(String term) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final db = await createOrOpenDB();
      final search = '%$term%';
      final res = await db.query(
        'entries',
        where: 'type = ? or category like ? or description like ?',
        whereArgs: [term, search, search],
      );
      final List<Entry> data = [];
      for (final item in res) {
        data.add(
          Entry(
            uid: item['uid'] as String,
            description: item['description'] as String,
            amount: item['amount'] as int,
            category: item['category'] as String,
            type: item['type'] as String,
          ),
        );
      }
      return data;
    } catch (error) {
      logger.t(error);
    }
    return [];
  }
}
