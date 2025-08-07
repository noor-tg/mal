import 'package:equatable/equatable.dart';

class Result<T> extends Equatable {
  final List<T> list;
  final int count;

  const Result({required this.list, required this.count});

  @override
  List<Object?> get props => [list, count];

  @override
  String toString() {
    return 'Result(list: ${list.isNotEmpty ? list.sublist(0, list.length >= 3 ? 3 : list.length) : []}, count: $count), list length: ${list.length}';
  }
}
