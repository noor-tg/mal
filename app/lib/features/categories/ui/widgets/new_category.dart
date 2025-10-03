import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/constants.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/data/models/category.dart';
import 'package:mal/shared/popups.dart';
import 'package:mal/ui/widgets/dismess_modal_button.dart';
import 'package:mal/ui/widgets/submit_button.dart';
import 'package:mal/ui/widgets/type_field.dart';
import 'package:mal/utils.dart';

class NewCategory extends StatefulWidget {
  const NewCategory({super.key});

  @override
  State<NewCategory> createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  String? _categoryTitle = '';
  String _categoryType = '';
  bool typeIsValid = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.newCategory,
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
              l10n.categoryTitle,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            box8,
            TextFormField(
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().length < 2) {
                  return l10n.categoryTitleErrorMessage;
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _categoryTitle = value;
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            TypeField(
              onPressed: (value) {
                if (value == null) return;
                _categoryType = value;
              },
              type: _categoryType,
            ),
            const SizedBox(height: 24),
            SubmitButton(
              onPressed: () {
                _submit(l10n);
              },
            ),
            box16,
            const DismessModalButton(),
          ],
        ),
      ),
    );
  }

  void _submit(AppLocalizations l10n) {
    setState(() {
      categoryTypeIsValid();
      if (_formKey.currentState!.validate() && typeIsValid) {
        _formKey.currentState!.save();
        final authState = context.read<AuthBloc>().state;

        if (authState is! AuthAuthenticated) return;

        context.read<CategoriesBloc>().add(
          StoreCategory(
            Category(
              title: _categoryTitle!,
              type: _categoryType,
              userUid: authState.user.uid,
            ),
          ),
        );

        Navigator.pop(context);

        successPopup(
          message: l10n.categoresSavedSuccessfully,
          context: context,
        );
      } else {
        errorPopup(message: l10n.pleaseAddCorrectInfo, context: context);
      }
    });
  }

  void categoryTypeIsValid() {
    setState(() {
      typeIsValid = [incomeType, expenseType].contains(_categoryType);
    });
  }
}
