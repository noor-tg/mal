import 'package:flutter/material.dart';
import 'package:mal/constants.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/ui/widgets/date_selector.dart';
import 'package:mal/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class EntryForm extends StatefulWidget {
  const EntryForm({super.key, this.entry, this.userUid})
    : assert(
        entry != null || userUid != null,
        'EntryForm requires either entry or userUid',
      );
  final Entry? entry;

  final String? userUid;

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formKey = GlobalKey<FormState>();

  String _description = '';
  int? _amount;
  String _type = '';
  String _category = '';
  DateTime? _date;

  bool typeIsValid = true;

  Entry? entry;

  @override
  void initState() {
    if (widget.entry == null && widget.userUid == null) {
      throw Exception('form should either have entry user uid or auth uid');
    }
    if (widget.entry != null) {
      _description = widget.entry!.description;
      _amount = widget.entry!.amount;
      _type = widget.entry!.type;
      _category = widget.entry!.category;
      _date = DateTime.parse(widget.entry!.date);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (BuildContext ctx, state) {
        List<Category> categoriesByType = [];
        if (_type == incomeType) {
          categoriesByType = state.income;
        }
        if (_type == expenseType) {
          categoriesByType = state.expenses;
        }
        if (categoriesByType.isNotEmpty && _category == '') {
          _category = categoriesByType[0].title;
        }

        if (categoriesByType.isNotEmpty) {
          final categoryExists = categoriesByType.any(
            (cat) => cat.title == _category,
          );
          if (_category == '' || !categoryExists) {
            _category = categoriesByType[0].title;
          }
        } else {
          _category = ''; // Reset if no categories available
        }
        if (_category == '') {
          _category = l10n.emptyCategoriesList;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.entry != null ? l10n.editEntry : l10n.newEntry,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    l10n.categoryType,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  FormField<String>(
                    initialValue: _type,
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
                          Column(
                            children: [
                              RadioListTile(
                                value: l10n.expense,
                                groupValue: _type,
                                onChanged: (value) => _setType(value, state),
                                title: Text(l10n.expense),
                              ),
                              RadioListTile(
                                value: l10n.income,
                                groupValue: _type,
                                onChanged: (value) => _setType(value, state),
                                title: Text(l10n.income),
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
                  Text(
                    l10n.categoryTitle,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  box8,
                  TextFormField(
                    initialValue: _description,
                    validator: (value) {
                      if (value == null ||
                          value.trim().length < 2 ||
                          value.trim().length > 255) {
                        return l10n.entryDescriptionErrorMessage;
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.amount,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  box8,
                  TextFormField(
                    initialValue: _amount?.toString(),
                    validator: (value) {
                      if (value == null ||
                          int.tryParse(value) == null ||
                          int.parse(value) < 1) {
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.category,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  box8,
                  if (categoriesByType.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            value: _category,
                            validator: (value) {
                              if (value == null ||
                                  value == l10n.emptyCategoriesList) {
                                return l10n.selectCorrectCategoryMessage;
                              }
                              return null;
                            },
                            items: categoriesByType
                                .map(
                                  (category) => DropdownMenuItem(
                                    key: ValueKey(category.uid),
                                    value: category.title,
                                    child: Text(
                                      category.title,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
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
                  if (categoriesByType.isEmpty)
                    EmptyCategoriesDropdown(category: _category, l10n: l10n),
                  const SizedBox(height: 24),
                  Text(
                    l10n.date,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  box8,
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
                      child: Text(
                        l10n.save,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  box24,
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(50),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.cancel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        final entry = Entry(
          uid: widget.entry?.uid,
          userUid: widget.entry?.userUid ?? widget.userUid ?? '',
          description: _description,
          type: _type,
          amount: _amount!,
          category: _category,
          date: _date?.toIso8601String(),
        );
        if (widget.entry == null) {
          context.read<EntriesBloc>().add(StoreEntry(entry));
        } else {
          context.read<EntriesBloc>().add(EditEntry(entry));
        }
        Navigator.of(context).pop(widget.entry != null);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.entrySavedSuccessfully)));
      }
    } catch (error) {
      logger.e(error);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _setType(String? value, state) {
    if (value == null) return;
    setState(() {
      _type = value;
      _category = '';
    });
    state.didChange(value);
  }
}

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
            value: _category,
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
