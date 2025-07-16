import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/models/category.dart';
import 'package:mal/providers/categories_provider.dart';
import 'package:mal/providers/entries_provider.dart';
import 'package:mal/ui/widgets/date_selector.dart';

class NewEntry extends ConsumerStatefulWidget {
  const NewEntry({super.key});

  @override
  ConsumerState<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends ConsumerState<NewEntry> {
  final _formKey = GlobalKey<FormState>();

  String _description = '';
  int _amount = 0;
  String _type = '';
  String _category = '';
  DateTime? _date;

  bool typeIsValid = true;

  @override
  void initState() {
    super.initState();
    ref.read(categoriesProvider.notifier).loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    List<Category> categoriesByType = [];
    final categories = ref.watch(categoriesProvider);
    if (_type == l10n.income) {
      categoriesByType = categories['income'] ?? [];
    }
    if (_type == l10n.expense) {
      categoriesByType = categories['expenses'] ?? [];
    }
    if (categoriesByType.isNotEmpty && _category == '') {
      _category = categoriesByType[0].title;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.newEntry,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              l10n.categoryType,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            FormField<String>(
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
                    Row(
                      children: [
                        RadioMenuButton(
                          value: l10n.expense,
                          groupValue: _type,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _type = value;
                            });
                            state.didChange(value);
                          },
                          child: Text(l10n.expense),
                        ),
                        RadioMenuButton(
                          value: l10n.income,
                          groupValue: _type,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _type = value;
                            });
                            state.didChange(value);
                          },
                          child: Text(l10n.income),
                        ),
                      ],
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
            const SizedBox(height: 24),
            TextFormField(
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return l10n.categoryTitleErrorMessage;
                }
                return null;
              },
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              onSaved: (value) {
                if (value == null) return;
                setState(() {
                  _description = value;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.categoryTitle,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              validator: (value) {
                if (value == null ||
                    int.tryParse(value) == null ||
                    int.parse(value) < 0) {
                  return l10n.amountErrorMessage;
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onSaved: (value) {
                if (value == null) return;
                setState(() {
                  _amount = int.parse(value);
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.amount,
              ),
            ),
            const SizedBox(height: 24),
            if (categoriesByType.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: l10n.category,
                        border: const OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      value: _category,
                      items: categoriesByType
                          .map(
                            (category) => DropdownMenuItem(
                              key: ValueKey(category.uid),
                              value: category.title,
                              child: Text(
                                category.title,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _category = value;
                          print('category changed to $_category');
                        });
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            DateSelector(date: _date, selectDate: selectDate),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _submit(l10n);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.save),
              ),
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

  Future<void> selectDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(DateTime.now().year - 1);
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _date = selectedDate;
    });
  }

  void _submit(AppLocalizations l10n) {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        print('on saved $_category');
        ref
            .read(entriesProvider.notifier)
            .saveEntry(
              description: _description,
              type: _type,
              amount: _amount,
              category: _category,
              date: _date != null
                  ? _date!.toIso8601String()
                  : DateTime.now().toIso8601String(),
            );
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.entrySavedSuccessfully)));
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
