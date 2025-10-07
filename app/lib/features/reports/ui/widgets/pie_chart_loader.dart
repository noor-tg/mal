import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/constants.dart';
import 'package:mal/enums.dart';
import 'package:mal/features/reports/domain/bloc/categories_report/categories_report_bloc.dart';
import 'package:mal/features/reports/domain/entities/category_report.dart';
import 'package:mal/ui/widgets/mal_pie_chart.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';
import 'package:mal/utils.dart';

class PieChartLoader extends StatelessWidget {
  final String type;

  const PieChartLoader({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: BlocBuilder<CategoriesReportBloc, CategoriesReportState>(
        builder: (context, state) {
          if (state.status == BlocStatus.loading) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.status == BlocStatus.failure) {
            return Center(
              child: Text(
                'Error loading data: ${state.errorMessage}',
                style: TextStyle(color: context.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (type == incomeType && state.incomesData.isEmpty) {
            return const NoDataCentered();
          }

          if (type == expenseType && state.expensesData.isEmpty) {
            return const NoDataCentered();
          }

          late List<CategoryReport> data;
          if (type == incomeType) {
            data = state.incomesData;
          } else {
            data = state.expensesData;
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: MalPieChart(list: data.map((row) => row.toMap()).toList()),
            ),
          );
        },
      ),
    );
  }
}
