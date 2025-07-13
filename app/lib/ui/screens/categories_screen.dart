import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/models/category.dart';
import 'package:mal/providers/categories_provider.dart';
import 'package:mal/ui/screens/mal_page_container.dart';

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

    var emptyList = Center(
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
          SizedBox(height: 8),
          expensesCategories,
          SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.income,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
          ),
          SizedBox(height: 8),
          incomeCategories,
        ],
      ),
    );
  }

  void removeCategory(String uid) {
    ref.read(categoriesProvider.notifier).removeCategory(uid);
  }
}

class CategoriesList extends StatelessWidget {
  final List<Category> categories;

  const CategoriesList({
    super.key,
    required this.categories,
    required this.onRemove,
  });

  final void Function(String uid) onRemove;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) => Dismissible(
          background: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.remove,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onDismissed: (direction) {
            _removeItem(categories[index].uid);
          },
          key: ValueKey(categories[index].uid),
          child: ListTile(title: Text(categories[index].title)),
        ),
      ),
    );
  }

  void _removeItem(String uid) {
    onRemove(uid);
  }
}
