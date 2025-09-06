import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        // height: double.infinity,
        // width: double.infinity,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
