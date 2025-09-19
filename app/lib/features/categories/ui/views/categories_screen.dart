import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/ui/widgets/categories_list.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/utils.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;
    context.read<CategoriesBloc>().add(AppInit(authState.user.uid));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final titleStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600);

    return BlocBuilder<CategoriesBloc, CategoriesState>(
      buildWhen: (prev, current) => prev.categories != current.categories,
      builder: (ctx, state) => MalPageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.expenses, style: titleStyle),
            box8,
            buildList(state.expenses, l10n),
            box16,
            Text(l10n.income, style: titleStyle),
            box8,
            buildList(state.income, l10n),
          ],
        ),
      ),
    );
  }

  Widget buildList(List<Category> list, AppLocalizations l10n) {
    return list.isEmpty
        ? buildCenter(l10n)
        : CategoriesList(categories: list, onRemove: removeCategory);
  }

  Center buildCenter(AppLocalizations l10n) {
    return Center(
      child: Card.filled(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l10n.emptyCategoriesList),
        ),
      ),
    );
  }

  void removeCategory(String uid) {
    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthAuthenticated) return;
    context.read<CategoriesBloc>().add(RemoveCategory(uid, authState.user.uid));
  }
}
