import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/features/user/ui/widgets/pin_input.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State<PinInput>> _pinInputKey = GlobalKey();
  String _enteredPin = '';

  var _pinValue = '';

  var _nameValue = '';

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
              Card(
                color: Colors.white,
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
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
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.trim().length < 4) {
                                  return 'please enter at least 4 chars';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _nameValue = value!;
                              },
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
                                    _enteredPin = pin;
                                  });
                                },
                                onCompleted: (pin) {
                                  _handlePinCompleted(pin);
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
                              // const Text(
                              //   'Features:\n'
                              //   '• Auto-focus progression\n'
                              //   '• Backspace navigation\n'
                              //   '• Numeric input only\n'
                              //   '• Obscured text option\n'
                              //   '• Error state handling\n'
                              //   '• Customizable styling',
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // if (isLoading)
                          // const TextButton(
                          //   onPressed: null,
                          //   child: CircularProgressIndicator(),
                          // ),
                          // if (!isLoading)
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                            child: Text(
                              _isLogin ? 'Login' : 'Signup',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          // if (!isLoading)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? 'create an account'
                                  : 'have an account ? login',
                            ),
                          ),
                        ],
                      ),
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    try {
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
    } on Exception catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _handlePinCompleted(String pin) {
    // Validate PIN here
    if (pin == '123456') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN is correct!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect PIN. Try again.'),
            backgroundColor: Colors.red,
          ),
        );
        PinInput.showError(_pinInputKey);

        // Clear PIN after 1 second
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            PinInput.clearPin(_pinInputKey);
          }
        });
      }
    }
  }
}
