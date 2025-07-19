import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mal/utils.dart';

class DailySumsChart extends StatefulWidget {
  const DailySumsChart({super.key});

  final Color leftBarColor = Colors.yellow;
  final Color rightBarColor = Colors.red;
  final Color avgColor = Colors.orange;

  @override
  State<DailySumsChart> createState() => _DailySumsChartState();
}

class _DailySumsChartState extends State<DailySumsChart> {
  final double width = 7;

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DaySums>>(
      future: loadDailySums(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          return AspectRatio(
            aspectRatio: 0.3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[Text('Daily Sums')],
                  ),
                  const SizedBox(height: 38),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceBetween,
                        rotationQuarterTurns: 1,
                        maxY: 20,
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitles,
                              reservedSize: 31,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 31,
                              interval: 1,
                              getTitlesWidget: leftTitles,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: snapshot.data
                            ?.map(
                              (group) => makeGroupData(
                                int.parse(group.day),
                                group.expenses.toDouble(),
                                group.income.toDouble(),
                              ),
                            )
                            .toList(),
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        }
        return const Text('some thing else');
      },
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 19) {
      text = '10K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      meta: meta,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    // final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];
    final titles = List.generate(
      31,
      (index) => index + 1,
    ).map((i) => i.toString()).toList();

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      meta: meta,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: widget.leftBarColor, width: width),
        BarChartRodData(toY: y2, color: widget.rightBarColor, width: width),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 1.0;
    const space = 8.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withValues(alpha: 0.4),
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withValues(alpha: 1),
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}
