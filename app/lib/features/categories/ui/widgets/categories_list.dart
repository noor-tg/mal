import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/utils.dart';

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
        physics: const NeverScrollableScrollPhysics(), // Add this line
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];
          return Dismissible(
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.red,
              ),
              child: Row(
                children: [
                  const Icon(Icons.cancel, color: Colors.white),
                  box8,
                  Text(
                    AppLocalizations.of(context)!.remove,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            onDismissed: (direction) {
              onRemove(category.uid);
            },
            // Only allows right-to-left dismissal
            direction: DismissDirection.startToEnd,
            key: ValueKey(category.uid),
            child: ListTile(title: Text(category.title)),
          );
        },
      ),
    );
  }
}
