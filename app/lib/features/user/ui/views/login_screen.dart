import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import
import 'package:mal/features/user/data/services/biometric_service.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/widgets/pin_input.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State<PinInput>> _pinInputKey = GlobalKey();

  String _pinValue = '';

  String _nameValue = '';

  // bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    // _initializeBiometric();
  }

  // NOTICE: enable when done with bio login
  // Future<void> _loginWithBiometric() async {
  //   if (_selectedUser == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please select a user first'),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //     return;
  //   }

  //   // Check if user has biometric enabled
  //   final biometricEnabled = await BiometricService.getBiometricPreference(
  //     _selectedUser!,
  //   );
  //   if (!biometricEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Biometric login not enabled for this user'),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //     return;
  //   }

  // if (!mounted) return;
  // context.read<AuthBloc>().add(
  //   AuthLoginWithBiometricRequested(name: _selectedUser!),
  // );
  // }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              box16,
              Center(
                child: Text(
                  l10n.login,
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
                              builder: (context, state) => TextFormField(
                                decoration: InputDecoration(
                                  errorText: _getFieldError(state, 'name'),
                                  border: const OutlineInputBorder(),
                                ),
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 4) {
                                    return 'please enter at least 4 chars';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _nameValue = value!;
                                },
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
                                PinInput(
                                  key: _pinInputKey,
                                  boxSize: 60.0,
                                  pinLength: 4,
                                  activeColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
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
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    if (_getFieldError(state, 'pin') != null) {
                                      return Column(
                                        children: [
                                          box8,
                                          Text(
                                            _getFieldError(state, 'pin')!,
                                            style: const TextStyle(
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox(width: 1);
                                  },
                                ),

                                box16,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Text(
                                  l10n.login,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/register');
                              },
                              child: Text(l10n.notHaveAccount),
                            ),
                          ],
                        ),
                      ),
                      listener: (BuildContext context, AuthState state) {
                        if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                        if (state is AuthAuthenticated ||
                            state is AuthRegistrationSuccessWithLogin) {
                          context.go('/dashboard');
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      logger.i('not valid');
      return;
    }
    _formKey.currentState!.save();

    context.read<AuthBloc>().add(
      AuthLoginWithPinRequested(name: _nameValue, pin: _pinValue),
    );

    // NOTICE: this is to learn from it to make the avatar in the future
    // try {
    //   if (_isLogin) {
    //     final user = await pb
    //         .collection('users')
    //         .authWithPassword(_emailValue, _passwordValue);
    //     // print(user);
    //   } else {
    //     if (_pickedImage == null) {
    //       throw Exception('please select Image');
    //     }
    //     await pb
    //         .collection('users')
    //         .create(
    //           body: {
    //             'name': _nameValue,
    //             'email': _emailValue,
    //             'password': _passwordValue,
    //             'passwordConfirm': _passwordValue,
    //           },
    //           files: [
    //             await http.MultipartFile.fromPath('avatar', _pickedImage!.path),
    //           ],
    //         );
    //     final user = await pb
    //         .collection('users')
    //         .authWithPassword(_emailValue, _passwordValue);
    //     // print(user);
    //   }
    // } on Exception catch (error) {
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text(error.toString())));
    // }
  }

  String? _getFieldError(AuthState state, String field) {
    if (state is AuthError && state.fieldsErrors != null) {
      return state.fieldsErrors![field];
    }
    return null;
  }

  // void _initializeBiometric() async {
  //   final isAvailable = await BiometricService.isBiometricAvailable();
  //   setState(() {
  //     _isBiometricAvailable = isAvailable;
  //   });
  // }
}
