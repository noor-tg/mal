import 'package:flutter/material.dart';

class MalTitle extends StatelessWidget {
  const MalTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(color: Colors.grey.shade600),
    );
  }
}
