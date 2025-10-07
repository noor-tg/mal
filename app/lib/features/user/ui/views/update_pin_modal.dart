import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/widgets/pin_input.dart';
import 'package:mal/utils.dart';

class UpdatePinModal extends StatefulWidget {
  const UpdatePinModal({super.key});

  @override
  State<UpdatePinModal> createState() => _UpdatePinModalState();
}

class _UpdatePinModalState extends State<UpdatePinModal> {
  final GlobalKey<State<PinInput>> _pinInputKey = GlobalKey();
  var _pinValue = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (_, _) {
        return true;
      },
      listener: (context, state) {
        Navigator.pop(context);
      },
      builder: (BuildContext context, AuthState state) => Container(
        color: colors.surfaceBright,
        child: Column(
          children: [
            box16,
            Text(
              l10n.editPin,
              style: context.texts.headlineLarge?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            box16,
            const Divider(height: 2),
            Expanded(
              child: Container(
                color: context.colors.surfaceContainer,
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PinInput(
                      key: _pinInputKey,
                      boxSize: 60.0,
                      pinLength: 4,
                      activeColor: Theme.of(context).colorScheme.primary,
                      errorColor: context.colors.error,
                      obscureText: true,
                      onChanged: (pin) {
                        setState(() {
                          _pinValue = pin;
                        });
                      },
                      onCompleted: (_) {},
                      autofocus: false,
                    ),
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
                    box24,
                    if (state is AuthAuthenticated)
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            UpdatePin(pin: _pinValue, uid: state.user.uid),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            context.l10n.save,
                            style: TextStyle(
                              color: context.colors.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
