import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/utils.dart';

class UpdateNameModal extends StatelessWidget {
  const UpdateNameModal({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

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
        color: context.colors.surfaceBright,
        child: Column(
          children: [
            box16,
            Text(
              context.l10n.editName,
              style: context.texts.headlineLarge?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            box16,
            const Divider(height: 2),
            Expanded(
              child: Container(
                color: context.colors.surfaceContainer,
                padding: const EdgeInsets.all(32),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: context.l10n.userName,
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
                          backgroundColor: context.colors.primary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            context.l10n.save,
                            style: TextStyle(
                              color: context.colors.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
