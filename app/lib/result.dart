import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

class Result<T> extends Equatable {
  final List<T> list;
  final int count;

  const Result({required this.list, required this.count});

  @override
  List<Object?> get props => [list, count];

  @override
  String toString() {
    return 'Result(list: $list, count: $count)';
  }
}
