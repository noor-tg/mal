import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/models/entry.dart';
import 'package:mal/ui/widgets/entry_details.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';
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
  int offset = 0;
  bool noMoreData = false;

  var scrollController = ScrollController();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      searchResults = [];
    });
    scrollController.addListener(() async {
      if (isLoading) return;
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        setState(() {
          offset = offset + 8;
        });

        final result = await searchEntries(term: term, offset: offset);

        setState(() {
          if (result.isEmpty) {
            noMoreData = true;
            return;
          }
          searchResults.addAll(result);
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const NoDataCentered();
    final shimmerList = ShimmerList(
      height: 80,
      radius: 8,
      subColor: Colors.white,
      mainColor: Colors.grey[300]!,
      qtyLine: 2,
    );

    if (isLoading) {
      body = shimmerList;
    }
    if (currentError != null) {
      return Text('error :: $currentError');
    }
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    if (searchResults.isNotEmpty) {
      body = Expanded(
        child: Card.filled(
          color: Colors.white,
          child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            itemCount: searchResults.length + 1,
            itemBuilder: (ctx, int index) {
              if (index < searchResults.length) {
                final entry = searchResults[index];
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => EntryDetails(entry: entry),
                      ),
                    );
                  },
                  title: Text(
                    entry.description,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade800,
                    ),
                  ),
                  subtitle: Text(
                    entry.category,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade800,
                    ),
                  ),
                  trailing: Text(
                    entry.prefixedAmount(l10n!.income),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: entry.color(l10n.income),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: noMoreData
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              l10n!.noMoreData,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        )
                      : shimmerList,
                );
              }
            },
          ),
        ),
      );
    }

    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (value) async {
                    try {
                      if (value.trim().isEmpty) return;
                      setState(() {
                        term = value.trim();
                        isLoading = true;
                        searchResults = [];
                      });
                      final results = await searchEntries(term: value.trim());
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
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    searchResults = [];
                    _controller.clear();
                    term = '';
                    offset = 0;
                    noMoreData = false;
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.blue),
              ),
            ],
          ),
          box24,
          body,
        ],
      ),
    );
  }

  Future<List<Entry>> searchEntries({String term = '', int offset = 0}) async {
    try {
      final db = await createOrOpenDB();
      final search = '%$term%';
      final res = await db.query(
        'entries',
        where: 'type = ? or category like ? or description like ?',
        whereArgs: [term, search, search],
        limit: 8,
        offset: offset,
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
