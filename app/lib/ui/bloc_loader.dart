import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/calendar/data/repositories/sql_repository.dart'
    as calendar;
import 'package:mal/features/calendar/domain/bloc/calendar_bloc.dart';
import 'package:mal/features/categories/data/repositories/sql_repository.dart'
    as categories;
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/domain/repositories/categories_repository.dart';
import 'package:mal/features/entries/data/repositories/sql_repository.dart'
    as entries;
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/reports/data/repositories/sql_repository.dart'
    as reports;
import 'package:mal/features/reports/domain/bloc/categories_report/categories_report_bloc.dart';
import 'package:mal/features/reports/domain/bloc/daily_sums/daily_sums_bloc.dart';
import 'package:mal/features/reports/domain/bloc/totals/totals_bloc.dart';
import 'package:mal/features/tour/domain/showcase_cubit.dart';
import 'package:mal/features/user/data/repositories/sql_repository.dart'
    as user;
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/domain/bloc/exporter/exporter_bloc.dart';
import 'package:mal/shared/domain/bloc/theme/theme_bloc.dart';

class BlocLoader extends StatelessWidget {
  final Widget child;
  const BlocLoader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoriesRepository>(
          create: (_) => categories.SqlRepository(),
        ),
        RepositoryProvider(
          create: (_) {
            return entries.SqlRepository();
          },
        ),
        RepositoryProvider(
          create: (_) {
            return reports.SqlRepository();
          },
        ),
        RepositoryProvider(
          create: (_) {
            return calendar.SqlRepository();
          },
        ),
        RepositoryProvider(
          create: (_) {
            return user.SqlRepository();
          },
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ShowcaseCubit()),
          BlocProvider<CategoriesBloc>(
            create: (ctx) =>
                CategoriesBloc(repo: ctx.read<CategoriesRepository>()),
          ),
          BlocProvider<EntriesBloc>(
            create: (ctx) =>
                EntriesBloc(repo: ctx.read<entries.SqlRepository>()),
          ),
          BlocProvider(
            create: (ctx) =>
                TotalsBloc(repo: ctx.read<reports.SqlRepository>()),
          ),
          BlocProvider(
            create: (ctx) =>
                DailySumsBloc(repo: ctx.read<reports.SqlRepository>()),
          ),
          BlocProvider(
            create: (ctx) =>
                CategoriesReportBloc(repo: ctx.read<reports.SqlRepository>()),
          ),
          BlocProvider(
            create: (ctx) =>
                CalendarBloc(repo: ctx.read<calendar.SqlRepository>()),
          ),
          BlocProvider(create: (ctx) => ExporterBloc()),
          BlocProvider(create: (ctx) => ThemeBloc()),
          BlocProvider(
            create: (ctx) =>
                AuthBloc(repo: ctx.read<user.SqlRepository>())
                  ..add(const AuthCheckStatusRequested()),
          ),
        ],
        child: child,
      ),
    );
  }
}
