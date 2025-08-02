import 'package:mal/shared/data/models/entry.dart';

abstract class SearchRepository {
  Future<List<Entry>> searchEntries({
    required String term,
    required int offset,
  });
}
