import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mal/utils.dart';

class DailySumsChart extends StatelessWidget {
  const DailySumsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DaySums>>(
      future: loadDailySums(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading data: ${snapshot.error.toString()}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No data available', style: TextStyle(fontSize: 16)),
          );
        }

        return const Padding(
          padding: EdgeInsets.all(24),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: LineContainer(),
          ),
        );
      },
    );
  }
}

class LineContainer extends StatelessWidget {
  const LineContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random(10);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AspectRatio(
        aspectRatio: 1.7,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              leftTitles: const AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) =>
                      Text((8 - value.toInt()).toString()), // Flip X labels
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 1,
            maxX: 7,
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: Colors.greenAccent,
                spots: [
                  for (final j in [1, 2, 3, 4, 5, 6, 7].reversed)
                    FlSpot(j.toDouble(), random.nextInt(j * 10).toDouble()),
                ],
              ),
              LineChartBarData(
                isCurved: true,
                color: Colors.redAccent,
                spots: [
                  for (final j in [1, 2, 3, 4, 5, 6, 7].reversed)
                    FlSpot(j.toDouble(), random.nextInt(j * 10).toDouble()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class LineContainer extends StatelessWidget {
//   const LineContainer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final random = Random(10);
//     return AspectRatio(
//       aspectRatio: 1.7,
//       child: LineChart(
//         LineChartData(
//           gridData: const FlGridData(show: false),
//           titlesData: const FlTitlesData(
//             topTitles: AxisTitles(),
//             leftTitles: AxisTitles(),
//           ),
//           borderData: FlBorderData(show: false),
//           lineBarsData: [
//             LineChartBarData(
//               isCurved: true,
//               color: Colors.greenAccent,
//               spots: [
//                 for (final j in [1, 2, 3, 4, 5, 6, 7])
//                   FlSpot(j.toDouble(), random.nextInt(j * 10).toDouble()),
//               ],
//             ),
//             LineChartBarData(
//               isCurved: true,
//               color: Colors.redAccent,
//               spots: [
//                 for (final j in [1, 2, 3, 4, 5, 6, 7])
//                   FlSpot(j.toDouble(), random.nextInt(j * 10).toDouble()),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BarContainer extends StatelessWidget {
//   const BarContainer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final random = Random(10);
//     return AspectRatio(
//       aspectRatio: 2,
//       child: BarChart(
//         BarChartData(
//           borderData: FlBorderData(show: false),
//           titlesData: const FlTitlesData(
//             leftTitles: AxisTitles(),
//             topTitles: AxisTitles(),
//           ),
//           barGroups: [
//             for (final i in [1, 2, 3, 4, 5, 6, 7])
//               BarChartGroupData(
//                 x: i,
//                 barsSpace: 3,
//                 barRods: [
//                   BarChartRodData(
//                     borderDashArray: [1, 2],
//                     color: Colors.greenAccent,
//                     toY: random.nextInt(100).toDouble(),
//                   ),
//                   BarChartRodData(
//                     color: Colors.redAccent,
//                     toY: random.nextInt(100).toDouble(),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
