import 'package:mal/features/search/data/sources/sql_provider.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';

class SqlRespository extends SearchRepository {
  SqlProvider sqlProvider = SqlProvider();
  SqlRespository();

  @override
  Future<Result<Entry>> searchEntries({
    required String term,
    int offset = 0,
  }) async {
    final list = await sqlProvider.searchEntries(term: term, offset: offset);
    final count = await sqlProvider.searchEntriesCount(
      term: term,
      offset: offset,
    );
    final data = List.generate(list.length, (i) => Entry.fromMap(list[i]));

    return Result(list: data, count: count);
  }
}
