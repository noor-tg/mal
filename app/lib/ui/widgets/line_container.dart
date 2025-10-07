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
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50, // Adjust based on your number size
                getTitlesWidget: (value, meta) {
                  // Customize your formatting here
                  String text;
                  if (value >= 1000000) {
                    text =
                        '${(value / 1000000).toStringAsFixed(0)} ${context.l10n.million}';
                  } else if (value >= 1000) {
                    text =
                        '${(value / 1000).toStringAsFixed(0)} ${context.l10n.thousand}';
                  } else {
                    text = value.toInt().toString();
                  }

                  return Text(
                    text,
                    style: context.texts.bodyLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameSize: 6,
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    style: const TextStyle(fontSize: 10.0),
                    (getCurrentMonthDays().length - value.toInt() + 1)
                        .toString(),
                  ),
                ),
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (group) => Colors.blueGrey[800]!,
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
                      text: toDate(date),
                      style: TextStyle(
                        color: Colors.lightBlue[200],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\n${moneyFormat(first.y.toInt())}',
                      style: TextStyle(
                        color: context.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
                // iterate throw other spots
                final spots = touchedSpots.map((LineBarSpot touchedSpot) {
                  final textStyle = TextStyle(
                    color: context.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  return LineTooltipItem(
                    moneyFormat(touchedSpot.y.toInt()),
                    textStyle,
                  );
                }).toList();
                // remove first spot to replace it with spot with date
                // ignore: cascade_invocations
                spots.removeAt(0);
                // make new list from other spots + first spot
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
              preventCurveOverShooting: true,
              isCurved: true,
              color: context.green,
              spots: [
                for (final entry in first.reversed.toList().asMap().entries)
                  FlSpot(entry.key.toDouble() + 1, entry.value.toDouble()),
              ],
            ),
            LineChartBarData(
              isCurved: true,
              preventCurveOverShooting: true,
              color: context.red,
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
