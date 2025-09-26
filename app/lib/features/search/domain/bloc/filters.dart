import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
import 'package:mal/utils/dates.dart';

class Range<T> extends Equatable {
  final T min;
  final T max;

  const Range({required this.min, required this.max});

  @override
  List<Object?> get props => [min, max];

  @override
  String toString() => '$T(min: $min, max: $max)';
}

enum EntryType { expense, income, all }

class Filters extends Equatable {
  final List<String> categories;

  final Range<int> amountRange;
  final Range<DateTime> dateRange;

  final EntryType type;

  const Filters({
    this.categories = const [],
    this.amountRange = const Range(min: 0, max: 0),
    required this.dateRange,
    this.type = EntryType.all,
  });

  // Factory constructor for current year range
  factory Filters.withCurrentYear({
    List<String> categories = const <String>[],
    Range<int> amountRange = const Range<int>(min: 0, max: 0),
    EntryType type = EntryType.all,
  }) {
    final now = DateTime.now();
    return Filters(
      categories: categories,
      amountRange: amountRange,
      dateRange: Range<DateTime>(min: DateTime(now.year), max: todayEnd(now)),
      type: type,
    );
  }

  // Factory constructor for default empty filters
  factory Filters.empty() {
    final now = DateTime.now();
    return Filters(
      dateRange: Range<DateTime>(min: DateTime(now.year), max: todayEnd(now)),
    );
  }

  Filters copyWith({
    List<String>? categories,
    Range<int>? amountRange,
    Range<DateTime>? dateRange,
    EntryType? type,
  }) {
    return Filters(
      categories: categories ?? this.categories,
      amountRange: amountRange ?? this.amountRange,
      dateRange: dateRange ?? this.dateRange,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [categories, amountRange, dateRange, type];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Filters &&
        const ListEquality().equals(categories, other.categories) &&
        amountRange == other.amountRange &&
        dateRange == other.dateRange &&
        type == other.type;
  }

  @override
  int get hashCode => const ListEquality().hash(categories);
}
