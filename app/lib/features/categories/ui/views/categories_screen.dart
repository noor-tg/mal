import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/ui/widgets/categories_list.dart';
import 'package:mal/features/tour/domain/showcase_cubit.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/ui/screens/mal_page_container.dart';
import 'package:mal/utils.dart';
import 'package:showcaseview/showcaseview.dart';

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
    final titleStyle = texts.titleLarge?.copyWith(color: colors.onSurface);
    final showcaseState = context.watch<ShowcaseCubit>().state;

    return BlocBuilder<CategoriesBloc, CategoriesState>(
      buildWhen: (prev, current) => prev.categories != current.categories,
      builder: (ctx, state) => MalPageContainer(
        child: Showcase(
          key: showcaseState.keys.categoriesList,
          description: l10n.showCaseDescriptionCategoryList,
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
              box64,
            ],
          ),
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
      child: Card(
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
