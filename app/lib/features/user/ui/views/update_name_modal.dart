import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class UpdateNameModal extends StatelessWidget {
  const UpdateNameModal({
    super.key,
    required TextEditingController nameController,
    required this.l10n,
  }) : _nameController = nameController;

  final TextEditingController _nameController;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, current) {
        if (prev is AuthAuthenticated && current is AuthAuthenticated) {
          return prev.user.name != current.user.name;
        }
        return false;
      },
      listener: (context, state) {
        Navigator.pop(context);
      },
      builder: (BuildContext context, AuthState state) => Container(
        color: Colors.white,
        child: Column(
          children: [
            box16,
            Text(
              l10n.editName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            box16,
            const Divider(height: 2),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.userName,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  box16,
                  if (state is AuthAuthenticated)
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          UpdateName(
                            name: _nameController.text,
                            uid: state.user.uid,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          l10n.save,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
