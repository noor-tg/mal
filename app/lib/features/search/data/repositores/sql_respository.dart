import 'package:mal/features/search/data/sources/sql_provider.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';

class SqlRespository extends SearchRepository {
  SqlProvider sqlProvider = SqlProvider();
  SqlRespository();

  @override
  Future<Result<Entry>> searchEntries({
    required String term,
    required String userUid,
    int offset = 0,
  }) async {
    final list = await sqlProvider.searchEntries(
      term: term,
      offset: offset,
      userUid: userUid,
    );
    final count = await sqlProvider.searchEntriesCount(
      term: term,
      userUid: userUid,
    );
    final data = List.generate(list.length, (i) => Entry.fromMap(list[i]));

    return Result(list: data, count: count);
  }

  @override
  Future<Result<Entry>> advancedSearch(
    SearchState queryData,
    String userUid,
  ) async {
    final list = await sqlProvider.getListByFilters(
      term: queryData.term,
      offset: queryData.offset,
      filters: queryData.filters,
      sorting: queryData.sorting,
      userUid: userUid,
    );

    final count = await sqlProvider.getCountByFilters(
      term: queryData.term,
      offset: queryData.offset,
      filters: queryData.filters,
      sorting: queryData.sorting,
      userUid: userUid,
    );

    final data = List.generate(list.length, (i) => Entry.fromMap(list[i]));

    return Result<Entry>(list: data, count: count);
  }
}
