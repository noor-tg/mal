import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mal/utils.dart';

class Entry extends Equatable {
  Entry({
    required this.description,
    required this.amount,
    required this.category,
    required this.type,
    String? date,
    String? uid,
  }) : uid = uid ?? uuid.v4(),
       date = date ?? DateTime.now().toIso8601String();

  final String uid;
  final String description;
  final String date;
  final int amount;
  final String category;
  final String type;

  String prefixedAmount(String incomeL10n) =>
      '${moneyFormat(amount).toString()} ${type == incomeL10n ? "+" : "-"}';

  Color color(String incomeL10n) =>
      type == incomeL10n ? Colors.green : Colors.red;

  @override
  List<Object?> get props => [uid, description, date, amount, category, type];

  static Entry fromMap(Map<String, dynamic> map) {
    return Entry(
      uid: map['uid'] as String,
      description: map['description'] as String,
      amount: map['amount'] as int,
      category: map['category'] as String,
      type: map['type'] as String,
      date: map['date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'description': description,
      'amount': amount,
      'category': category,
      'type': type,
      'date': date,
    };
  }

  Entry copyWith({
    String? uid,
    String? description,
    int? amount,
    String? category,
    String? type,
    String? date,
  }) {
    return Entry(
      uid: uid ?? this.uid,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }
}
