import 'package:flutter/material.dart';
import 'package:mal/ui/half_border_painter.dart';

class HalfBorderFab extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const HalfBorderFab({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(72, 72), // same size as FAB
          painter: HalfBorderPainter(
            color: Colors.grey.shade200,
            strokeWidth: 16,
          ),
        ),
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: FloatingActionButton(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100), // keep it circular
            ),
            onPressed: onPressed,
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: child,
          ),
        ),
      ],
    );
  }
}
