import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/ui/widgets/category_details.dart';

class CategoriesList extends StatelessWidget {
  final List<Category> categories;

  const CategoriesList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(), // Add this line
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text(categories[index].title),
          onTap: () {
            goToDetails(context, categories[index]);
          },
        ),
      ),
    );
  }

  void goToDetails(BuildContext context, Category category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          final entriesBloc = context.read<EntriesBloc>();
          return BlocProvider.value(
            value: entriesBloc,
            child: CategoryDetails(category: category),
          );
        },
      ),
    );
  }
}
