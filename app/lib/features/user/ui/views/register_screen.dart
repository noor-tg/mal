import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/views/field_label.dart';
import 'package:mal/features/user/ui/widgets/pin_input.dart';
import 'package:mal/features/user/utils.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pinInputKey = GlobalKey<State<PinInput>>();
  String _pinValue = '';

  late ColorScheme theme;
  late AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    l10n = AppLocalizations.of(context)!;
    theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 88,
                backgroundColor: Colors.white,
                child: Text(
                  l10n.logo,
                  style: GoogleFonts.arefRuqaa(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: theme.primary,
                  ),
                ),
              ),
              box16,
              Center(
                child: Text(
                  l10n.registerUser,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildFormBody(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BlocConsumer<AuthBloc, AuthState> _buildFormBody() {
    return BlocConsumer<AuthBloc, AuthState>(
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
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(backgroundColor: theme.primary),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  l10n.registerBtn,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: Text(l10n.haveAnAccount),
            ),
          ],
        ),
      ),
      listener: listenToChanges,
    );
  }

  void _submitForm() {
    _formKey.currentState!.save();
    context.read<AuthBloc>().add(
      AuthRegisterAndLoginRequested(
        name: _nameController.text,
        pin: _pinValue,
        l10n: l10n,
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
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ),
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
}
