import 'package:flutter/material.dart';
import 'package:mal/utils.dart';

class EmptyCategoriesDropdown extends StatelessWidget {
  const EmptyCategoriesDropdown({super.key, required String category})
    : _category = category;

  final String _category;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            validator: (value) {
              if (value == null || value == context.l10n.emptyCategoriesList) {
                return context.l10n.selectCorrectCategoryMessage;
              }
              return null;
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
            isExpanded: true,
            initialValue: _category,
            items: [
              DropdownMenuItem(
                enabled: false,
                value: context.l10n.emptyCategoriesList,
                child: Text(
                  context.l10n.emptyCategoriesList,
                  style: TextStyle(color: context.colors.onSurface),
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
