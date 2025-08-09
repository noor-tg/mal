import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

class Range<T> extends Equatable {
  final T min;
  final T max;

  const Range({required this.min, required this.max});

  @override
  List<Object?> get props => [min, max];
}

class Filters extends Equatable {
  final List<String> categories;

  final Range<int> amountRange;
  final Range<DateTime> dateRange;

  const Filters({
    this.categories = const [],
    this.amountRange = const Range(min: 0, max: 0),
    required this.dateRange,
  });

  // Factory constructor for current year range
  factory Filters.withCurrentYear({
    List<String> categories = const <String>[],
    Range<int> amountRange = const Range<int>(min: 0, max: 0),
  }) {
    final now = DateTime.now();
    return Filters(
      categories: categories,
      amountRange: amountRange,
      dateRange: Range<DateTime>(
        min: DateTime(now.year),
        max: DateTime(now.year, now.month, now.day),
      ),
    );
  }

  // Factory constructor for default empty filters
  factory Filters.empty() {
    final now = DateTime.now();
    return Filters(
      dateRange: Range<DateTime>(
        min: DateTime(now.year),
        max: DateTime(now.year, now.month, now.day),
      ),
    );
  }

  Filters copyWith({
    List<String>? categories,
    Range<int>? amountRange,
    Range<DateTime>? dateRange,
  }) {
    return Filters(
      categories: categories ?? this.categories,
      amountRange: amountRange ?? this.amountRange,
      dateRange: dateRange ?? this.dateRange,
    );
  }

  @override
  List<Object?> get props => [categories, amountRange, dateRange];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Filters &&
        const ListEquality().equals(categories, other.categories) &&
        amountRange == other.amountRange &&
        dateRange == other.dateRange;
  }

  @override
  int get hashCode => const ListEquality().hash(categories);
}
