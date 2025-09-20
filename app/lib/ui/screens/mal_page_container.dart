import 'package:flutter/material.dart';
import 'package:mal/constants.dart';

class MalPageContainer extends StatelessWidget {
  const MalPageContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kBgColor),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: SingleChildScrollView(child: child),
    );
  }
}
