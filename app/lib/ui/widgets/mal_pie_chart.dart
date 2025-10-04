import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mal/utils.dart';

class MalPieChart extends StatefulWidget {
  const MalPieChart({super.key, required this.list});

  final List<Map<String, dynamic>> list;

  @override
  State<StatefulWidget> createState() => _MalPieChartState();
}

class _MalPieChartState extends State<MalPieChart> {
  String touchedTitle = '';

  @override
  Widget build(BuildContext context) {
    final pieItemStyle = texts.titleMedium?.copyWith(color: colors.onSurface);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          box8,
          AspectRatio(
            aspectRatio: 2,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedTitle = '';
                        return;
                      }
                      touchedTitle =
                          pieTouchResponse
                              .touchedSection
                              ?.touchedSection
                              ?.title ??
                          '';
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 44,
                sections: showingSections(),
              ),
            ),
          ),
          box32,
          box8,
          for (final item in widget.list)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(color: item['color'], width: 16, height: 16),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item['title'].length > 13
                          ? item['title'].substring(0, 14)
                          : item['title'],
                      style: pieItemStyle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      moneyFormat(item['value']),
                      style: pieItemStyle,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final List<PieChartSectionData> pieData = [];
    for (final item in widget.list) {
      final isTouched = item['title'] == touchedTitle;
      final fontSize = isTouched ? 25.0 : 18.0;
      final radius = isTouched ? 68.0 : 60.0;
      final shadows = [Shadow(blurRadius: 8, color: colors.onSurface)];
      pieData.add(
        PieChartSectionData(
          color: item['color'],
          value: item['precentage'],
          title: '${item["precentage"].toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: colors.surface,
            shadows: shadows,
          ),
        ),
      );
    }
    return pieData;
  }
}
