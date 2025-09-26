import 'package:mal/enums.dart';
import 'package:mal/features/search/data/sources/sql_provider.dart';
import 'package:mal/features/search/domain/bloc/filters.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/domain/repositories/search_repository.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/shared/query_builder.dart';
import 'package:mal/utils.dart';

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

  @override
  Future<List<String>> fetchCategories() async {
    // get list of maps (distentct columns)
    final result = await QueryBuilder(
      'entries',
    ).select(['category'], true).getAll();

    // iterate and get category name
    // return list of categories strings
    return List.generate(
      result.length,
      (index) => result[index]['category'] as String,
    );
  }

  @override
  Future<int> fetchMaxAmount() async {
    final result = await QueryBuilder(
      'entries',
    ).select(['amount'], true).sortBy('amount', SortingDirection.desc).getOne();

    return result != null ? result['amount'] as int : 0;
  }

  @override
  Future<Range<DateTime>> fetchDateBoundries() async {
    final minResult = await QueryBuilder(
      'entries',
    ).select(['date'], true).sortBy('date', SortingDirection.asc).getOne();

    final maxResult = await QueryBuilder(
      'entries',
    ).select(['date'], true).sortBy('date', SortingDirection.desc).getOne();

    return Range(
      min: minResult != null
          ? DateTime.parse(minResult['date'] as String)
          : DateTime(now().year),
      max: maxResult != null
          ? DateTime.parse(maxResult['date'] as String)
          : now(),
    );
  }
}
