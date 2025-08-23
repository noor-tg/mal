import 'package:mal/result.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/shared/where.dart';

abstract class EntriesRepository {
  Future<Entry> findOne(String uid);
  Future<Entry> store(Entry entry);
  Future<Entry> edit(Entry entry);
  Future<bool> remove(Entry entry);
  Future<Result<Entry>> find({List<Where>? where});
}
