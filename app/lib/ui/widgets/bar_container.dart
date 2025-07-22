import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarContainer extends StatelessWidget {
  const BarContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random(10);
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(),
            topTitles: AxisTitles(),
          ),
          barGroups: [
            for (final i in [1, 2, 3, 4, 5, 6, 7])
              BarChartGroupData(
                x: i,
                barsSpace: 3,
                barRods: [
                  BarChartRodData(
                    borderDashArray: [1, 2],
                    color: Colors.greenAccent,
                    toY: random.nextInt(100).toDouble(),
                  ),
                  BarChartRodData(
                    color: Colors.redAccent,
                    toY: random.nextInt(100).toDouble(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
