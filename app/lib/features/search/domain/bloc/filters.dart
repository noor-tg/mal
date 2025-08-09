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

  const Filters({
    this.categories = const [],
    this.amountRange = const Range<int>(min: 0, max: 0),
  });

  Filters copyWith({List<String>? categories, Range<int>? amountRange}) {
    return Filters(
      categories: categories ?? this.categories,
      amountRange: amountRange ?? this.amountRange,
    );
  }

  @override
  List<Object?> get props => [categories, amountRange];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Filters &&
        const ListEquality().equals(categories, other.categories) &&
        amountRange == other.amountRange;
  }

  @override
  int get hashCode => const ListEquality().hash(categories);
}
