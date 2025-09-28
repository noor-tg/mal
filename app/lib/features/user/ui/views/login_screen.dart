import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/features/user/ui/views/login_form.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;
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
                  l10n.login,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
