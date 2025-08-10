import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/data/models/category.dart';

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
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) => Dismissible(
          background: Card.filled(
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.cancel, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.remove,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onDismissed: (direction) {
            _removeItem(categories[index].uid);
          },
          key: ValueKey(categories[index].uid),
          child: ListTile(title: Text(categories[index].title)),
        ),
      ),
    );
  }

  void _removeItem(String uid) {
    onRemove(uid);
  }
}
