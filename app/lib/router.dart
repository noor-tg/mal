import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';
import 'package:mal/features/user/ui/views/login_screen.dart';
import 'package:mal/features/user/ui/views/profile_screen.dart';
import 'package:mal/features/user/ui/views/register_screen.dart';
import 'package:mal/ui/app_container.dart';
import 'package:mal/ui/splash_screen.dart';

GoRouter createAppRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isSplashRoute = state.matchedLocation == '/';
      final isLoginRoute = state.matchedLocation == '/login';
      final isRegisterRoute = state.matchedLocation == '/register';

      // If authenticated and trying to access login/register/splash, redirect to dashboard
      if (authState is AuthAuthenticated &&
          (isRegisterRoute || isSplashRoute || isLoginRoute)) {
        return '/dashboard';
      }

      // If not authenticated and trying to access dashboard, redirect to login
      if (authState is AuthUnauthenticated &&
          (!isSplashRoute && !isLoginRoute && !isRegisterRoute)) {
        return '/login';
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
