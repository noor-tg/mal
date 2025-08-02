import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';

abstract class SearchRepository {
  Future<Result<Entry>> searchEntries({
    required String term,
    required int offset,
  });
}
