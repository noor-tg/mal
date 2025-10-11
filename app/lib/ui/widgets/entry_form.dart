import 'package:flutter/material.dart';
import 'package:mal/constants.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/shared/data/models/entry.dart';
import 'package:mal/shared/popups.dart';
import 'package:mal/ui/widgets/date_selector.dart';
import 'package:mal/ui/widgets/dismess_modal_button.dart';
import 'package:mal/ui/widgets/empty_categories_dropdown.dart';
import 'package:mal/ui/widgets/field_label.dart';
import 'package:mal/ui/widgets/submit_button.dart';
import 'package:mal/ui/widgets/type_field.dart';
import 'package:mal/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/utils/logger.dart';

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
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (BuildContext ctx, state) {
        final categoriesByType = setupCategories(state);
        return _buildForm(state, categoriesByType);
      },
    );
  }

  List<Category> setupCategories(CategoriesState state) {
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
    return categoriesByType;
  }

  Widget _buildForm(CategoriesState state, List<Category> categoriesByType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: colors.surfaceBright,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.entry != null ? l10n.editEntry : l10n.newEntry,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: colors.surfaceContainer,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    TypeField(
                      onPressed: (value) {
                        _setType(value, state);
                      },
                      type: _type,
                    ),
                    const SizedBox(height: 24),
                    FieldLabel(text: l10n.description),
                    box8,
                    TextFormField(
                      initialValue: _description,
                      validator: validateDescription,
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
                    FieldLabel(text: l10n.amount),
                    box8,
                    TextFormField(
                      initialValue: _amount?.toString(),
                      validator: validateAmount,
                      keyboardType: TextInputType.number,
                      onSaved: setAmount,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FieldLabel(text: l10n.category),
                    box8,
                    if (categoriesByType.isNotEmpty)
                      buildCategoriesDropdown(categoriesByType),
                    if (categoriesByType.isEmpty)
                      EmptyCategoriesDropdown(category: _category),
                    const SizedBox(height: 24),
                    FieldLabel(text: l10n.date),
                    box8,
                    DateSelector(date: _date, selectDate: selectDate),
                    const SizedBox(height: 24),
                    SubmitButton(onPressed: _submit),
                    box24,
                    const DismessModalButton(),
                    box64,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildCategoriesDropdown(List<Category> categoriesByType) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            isExpanded: true,
            initialValue: _category,
            validator: (value) {
              if (value == null || value == l10n.emptyCategoriesList) {
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
                      style: TextStyle(color: colors.onSurface),
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
    );
  }

  String? validateAmount(String? value) {
    if (value == null || int.tryParse(value) == null || int.parse(value) < 1) {
      return l10n.amountErrorMessage;
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().length < 2 || value.trim().length > 255) {
      return l10n.entryDescriptionErrorMessage;
    }
    return null;
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

  void _submit() {
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
        successPopup(message: l10n.entrySavedSuccessfully, context: context);
      }
    } catch (error) {
      logger.e(error);
      errorPopup(message: error.toString(), context: context);
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

  void setAmount(String? value) {
    if (value == null) return;
    setState(() {
      _amount = int.parse(value);
    });
  }
}
