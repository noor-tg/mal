import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kSearchLimit = 10;
const kAvatarPath = 'assets/avatar.png';

const incomeType = 'دخل';
const expenseType = 'منصرف';
final types = [expenseType, incomeType];

final transactionsSeeds = {
  DateTime(2025, 8, 30): [
    Transaction(
      id: '1',
      title: 'Salary',
      amount: 5000,
      isIncome: true,
      category: 'Job',
    ),
    Transaction(
      id: '2',
      title: 'Groceries',
      amount: -150,
      isIncome: false,
      category: 'Food',
    ),
  ],
  DateTime(2025, 8, 26): [
    Transaction(
      id: '3',
      title: 'Coffee',
      amount: -25,
      isIncome: false,
      category: 'Food',
    ),
    Transaction(
      id: '4',
      title: 'Gas',
      amount: -80,
      isIncome: false,
      category: 'Transport',
    ),
  ],
  DateTime(2025, 8, 29): [
    Transaction(
      id: '5',
      title: 'Freelance',
      amount: 800,
      isIncome: true,
      category: 'Freelance',
    ),
  ],
  DateTime(2025, 8, 28): [
    Transaction(
      id: '6',
      title: 'Rent',
      amount: -420000,
      isIncome: false,
      category: 'Housing',
    ),
    Transaction(
      id: '7',
      title: 'Utilities',
      amount: -300000,
      isIncome: false,
      category: 'Housing',
    ),
  ],
  DateTime(2025, 8, 27): [
    Transaction(
      id: '8',
      title: 'Dividend',
      amount: 5000000,
      isIncome: true,
      category: 'Investment',
    ),
    Transaction(
      id: '9',
      title: 'Restaurant',
      amount: -60,
      isIncome: false,
      category: 'Food',
    ),
  ],
};

class Transaction {
  final String id;
  final String title;
  final double amount;
  final bool isIncome;
  final String category;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.category,
  });
}

String approximate(int amount) {
  if (amount >= 1000000) {
    return '${(amount / 1000000).floor().truncate()} مـ';
  }
  if (amount >= 10000) {
    return '${(amount / 1000).floor().toInt()} أ';
  }
  return '$amount';
}

final colorScheme = ColorScheme.fromSeed(
  // brightness: Brightness.light,
  seedColor: Colors.purpleAccent,
  surface: Colors.white,
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.cairoTextTheme().copyWith(
    titleSmall: GoogleFonts.cairo(fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.cairo(fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.cairo(fontWeight: FontWeight.bold),
  ),
);
