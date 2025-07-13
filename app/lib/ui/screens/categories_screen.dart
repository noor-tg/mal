import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/providers/categories_provider.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/ui/widgets/categories_list.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(categoriesProvider.notifier).loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final expenses = categories['expenses'];
    final income = categories['income'];

    final emptyList = Center(
      child: Card.filled(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(AppLocalizations.of(context)!.emptyCategoriesList),
        ),
      ),
    );
    Widget expensesCategories = emptyList;

    if (expenses != null && expenses.isNotEmpty) {
      expensesCategories = CategoriesList(
        categories: expenses,
        onRemove: removeCategory,
      );
    }

    Widget incomeCategories = emptyList;

    if (income != null && income.isNotEmpty) {
      incomeCategories = CategoriesList(
        categories: income,
        onRemove: removeCategory,
      );
    }

    return MalPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.expenses,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          expensesCategories,
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.income,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          incomeCategories,
        ],
      ),
    );
  }

  void removeCategory(String uid) {
    ref.read(categoriesProvider.notifier).removeCategory(uid);
  }
}
