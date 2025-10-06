import 'package:flutter/material.dart';
import 'package:mal/constants.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/widgets/field_label.dart';

class TypeField extends StatefulWidget {
  const TypeField({super.key, required this.onPressed, required this.type});

  final void Function(String? value) onPressed;
  final String type;

  @override
  State<TypeField> createState() => _TypeFieldState();
}

class _TypeFieldState extends State<TypeField> {
  String selectedType = '';
  @override
  Widget build(BuildContext context) {
    if (selectedType == '') selectedType = widget.type;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(text: l10n.categoryType),
        FormField<String>(
          initialValue: selectedType,
          validator: (value) {
            if (value == null || value == '') {
              return l10n.categoryTypeErrorMessage;
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioGroup(
                  groupValue: selectedType,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      selectedType = value;
                    });
                    widget.onPressed(value);
                    state.didChange(value);
                  },
                  child: Column(
                    children: [
                      RadioListTile(
                        value: expenseType,
                        title: Text(l10n.expense),
                      ),
                      RadioListTile(
                        value: incomeType,
                        title: Text(l10n.income),
                      ),
                    ],
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
