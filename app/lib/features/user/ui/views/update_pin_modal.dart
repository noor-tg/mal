import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/widgets/pin_input.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class UpdatePinModal extends StatefulWidget {
  const UpdatePinModal({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  State<UpdatePinModal> createState() => _UpdatePinModalState();
}

class _UpdatePinModalState extends State<UpdatePinModal> {
  final GlobalKey<State<PinInput>> _pinInputKey = GlobalKey();
  var _pinValue = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (_, _) {
        return true;
      },
      listener: (context, state) {
        Navigator.pop(context);
      },
      builder: (BuildContext context, AuthState state) => Container(
        color: Colors.white,
        child: Column(
          children: [
            box16,
            Text(
              l10n.editPin,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            box16,
            const Divider(height: 2),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PinInput(
                    key: _pinInputKey,
                    boxSize: 60.0,
                    pinLength: 4,
                    activeColor: Theme.of(context).colorScheme.primary,
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

                  box16,
                  if (state is AuthAuthenticated)
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          UpdatePin(pin: _pinValue, uid: state.user.uid),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          widget.l10n.save,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
