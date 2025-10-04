import 'package:flutter/material.dart';
import 'package:mal/utils.dart';

class MalPageContainer extends StatelessWidget {
  const MalPageContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(color: context.colors.surfaceContainer),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: SingleChildScrollView(child: child),
    );
  }
}
