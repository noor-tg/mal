import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CategoryReport extends Equatable {
  final String title;
  final double precentage;
  final int value;
  final Color color;

  const CategoryReport({
    required this.title,
    required this.precentage,
    required this.value,
    required this.color,
  });

  @override
  List<Object?> get props => [title, precentage, value, color];

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'precentage': precentage,
      'value': value,
      'color': color,
    };
  }
}
