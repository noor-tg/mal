import 'package:mal/constants.dart';
import 'package:mal/features/search/domain/bloc/filters.dart';
import 'package:mal/features/search/domain/bloc/sorting.dart';
import 'package:mal/shared/query_builder.dart';

class SqlProvider {
  final table = 'entries';
  final String searchWhere =
      '"type" = ? or "category" like ? or "description" like ?';

  Future<List<Map<String, dynamic>>> searchEntries({
    required String userUid,
    String term = '',
    int offset = 0,
  }) {
    final search = '%$term%';
    return QueryBuilder('entries')
        .where('user_uid', '=', userUid)
        .where('type', '=', term)
        .whereLike('category', search, 'OR')
        .whereLike('description', search, 'OR')
        .sortBy('date', SortingDirection.desc)
        .limit(kSearchLimit)
        .offset(offset)
        .getAll();
  }

  Future<int> searchEntriesCount({String term = '', required String userUid}) {
    final search = '%$term%';
    return QueryBuilder('entries')
        .where('user_uid', '=', userUid)
        .where('type', '=', term)
        .whereLike('category', search, 'OR')
        .whereLike('description', search, 'OR')
        .sortBy('date', SortingDirection.desc)
        .count();
  }

  Future<List<Map<String, dynamic>>> getListByFilters({
    required String term,
    required int offset,
    required Filters filters,
    required Sorting sorting,
    required String userUid,
  }) async {
    final q = QueryBuilder('entries').where('user_uid', '=', userUid);

    // search by description
    final search = '%$term%';
    if (term.isNotEmpty) {
      q.whereLike('description', search);
    }

    // search by type
    if (filters.type != EntryType.all) {
      switch (filters.type) {
        case EntryType.expense:
          q.where('type', '=', expenseType);
          break;
        case EntryType.income:
          q.where('type', '=', incomeType);
          break;
        case EntryType.all:
      }
    }

    // search by categories
    if (filters.categories.isNotEmpty) {
      q.whereIn('category', filters.categories);
    }

    // search by amount range
    if (filters.amountRange.max > 0) {
      q.whereBetween(
        'amount',
        filters.amountRange.min.toString(),
        filters.amountRange.max.toString(),
      );
    }

    // date range is applied by defulat . because there is no clear condition to apply it
    return q
        .whereBetween(
          'date',
          filters.dateRange.min.toIso8601String(),
          filters.dateRange.max.toIso8601String(),
        )
        .offset(offset)
        .limit(kSearchLimit)
        .sortBy(sorting.field.name, sorting.direction)
        .getAll();
  }

  Future<int> getCountByFilters({
    required String term,
    required int offset,
    required Filters filters,
    required Sorting sorting,
    required String userUid,
  }) async {
    final q = QueryBuilder('entries').where('user_uid', '=', userUid);

    // search by description
    final search = '%$term%';
    if (term.isNotEmpty) {
      q.whereLike('description', search);
    }

    // search by type
    if (filters.type != EntryType.all) {
      switch (filters.type) {
        case EntryType.expense:
          q.where('type', '=', 'منصرف');
          break;
        case EntryType.income:
          q.where('type', '=', 'دخل');
          break;
        case EntryType.all:
      }
    }

    // search by categories
    if (filters.categories.isNotEmpty) {
      q.whereIn('category', filters.categories);
    }

    // search by amount range
    if (filters.amountRange.max > 0) {
      q.whereBetween(
        'amount',
        filters.amountRange.min.toString(),
        filters.amountRange.max.toString(),
      );
    }

    final result = await q
        .whereBetween(
          'date',
          filters.dateRange.min.toIso8601String(),
          filters.dateRange.max.toIso8601String(),
        )
        .count();

    return result;
  }
}
