import 'package:flutter/material.dart';
import 'package:mal/providers/categories_provider.dart';
import 'package:mal/ui/widgets/mal_pie_chart.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';

class PieChartLoader extends StatelessWidget {
  final String type;

  const PieChartLoader({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Colors.white,
      child: FutureBuilder(
        future: getPieData(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
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
            return const NoDataCentered();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Center(child: MalPieChart(list: snapshot.data!)),
          );
        },
      ),
    );
  }
}
