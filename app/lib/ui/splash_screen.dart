import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _redirectToLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  void _redirectToLogin() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) context.go('/${Routes.login.name}');
  }
}
