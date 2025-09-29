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

  late ColorScheme theme;
  late AppLocalizations l10n;

  final GlobalKey<State<PinInput>> _pinInputKey = GlobalKey();
  final _nameController = TextEditingController();
  String _pinValue = '';
  bool _isBiometricAvailable = false;
  User? _selectedUser;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    l10n = AppLocalizations.of(context)!;
    theme = Theme.of(context).colorScheme;
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FieldLabel(text: l10n.userName),
                  box8,
                  _buildNameField(),
                  box24,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPinField(),
                      box16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                  _buildSubmitButton(),
                  if (_isBiometricAvailable) ...[
                    const SizedBox(height: 16),
                    _buildBioButton(),
                  ],
                  TextButton(
                    onPressed: goToRegister,
                    child: Text(l10n.notHaveAccount),
                  ),
                ],
              ),
            ),
            listener: listenToChanges,
          ),
        ),
      ),
    );
  }

  BlocBuilder<AuthBloc, AuthState> _buildNameField() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          errorText: getFieldError(state, 'name'),
          border: const OutlineInputBorder(),
          suffixIcon: _nameController.text.trim().isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _nameController.clear,
                )
              : null,
        ),
        autocorrect: false,
        onChanged: (value) {
          setState(() {
            _nameController.text = value;
          });
        },
        onSaved: (value) {
          setState(() {
            if (value != null) return;
            _nameController.text = value!;
          });
        },
      ),
    );
  }

  BlocBuilder<AuthBloc, AuthState> _buildPinField() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(text: l10n.password),
            box8,
            PinInput(
              key: _pinInputKey,
              boxSize: 56,
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
            if (getFieldError(state, 'pin') != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  getFieldError(state, 'pin')!,
                  style: TextStyle(color: Colors.red.shade900, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  ElevatedButton _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () => _submitForm(l10n),
      style: ElevatedButton.styleFrom(backgroundColor: theme.primary),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(l10n.login, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  BlocBuilder<AuthBloc, AuthState> _buildBioButton() {
    return BlocBuilder<AuthBloc, AuthState>(
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
    );
  }

  void listenToChanges(BuildContext context, AuthState state) {
    switch (state) {
      case AuthError():
        errorSnakbar(message: state.message, context: context);
        break;
      case AuthAuthenticated():
        context.go('/dashboard');
        break;
      default:
        break;
    }
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

  void goToRegister() {
    context.read<AuthBloc>().add(AuthReset());
    context.go('/register');
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }
}
