import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';

abstract class SearchRepository {
  Future<Result<Entry>> searchEntries({
    required String term,
    required int offset,
    required String userUid,
  });
  Future<Result<Entry>> advancedSearch(SearchState queryData, String userUid);
}
