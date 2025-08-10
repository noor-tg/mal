import 'package:equatable/equatable.dart';

enum SortingField { date, amount, category, description, type }

enum SortingDirection { asc, desc }

class Sorting extends Equatable {
  final SortingField field;
  final SortingDirection direction;

  const Sorting({
    this.field = SortingField.date,
    this.direction = SortingDirection.desc,
  });

  @override
  List<Object?> get props => [field, direction];

  Sorting copyWith({SortingField? field, SortingDirection? direction}) {
    return Sorting(
      field: field ?? this.field,
      direction: direction ?? this.direction,
    );
  }
}
