import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/ui/views/amount_range_filter.dart';
import 'package:mal/features/search/ui/views/categories_filter.dart';
import 'package:mal/features/search/ui/views/date_range_filter.dart';
import 'package:mal/features/search/ui/views/sorting.dart';
import 'package:mal/features/search/ui/views/type_filter.dart';
import 'package:mal/l10n/app_localizations.dart';

class AdvancedSearch extends StatelessWidget {
  const AdvancedSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card.filled(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      l10n.advancedSearch,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CategoriesFilter(l10n: l10n, theme: theme),
            AmountRangeFilter(l10n: l10n, theme: theme),
            DateRangeFilter(l10n: l10n, theme: theme),
            TypeFilter(l10n: l10n, theme: theme),
            Sorting(l10n: l10n, theme: theme),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (BuildContext ctx, state) => ElevatedButton(
                  onPressed: () {
                    context.read<SearchBloc>().add(ApplyFilters());
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.search,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (BuildContext ctx, state) => TextButton(
                  onPressed: () {
                    context.read<SearchBloc>().add(ClearFilters());
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.reset,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
