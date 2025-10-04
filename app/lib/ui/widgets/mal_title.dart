import 'package:flutter/material.dart';
import 'package:mal/utils.dart';

class MalTitle extends StatelessWidget {
  const MalTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.texts.headlineMedium?.copyWith(
        color: context.colors.onSurfaceVariant,
      ),
    );
  }
}
