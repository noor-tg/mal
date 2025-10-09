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

enum Routes { login, register, dashboard, onboarding, splash, profile }

GoRouter createAppRouter(BuildContext context, bool seenOnBoarding) {
  return GoRouter(
    initialLocation: '/${Routes.splash.name}',
    redirect: (context, state) {
      // if (!seenOnBoarding) return '/${Routes.onboarding.name}';

      final authState = context.read<AuthBloc>().state;
      final isSplashRoute = state.matchedLocation == '/${Routes.splash.name}';
      final isLoginRoute = state.matchedLocation == '/${Routes.login.name}';
      final isRegisterRoute =
          state.matchedLocation == '/${Routes.register.name}';

      // If authenticated and trying to access login/register/splash, redirect to dashboard
      final isPublic = isRegisterRoute || isLoginRoute || isSplashRoute;

      if (authState is AuthAuthenticated && isPublic) {
        return '/${Routes.dashboard.name}';
      }

      final notPublic = !isLoginRoute && !isRegisterRoute && !isSplashRoute;

      // If not authenticated and trying to access dashboard, redirect to login
      if (authState is AuthUnauthenticated && notPublic) {
        return '/${Routes.login.name}';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/${Routes.splash.name}',
        name: Routes.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/${Routes.onboarding.name}',
        name: Routes.onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/${Routes.login.name}',
        name: Routes.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/${Routes.register.name}',
        name: Routes.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/${Routes.dashboard.name}',
        name: Routes.dashboard.name,
        builder: (context, state) => const AppContainer(),
      ),
      GoRoute(
        path: '/${Routes.profile.name}',
        name: Routes.profile.name,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
