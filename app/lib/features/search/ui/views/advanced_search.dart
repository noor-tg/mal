import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/ui/views/amount_range_filter.dart';
import 'package:mal/features/search/ui/views/categories_filter.dart';
import 'package:mal/features/search/ui/views/date_range_filter.dart';
import 'package:mal/features/search/ui/views/sorting.dart';
import 'package:mal/features/search/ui/views/type_filter.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/utils.dart';

class AdvancedSearch extends StatelessWidget {
  const AdvancedSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: context.colors.surfaceBright),
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (BuildContext ctx, state) => Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                  ),
                  onPressed: () {
                    applySearch(context);
                  },
                  child: Text(
                    context.l10n.search,
                    style: context.texts.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.onPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      context.l10n.advancedSearch,
                      style: context.texts.headlineLarge?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: context.colors.secondaryContainer,
                  ),
                  onPressed: () {
                    clearFilters(context);
                  },
                  child: Text(
                    context.l10n.reset,
                    style: context.texts.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(2),
        color: context.colors.surfaceContainer,
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CategoriesFilter(),
              AmountRangeFilter(),
              DateRangeFilter(),
              TypeFilter(),
              Sorting(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void clearFilters(BuildContext context) {
    context.read<SearchBloc>().add(ClearFilters());
    Navigator.pop(context);
  }

  void applySearch(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;
    context.read<SearchBloc>().add(ApplyFilters(userUid: authState.user.uid));
    Navigator.pop(context);
  }
}
