import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/categories/domain/bloc/categories_bloc.dart';
import 'package:mal/features/entries/domain/bloc/entries_bloc.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/mal_page.dart';
import 'package:mal/ui/widgets/entry_form.dart';
import 'package:mal/utils/logger.dart';

class AddEntryButton extends StatelessWidget implements MalPageAction {
  const AddEntryButton({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: l10n.newEntry,
      icon: const Icon(Icons.create, color: Colors.white, size: 40),
      onPressed: () => onPressed(context),
    );
  }

  @override
  void onPressed(BuildContext context) async {
    try {
      final authState = context.read<AuthBloc>().state;

      if (authState is! AuthAuthenticated) return;

      await showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,

        builder: (ctx) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<EntriesBloc>()),
            BlocProvider.value(value: context.read<CategoriesBloc>()),
          ],
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.90,
            child: EntryForm(userUid: authState.user.uid),
          ),
        ),
      );
    } catch (e, t) {
      logger
        ..e(e)
        ..t(t);
    }
  }
}
