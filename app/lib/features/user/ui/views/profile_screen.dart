import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/views/user_avatar.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final subStyle = theme.textTheme.titleLarge?.copyWith(
          color: Colors.grey[700],
        );
        final titleStyle = theme.textTheme.bodyMedium?.copyWith(
          color: Colors.grey[700],
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.profile),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_forward, size: 32),
                onPressed: () {
                  context.go('/dashboard');
                },
              ),
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.withAlpha(50)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              child: state is AuthAuthenticated
                  ? Column(
                      children: [
                        const SizedBox(height: 48),
                        const UserAvatar(),
                        const SizedBox(height: 32),
                        Text(
                          l10n.personalInfo,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        box8,
                        Card.filled(
                          color: Colors.white,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.account_circle,
                                  size: 32,
                                ),
                                title: Text(l10n.userName, style: titleStyle),
                                subtitle: Text(
                                  state.user.name,
                                  style: subStyle,
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.lock, size: 32),
                                title: Text(l10n.password, style: titleStyle),
                                subtitle: Text('* * * *', style: subStyle),
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.calendar_month,
                                  size: 32,
                                ),
                                title: Text(
                                  l10n.member_since,
                                  style: titleStyle,
                                ),
                                subtitle: Text(
                                  toDate(state.user.createdAt),
                                  style: subStyle,
                                ),
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.calendar_month,
                                  size: 32,
                                ),
                                title: Text(l10n.updatedAt, style: titleStyle),
                                subtitle: Text(
                                  state.user.updatedAt == null
                                      ? toDate(state.user.createdAt)
                                      : toDate(state.user.updatedAt!),
                                  style: subStyle,
                                ),
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.fingerprint,
                                  size: 32,
                                ),
                                title: Text(
                                  l10n.biometricEnabled,
                                  style: titleStyle,
                                ),
                                subtitle: Text(
                                  state.user.biometricEnabled
                                      ? l10n.enabled
                                      : l10n.disabled,
                                  style: subStyle,
                                ),
                                // trailing: Switch(
                                //   value: state.biometricEnabled,
                                //   onChanged: (enabled) {},
                                //   // _toggleBiometric(enabled, userName),
                                //   // activeColor: Colors.blue.shade600,
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Column(),
            ),
          ),
        );
      },
    );
  }
}
