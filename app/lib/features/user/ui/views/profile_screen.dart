import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/features/user/data/services/biometric_service.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/views/update_name_modal.dart';
import 'package:mal/features/user/ui/views/update_pin_modal.dart';
import 'package:mal/features/user/ui/widgets/user_image_picker.dart';
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

  late AppLocalizations l10n;
  late ThemeData theme;
  @override
  Widget build(BuildContext context) {
    l10n = AppLocalizations.of(context)!;
    theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (_, _) => true,
      builder: (context, state) {
        if (state is! AuthUnauthenticated) {
          context.go('/login');
        }
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.withAlpha(50)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  if (state is AuthAuthenticated)
                    UserImagePicker(
                      existingImage: state.user.avatar == null
                          ? null
                          : File(state.user.avatar!),
                      onPickImage: (File pickedImage) {
                        context.read<AuthBloc>().add(
                          UpdateAvatar(
                            avatar: pickedImage,
                            uid: state.user.uid,
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.personalInfo,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  box8,
                  if (state is AuthAuthenticated) _buildInfoCard(state),
                  box16,
                  if (state is AuthAuthenticated) _buildStatistics(state),
                  box16,
                  if (state is AuthAuthenticated) _buildExporterButton(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(AuthAuthenticated state) {
    final subStyle = theme.textTheme.titleLarge?.copyWith(
      color: Colors.grey[700],
    );
    final titleStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.grey[600],
    );

    return Card.filled(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle, size: 32),
            title: Text(l10n.userName, style: titleStyle),
            subtitle: Text(state.user.name, style: subStyle),
            trailing: SizedBox(
              width: 60,
              child: IconButton(
                icon: const Icon(Icons.create),
                onPressed: () {
                  _nameController.text = state.user.name;
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => UpdateNameModal(
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
            leading: const Icon(Icons.fingerprint, size: 32),
            title: Text(l10n.biometricEnabled, style: titleStyle),
            subtitle: Text(
              state.biometricEnabled ? l10n.enabled : l10n.disabled,
              style: subStyle,
            ),
            trailing: SizedBox(
              width: 60,
              child: _isBiometricAvailable
                  ? Switch(
                      value: state.biometricEnabled,
                      onChanged: (enabled) =>
                          _toggleBiometric(enabled, state.user.name),
                      activeThumbColor: theme.colorScheme.primary,
                    )
                  : const Icon(Icons.block),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month, size: 32),
            title: Text(l10n.member_since, style: titleStyle),
            subtitle: Text(toDate(state.user.createdAt), style: subStyle),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month, size: 32),
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
    );
  }

  Widget _buildStatistics(AuthAuthenticated state) {
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade700,
    );
    final countStyle = theme.textTheme.displayLarge?.copyWith(
      color: Colors.grey,
    );
    return Column(
      children: [
        Card.filled(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.entriesCount, style: titleStyle),
                Center(
                  child: Text(
                    state.statistics.entries.toString(),
                    style: countStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        box16,
        Card.filled(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.categoriesCount, style: titleStyle),
                Center(
                  child: Text(
                    state.statistics.categories.toString(),
                    style: countStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
