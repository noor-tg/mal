import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/mal_page.dart';

class LogoutButton extends StatelessWidget implements MalPageAction {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthUnauthenticated) context.go('/login');
      },
      child: Transform.flip(
        flipX: true,
        child: IconButton.filled(
          tooltip: AppLocalizations.of(context)?.logout,
          icon: const Icon(Icons.logout, color: Colors.white, size: 40),
          onPressed: () {
            onPressed(context);
          },
        ),
      ),
    );
  }

  @override
  void onPressed(BuildContext context) {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }
}
