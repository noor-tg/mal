import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/l10n/app_localizations.dart';

class MainDrawer extends StatelessWidget {
  // const MainDrawer({super.key, required this.onSelectScreen});
  const MainDrawer({super.key});

  // final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
                  Theme.of(context).colorScheme.primaryContainer.withAlpha(200),
                ],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.logout),
                const SizedBox(width: 10),
                BlocListener<AuthBloc, AuthState>(
                  listener: (BuildContext context, state) {
                    if (state is AuthUnauthenticated) {
                      Navigator.pop(context);
                      context.go('/login');
                    }
                  },
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthLogoutRequested());
                    },
                    child: Text(
                      'تسجيل خروج',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_box, size: 26),
            title: Text(l10n.profile),
            onTap: () {
              context.go('/profile');
            },
          ),
        ],
      ),
    );
  }
}
