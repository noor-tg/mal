import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/constants.dart';
import 'package:mal/features/search/domain/bloc/search_bloc.dart';
import 'package:mal/features/search/ui/views/amount_range_filter.dart';
import 'package:mal/features/search/ui/views/categories_filter.dart';
import 'package:mal/features/search/ui/views/date_range_filter.dart';
import 'package:mal/features/search/ui/views/sorting.dart';
import 'package:mal/features/search/ui/views/type_filter.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';

class AdvancedSearch extends StatelessWidget {
  const AdvancedSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurStyle: BlurStyle.outer,
                blurRadius: 8,
              ),
            ],
          ),
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (BuildContext ctx, state) => Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is! AuthAuthenticated) return;
                    context.read<SearchBloc>().add(
                      ApplyFilters(userUid: authState.user.uid),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    l10n.search,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      l10n.advancedSearch,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<SearchBloc>().add(ClearFilters());
                    Navigator.pop(context);
                  },
                  child: Text(
                    l10n.reset,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: kBgColor,
        // padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CategoriesFilter(l10n: l10n, theme: theme),
              AmountRangeFilter(l10n: l10n, theme: theme),
              DateRangeFilter(l10n: l10n, theme: theme),
              TypeFilter(l10n: l10n, theme: theme),
              Sorting(l10n: l10n, theme: theme),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
