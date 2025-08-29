import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/ui/widgets/categories_list.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/screens/mal_page_container.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    context.read<CategoriesBloc>().add(AppInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final emptyList = Center(
      child: Card.filled(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(AppLocalizations.of(context)!.emptyCategoriesList),
        ),
      ),
    );
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (ctx, state) {
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
              state.expenses.isEmpty
                  ? emptyList
                  : CategoriesList(
                      categories: state.expenses,
                      onRemove: removeCategory,
                    ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.income,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              state.income.isEmpty
                  ? emptyList
                  : CategoriesList(
                      categories: state.income,
                      onRemove: removeCategory,
                    ),
            ],
          ),
        );
      },
    );
  }

  void removeCategory(String uid) {
    context.read<CategoriesBloc>().add(RemoveCategory(uid));
  }
}
