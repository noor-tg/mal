import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthUnauthenticated) context.go('/login');
      },
      child: Transform.flip(
        flipX: true,
        child: IconButton.filledTonal(
          tooltip: AppLocalizations.of(context)?.logout,
          color: Theme.of(context).colorScheme.primary,
          icon: const Icon(Icons.logout, size: 40),
          onPressed: () {
            context.read<AuthBloc>().add(const AuthLogoutRequested());
          },
        ),
      ),
    );
  }
}
