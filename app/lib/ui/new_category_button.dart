import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/ui/widgets/new_category.dart';
import 'package:mal/l10n/app_localizations.dart';

class NewCategoryButton extends StatelessWidget {
  const NewCategoryButton({super.key, required this.theme});

  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      tooltip: AppLocalizations.of(context)?.newCategory,
      icon: Icon(Icons.dashboard_customize, color: theme.primary),
      onPressed: () async {
        await showModalBottomSheet(
          useSafeArea: true,
          isScrollControlled: true,
          context: context,
          builder: (ctx) {
            final categoriesBloc = context.read<CategoriesBloc>();
            return BlocProvider.value(
              value: categoriesBloc,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.90,
                child: const NewCategory(),
              ),
            );
          },
        );
      },
    );
  }
}
