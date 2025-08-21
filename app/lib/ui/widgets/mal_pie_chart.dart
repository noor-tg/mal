import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mal/ui/widgets/indicator.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                centerSpaceRadius: 30,
                sections: showingSections(),
              ),
            ),
          ),
          box24,
          for (final item in widget.list)
            Row(
              children: [
                Indicator(
                  color: item['color'],
                  text: "${item['title']} - ${item['value']}",
                  isSquare: true,
                ),
                const SizedBox(height: 4),
              ],
            ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final List<PieChartSectionData> pieData = [];
    for (final item in widget.list) {
      final isTouched = item['title'] == touchedTitle;
      final fontSize = isTouched ? 25.0 : 12.0;
      final radius = isTouched ? 60.0 : 40.0;
      const shadows = [Shadow(blurRadius: 2)];
      pieData.add(
        PieChartSectionData(
          color: item['color'],
          value: item['precentage'],
          title: '${item["precentage"].toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        ),
      );
    }
    return pieData;
  }
}
