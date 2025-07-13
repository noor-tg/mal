import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/providers/categories_provider.dart';

class NewCategory extends ConsumerStatefulWidget {
  const NewCategory({super.key});

  @override
  ConsumerState<NewCategory> createState() => _NewCategoryState();
}

class _NewCategoryState extends ConsumerState<NewCategory> {
  String? _categoryTitle = '';
  String? _categoryType = '';
  bool typeIsValid = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.newCategory,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            TextFormField(
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return l10n.categoryTitleErrorMessage;
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _categoryTitle = value;
                });
              },
              decoration: InputDecoration(labelText: l10n.categoryTitle),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.categoryType,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Row(
              children: [
                RadioMenuButton(
                  value: l10n.expense,
                  groupValue: _categoryType,
                  onChanged: (value) {
                    setState(() {
                      _categoryType = value;
                    });
                  },
                  child: Text(l10n.expense),
                ),
                RadioMenuButton(
                  value: l10n.income,
                  groupValue: _categoryType,
                  onChanged: (value) {
                    setState(() {
                      _categoryType = value;
                    });
                  },
                  child: Text(l10n.income),
                ),
              ],
            ),
            if (!typeIsValid)
              Text(
                l10n.categoryTypeErrorMessage,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.error.withAlpha(255),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _submit(l10n);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.save),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(l10n) {
    setState(() {
      categoryTypeIsValid();
      if (_formKey.currentState!.validate() && typeIsValid) {
        _formKey.currentState!.save();
        ref
            .read(categoriesProvider.notifier)
            .addCategory(_categoryTitle!, _categoryType!);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pleaseAddCorrectInfo)));
      }
    });
  }

  void categoryTypeIsValid() {
    setState(() {
      typeIsValid = _categoryType != null && _categoryType!.trim().length > 2;
    });
  }
}
