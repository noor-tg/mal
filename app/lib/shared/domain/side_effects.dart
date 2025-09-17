import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/reports/domain/bloc/categories_report/categories_report_bloc.dart';
import 'package:mal/features/reports/domain/bloc/daily_sums/daily_sums_bloc.dart';
import 'package:mal/features/reports/domain/bloc/totals/totals_bloc.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';

void reloadReportsData(BuildContext context) {
  final authState = context.read<AuthBloc>().state;

  if (authState is! AuthAuthenticated) return;

  context.read<EntriesBloc>().add(LoadTodayEntries(authState.user.uid));
  context.read<TotalsBloc>().add(RequestTotalsData(authState.user.uid));
  context.read<DailySumsBloc>().add(RequestDailySumsData(authState.user.uid));
  context.read<CategoriesReportBloc>().add(
    RequestIncomesPieReportData(authState.user.uid),
  );
  context.read<CategoriesReportBloc>().add(
    RequestExpensesPieReportData(authState.user.uid),
  );
}
