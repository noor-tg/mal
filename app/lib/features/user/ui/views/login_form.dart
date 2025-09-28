import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/features/user/data/repositories/sql_repository.dart';
import 'package:mal/features/user/data/services/biometric_service.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/widgets/pin_input.dart';
import 'package:mal/features/user/utils.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/data/models/user.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/logger.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  void initState() {
    super.initState();
    _initializeBiometric();
    _fetchLastUser();
  }

  final GlobalKey<State<PinInput>> _pinInputKey = GlobalKey();
  final _nameController = TextEditingController();
  String _pinValue = '';
  bool _isBiometricAvailable = false;
  User? _selectedUser;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<AuthBloc, AuthState>(
            builder: (BuildContext context, state) => Form(
              key: _formKey,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  box8,
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          errorText: getFieldError(state, 'name'),
                          border: const OutlineInputBorder(),
                        ),
                        autocorrect: false,
                        onSaved: (value) {
                          _nameController.text = value!;
                        },
                      ),
                    ),
                  ),

                  box24,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.password,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      box8,
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PinInput(
                                key: _pinInputKey,
                                boxSize: 60.0,
                                pinLength: 4,
                                activeColor: theme.primary,
                                errorColor: Colors.red,
                                obscureText: true,
                                onChanged: (pin) {
                                  setState(() {
                                    _pinValue = pin;
                                  });
                                },
                                onCompleted: (_) {},
                                autofocus: false,
                              ),
                              if (getFieldError(state, 'pin') != null) box8,
                              if (getFieldError(state, 'pin') != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Text(
                                    getFieldError(state, 'pin')!,
                                    style: TextStyle(
                                      color: Colors.red.shade800,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      box16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              PinInput.clearPin(_pinInputKey);
                            },
                            child: Text(l10n.clear),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _submitForm(l10n),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        l10n.login,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  if (_isBiometricAvailable) ...[
                    const SizedBox(height: 16),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return OutlinedButton.icon(
                          onPressed: state is AuthLoading
                              ? null
                              : () => _loginWithBiometric(l10n),
                          icon: const Icon(Icons.fingerprint),
                          label: Text(l10n.bioButton),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.primary,
                            side: BorderSide(color: theme.primary),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  TextButton(
                    onPressed: () {
                      logger.i('go to register');
                      context.read<AuthBloc>().add(AuthReset());
                      context.go('/register');
                    },
                    child: Text(l10n.notHaveAccount),
                  ),
                ],
              ),
            ),
            listener: (BuildContext context, AuthState state) {
              if (state is AuthError) {
                errorSnakbar(message: state.message, context: context);
              }
              if (state is AuthAuthenticated) {
                context.go('/dashboard');
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _loginWithBiometric(AppLocalizations l10n) async {
    final String? name = _selectedUser != null
        ? _selectedUser?.name
        : _nameController.text.trim().length >= 4
        ? _nameController.text
        : null;
    if (name == null) {
      errorSnakbar(context: context, message: l10n.loginMessageSelectUser);
      return;
    }

    // Check if user has biometric enabled
    final biometricEnabled = await BiometricService.getBiometricPreference(
      name,
    );

    if (!mounted) return;

    if (!biometricEnabled) {
      errorSnakbar(context: context, message: l10n.bioLoginNotEnabled);
      return;
    }

    context.read<AuthBloc>().add(AuthLoginWithBiometricRequested(name: name));
  }

  void _submitForm(AppLocalizations l10n) {
    _formKey.currentState!.save();

    context.read<AuthBloc>().add(
      AuthLoginWithPinRequested(
        name: _nameController.text,
        pin: _pinValue,
        l10n: l10n,
      ),
    );
  }

  void _initializeBiometric() async {
    final isAvailable = await BiometricService.isBiometricAvailable();
    setState(() {
      _isBiometricAvailable = isAvailable;
    });
  }

  void _fetchLastUser() async {
    final name = await BiometricService.getLastAuthenticatedUser();
    if (name == null) return;

    final repo = SqlRepository();

    try {
      logger.i(name);
      final user = await repo.getUserByName(name);
      _selectedUser = user;
      _nameController.text = _selectedUser!.name;
    } catch (e, t) {
      logger
        ..e(e)
        ..t(t);
      if (!mounted) return;
      errorSnakbar(
        context: context,
        message: AppLocalizations.of(context)!.loginLastUserNotFound,
      );
    }
  }
}
