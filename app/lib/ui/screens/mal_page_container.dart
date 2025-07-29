import 'package:flutter/material.dart';

class MalPageContainer extends StatelessWidget {
  const MalPageContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.withAlpha(50)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SingleChildScrollView(child: child),
    );
  }
}
