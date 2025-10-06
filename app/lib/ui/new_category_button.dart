import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/categories/ui/widgets/category_form.dart';
import 'package:mal/utils.dart';

class NewCategoryButton extends StatelessWidget {
  const NewCategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      tooltip: context.l10n.newCategory,
      color: context.colors.primary,
      icon: const Icon(Icons.edit_document, size: 40),
      onPressed: () async {
        await openCategoryModal(context);
      },
    );
  }

  Future<void> openCategoryModal(BuildContext context) async {
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
            child: const CategoryForm(),
          ),
        );
      },
    );
  }
}
