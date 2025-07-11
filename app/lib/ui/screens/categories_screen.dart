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
  late Future<void> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ref.read(categoriesProvider.notifier).loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    var l10n = AppLocalizations.of(context)!;

    Widget body = FutureBuilder(
      future: _categoriesFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
          ? const CircularProgressIndicator()
          : CategoriesList(categories: categories),
    );
    if (categories.isEmpty) {
      body = Center(child: Text(l10n.emptyCategoriesList));
    }
    return MalPageContainer(
      child: Column(
        children: [
          Card.filled(
            color: Colors.white,
            child: Padding(padding: const EdgeInsets.all(16), child: body),
          ),
        ],
      ),
    );
  }
}

class CategoriesList extends StatelessWidget {
  final List<Category> categories;

  const CategoriesList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: categories
          .map(
            (category) => Container(
              padding: EdgeInsets.only(right: 8, top: 8),
              child: OutlinedButton(
                onPressed: () {},
                child: Text(category.title),
              ),
            ),
          )
          .toList(),
    );
  }
}
