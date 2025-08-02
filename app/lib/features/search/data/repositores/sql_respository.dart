import 'package:mal/features/search/data/sources/sql_provider.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
import 'package:mal/shared/data/models/entry.dart';

class SqlRespository extends SearchRepository {
  SqlProvider sqlProvider;
  SqlRespository() : sqlProvider = SqlProvider();

  @override
  Future<List<Entry>> searchEntries({
    required String term,
    int offset = 0,
  }) async {
    final res = await sqlProvider.searchEntries(term: term, offset: offset);
    final List<Entry> data = [];
    for (final item in res) {
      data.add(Entry.fromMap(item));
    }
    return data;
  }
}
