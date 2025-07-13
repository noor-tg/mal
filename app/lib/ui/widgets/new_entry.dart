import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/providers/categories_provider.dart';
import 'package:mal/ui/widgets/date_selector.dart';

class NewEntry extends ConsumerStatefulWidget {
  const NewEntry({super.key});

  @override
  ConsumerState<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends ConsumerState<NewEntry> {
  final _formKey = GlobalKey<FormState>();

  String? _description = '';
  String? _amount = '';
  String? _type = '';
  String? _category = '';

  bool typeIsValid = true;

  var _date;

  @override
  void initState() {
    super.initState();
    ref.read(categoriesProvider.notifier).loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = ref.watch(categoriesProvider);
    final List<String> expenses = categories['expenses'] == null
        ? []
        : categories['expenses']!.map((exp) => exp.title).toSet().toList();
    _category = expenses[0];

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
            TextFormField(
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return l10n.categoryTitleErrorMessage;
                }
                return null;
              },
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              onSaved: (value) {
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
                if (value == null || value.trim().length < 3) {
                  return l10n.categoryTitleErrorMessage;
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onSaved: (value) {
                setState(() {
                  _amount = value;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.amount,
              ),
            ),
            const SizedBox(height: 24),
            if (expenses.isNotEmpty)
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
                      items: expenses
                          .map(
                            (category) => DropdownMenuItem(
                              key: ValueKey(category),
                              value: category,
                              child: Text(
                                category,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _category = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            DateSelector(date: _date, selectDate: selectDate),
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
                  groupValue: _type,
                  onChanged: (value) {
                    setState(() {
                      _type = value;
                    });
                  },
                  child: Text(l10n.expense),
                ),
                RadioMenuButton(
                  value: l10n.income,
                  groupValue: _type,
                  onChanged: (value) {
                    setState(() {
                      _type = value;
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

  void _submit(AppLocalizations l10n) {}
}
