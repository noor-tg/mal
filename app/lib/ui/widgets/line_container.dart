import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mal/utils.dart';

class LineContainer extends StatelessWidget {
  const LineContainer({super.key, required this.first, required this.second});

  final List<int> first;
  final List<int> second;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            leftTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              axisNameSize: 6,
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    style: const TextStyle(fontSize: 10.0),
                    (getCurrentMonthDays().length - value.toInt()).toString(),
                  ),
                ),
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                // get first touch spot
                final first = touchedSpots.first;
                final now = DateTime.now();
                // add spot date
                final date = DateTime(
                  now.year,
                  now.month,
                  getCurrentMonthDays().length + 1 - first.x.toInt(),
                );
                final firstTooltip = LineTooltipItem(
                  '',
                  const TextStyle(),
                  children: [
                    TextSpan(
                      text: date.toIso8601String().substring(0, 10),
                      style: const TextStyle(color: Colors.lightBlue),
                    ),
                    TextSpan(
                      text: '\n${first.y.toInt().toString()}',
                      style: TextStyle(color: first.bar.color),
                    ),
                  ],
                );
                // iterate throw other spots
                final spots = touchedSpots.map((LineBarSpot touchedSpot) {
                  final textStyle = TextStyle(
                    color:
                        touchedSpot.bar.gradient?.colors.first ??
                        touchedSpot.bar.color ??
                        Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  return LineTooltipItem(
                    touchedSpot.y.toInt().toString(),
                    textStyle,
                  );
                }).toList();
                // make new list from other spots + first spot
                // remove first spot to replace it with spot with date
                spots.removeAt(0);
                // return value
                return [firstTooltip, ...spots];
              },
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 1,
          maxX: getCurrentMonthDays().length.toDouble(),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.greenAccent,
              spots: [
                for (final entry in first.reversed.toList().asMap().entries)
                  FlSpot(entry.key.toDouble() + 1, entry.value.toDouble()),
              ],
            ),
            LineChartBarData(
              isCurved: true,
              color: Colors.redAccent,
              spots: [
                for (final entry in second.reversed.toList().asMap().entries)
                  FlSpot(entry.key.toDouble() + 1, entry.value.toDouble()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
