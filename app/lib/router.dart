import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/views/login_screen.dart';
import 'package:mal/features/user/ui/views/profile_screen.dart';
import 'package:mal/features/user/ui/views/register_screen.dart';
import 'package:mal/ui/app_container.dart';
import 'package:mal/ui/onboarding_screen.dart';
import 'package:mal/ui/splash_screen.dart';
import 'package:mal/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Routes { login, register, dashboard, onboarding }

GoRouter createAppRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final authState = context.read<AuthBloc>().state;
      final isSplashRoute = state.matchedLocation == '/';
      final isLoginRoute = state.matchedLocation == '/${Routes.login.name}';
      final isOnboardingRoute =
          state.matchedLocation == '/${Routes.onboarding.name}';
      final isRegisterRoute =
          state.matchedLocation == '/${Routes.register.name}';

      // If authenticated and trying to access login/register/splash, redirect to dashboard
      if (authState is AuthAuthenticated && (isRegisterRoute || isLoginRoute)) {
        return '/${Routes.dashboard.name}';
      }

      // If not authenticated and trying to access dashboard, redirect to login
      if (authState is AuthUnauthenticated &&
          (!isLoginRoute &&
              !isRegisterRoute &&
              !isOnboardingRoute &&
              !isSplashRoute)) {
        return '/${Routes.login.name}';
      }

      if (isSplashRoute && await checkOnboarding() == false) {
        return '/onboarding';
      }
      if (isSplashRoute && await checkOnboarding() == true) {
        if (authState is AuthAuthenticated) {
          return '/${Routes.dashboard.name}';
        }
        if (authState is AuthUnauthenticated) {
          return '/login';
        }
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const AppContainer(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}

Future<bool> checkOnboarding() async {
  logger.i('check on boarding');
  final prefs = await SharedPreferences.getInstance();
  final seen = prefs.getBool('seen_onboarding') ?? false;

  logger.i(seen);
  return seen;
}
