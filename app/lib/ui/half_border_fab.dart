import 'package:flutter/material.dart';
import 'package:mal/ui/half_border_painter.dart';
import 'package:mal/utils.dart';

class HalfBorderFab extends StatelessWidget {
  final Widget child;

  const HalfBorderFab({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(72, 72), // same size as FAB
          painter: HalfBorderPainter(
            color: context.colors.surfaceContainerLow,
            strokeWidth: 16,
          ),
        ),
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            // color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: child,
        ),
      ],
    );
  }
}
