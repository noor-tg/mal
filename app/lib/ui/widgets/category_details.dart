import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/ui/widgets/entries_list.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';
import 'package:mal/utils.dart';

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({super.key, required this.category});

  final Category category;

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  late Category category;

  @override
  void initState() {
    super.initState();
    category = widget.category;
    context.read<EntriesBloc>().add(
      LoadCategoryEntries(
        (context.read<AuthBloc>().state as AuthAuthenticated).user.uid,
        widget.category.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntriesBloc, EntriesState>(
      builder: (ctx, state) => Scaffold(
        appBar: AppBar(
          title: Row(
            spacing: 12,
            children: [
              Text(category.title),
              Text(
                state.currentCategory.count.toString(),
                style: TextStyle(
                  color: colors.onSecondaryContainer.withAlpha(150),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: colors.surfaceContainer,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.currentCategory.list.isEmpty)
                  const Card(child: NoDataCentered()),
                if (state.currentCategory.list.isNotEmpty)
                  EntriesList(
                    entries: state.currentCategory.list,
                    showCategory: false,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
