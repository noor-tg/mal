import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/features/user/data/services/biometric_service.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/views/update_name_modal.dart';
import 'package:mal/features/user/ui/views/update_pin_modal.dart';
import 'package:mal/features/user/ui/views/user_avatar.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isBiometricAvailable = false;

  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final isAvailable = await BiometricService.isBiometricAvailable();
    if (mounted) {
      setState(() {
        _isBiometricAvailable = isAvailable;
      });
    }
  }

  void _toggleBiometric(bool enabled, String userName) {
    context.read<AuthBloc>().add(
      AuthBiometricToggleRequested(name: userName, enabled: enabled),
    );
  }

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
                                trailing: SizedBox(
                                  width: 60,
                                  child: IconButton(
                                    icon: const Icon(Icons.create),
                                    onPressed: () {
                                      _nameController.text = state.user.name;
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            UpdateNameModal(
                                              nameController: _nameController,
                                              l10n: l10n,
                                            ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.lock, size: 32),
                                title: Text(l10n.password, style: titleStyle),
                                subtitle: Text('* * * *', style: subStyle),
                                trailing: SizedBox(
                                  width: 60,
                                  child: IconButton(
                                    icon: const Icon(Icons.create),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            UpdatePinModal(l10n: l10n),
                                      );
                                    },
                                  ),
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
                                  state.biometricEnabled
                                      ? l10n.enabled
                                      : l10n.disabled,
                                  style: subStyle,
                                ),
                                trailing: SizedBox(
                                  width: 60,
                                  child: _isBiometricAvailable
                                      ? Switch(
                                          value: state.biometricEnabled,
                                          onChanged: (enabled) =>
                                              _toggleBiometric(
                                                enabled,
                                                state.user.name,
                                              ),
                                          activeColor:
                                              theme.colorScheme.primary,
                                        )
                                      : const Icon(Icons.block),
                                ),
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
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Text('Not Authed'),
            ),
          ),
        );
      },
    );
  }
}
