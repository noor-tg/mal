import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

class Filters extends Equatable {
  final List<String> categories;

  const Filters({this.categories = const []});

  Filters copyWith({List<String>? categories}) {
    return Filters(categories: categories ?? this.categories);
  }

  @override
  List<Object?> get props => [categories];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Filters &&
        const ListEquality().equals(categories, other.categories);
  }

  @override
  int get hashCode => const ListEquality().hash(categories);
}
