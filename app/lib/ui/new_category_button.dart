import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/ui/widgets/new_category.dart';

class NewCategoryButton extends StatelessWidget {
  const NewCategoryButton({super.key, required this.theme});

  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.dashboard_customize, color: theme.onPrimary),
      onPressed: () async {
        await showModalBottomSheet(
          useSafeArea: true,
          isScrollControlled: true,
          context: context,
          builder: (ctx) {
            final categoriesBloc = context.read<CategoriesBloc>();
            return BlocProvider.value(
              value: categoriesBloc,
              child: const NewCategory(),
            );
          },
        );
      },
    );
  }
}
