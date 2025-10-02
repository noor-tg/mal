import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';

class EmptyCategoriesDropdown extends StatelessWidget {
  const EmptyCategoriesDropdown({
    super.key,
    required String category,
    required this.l10n,
  }) : _category = category;

  final String _category;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            validator: (value) {
              if (value == null || value == l10n.emptyCategoriesList) {
                return l10n.selectCorrectCategoryMessage;
              }
              return null;
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
            isExpanded: true,
            initialValue: _category,
            items: [
              DropdownMenuItem(
                enabled: false,
                value: l10n.emptyCategoriesList,
                child: Text(
                  l10n.emptyCategoriesList,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            ],
            onChanged: null,
          ),
        ),
      ],
    );
  }
}
