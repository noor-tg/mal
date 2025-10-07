import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/features/user/data/services/biometric_service.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/domain/bloc/exporter/exporter_bloc.dart';
import 'package:mal/features/user/ui/views/update_name_modal.dart';
import 'package:mal/features/user/ui/views/update_pin_modal.dart';
import 'package:mal/features/user/ui/widgets/user_image_picker.dart';
import 'package:mal/utils.dart';
import 'package:open_filex/open_filex.dart';

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
    return BlocConsumer<AuthBloc, AuthState>(
      buildWhen: (_, _) => true,
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: context.colors.surfaceContainer),
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
                      color: colors.onSurface.withAlpha(150),
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
      color: colors.onSurface,
    );
    final titleStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: colors.onSurface.withAlpha(150),
    );

    return Card(
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
                    builder: (BuildContext context) =>
                        UpdateNameModal(nameController: _nameController),
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
                    builder: (BuildContext context) => const UpdatePinModal(),
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
    final titleStyle = texts.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: colors.onSurface,
    );
    final countStyle = texts.displayLarge?.copyWith(
      color: colors.onSurface.withAlpha(150),
    );
    return Column(
      children: [
        Card(
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
        Card(
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

  Widget _buildExporterButton(AuthAuthenticated state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocConsumer<ExporterBloc, ExporterState>(
          builder: (context, exporterState) => exporterState is ExporterLoading
              ? const Center(child: CircularProgressIndicator(value: 2))
              : ElevatedButton.icon(
                  label: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.exportToCsv,
                      style: texts.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.download, size: 24),
                  onPressed: () {
                    context.read<ExporterBloc>().add(
                      ExportToCsv(userUid: state.user.uid, l10n: l10n),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                  ),
                ),
          listener: (BuildContext context, ExporterState state) {
            if (state is ExporterOperationSuccessful) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.exportCompleted,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        box24,
                        OutlinedButton(
                          onPressed: () async {
                            if (!Platform.isAndroid) return;

                            final downloadsDir = Directory(
                              '/storage/emulated/0/Download',
                            );

                            if (!downloadsDir.existsSync()) return;

                            await OpenFilex.open(downloadsDir.path);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: Text(
                            l10n.openFile,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: context.green,
                ),
              );
            }
          },
        ),
        box24,
      ],
    );
  }
}
