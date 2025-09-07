import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/features/user/data/services/biometric_service.dart';
import 'package:mal/features/user/domain/repositories/user_repository.dart';
import 'package:mal/shared/data/models/user.dart';
import 'package:mal/utils.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository repo;

  AuthBloc({required this.repo}) : super(const AuthInitial()) {
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthRegisterAndLoginRequested>(_onRegisterAndLoginRequested);
    on<AuthLoginWithPinRequested>(_onLoginWithPinRequested);
    // on<AuthLoginWithBiometricRequested>(_onLoginWithBiometricRequested);
    on<AuthBiometricToggleRequested>(_onBiometricToggleRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  FutureOr<void> _onRegisterAndLoginRequested(
    AuthRegisterAndLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    logger.i('loading');
    emit(const AuthLoading());
    logger.i('loaded');

    try {
      final Map<String, String> errors = {};

      // Validate input
      if (event.name.trim().isEmpty) {
        errors['name'] = 'Name cannot be empty';
      } else if (event.name.trim().length < 2) {
        errors['name'] = 'Name must be at least 2 characters';
      }

      if (event.pin.isEmpty) {
        errors['pin'] = 'Please enter a PIN';
      } else if (event.pin.length < 4) {
        errors['pin'] = 'PIN must be at least 4 digits';
      }

      if (errors.isNotEmpty) {
        logger.i('not valid');
        emit(
          AuthError(
            message: 'Please fix the errors below',
            fieldsErrors: errors,
          ),
        );
        return;
      }

      logger.i('register to db');
      final success = await repo.register(
        name: event.name.trim(),
        pin: event.pin,
      );
      logger.i('register completed');

      if (!success) {
        logger.i('already exist');
        emit(const AuthError(message: 'User already exists'));
        return;
      }

      logger.i('try login');
      final user = await repo.verifyPin(event.name, event.pin);

      if (user == null) {
        logger.i('login failed');
        emit(
          const AuthError(message: 'Registration successful but login failed'),
        );
        return;
      }

      logger.i('store uid');
      await BiometricService.setLastAuthenticatedUser(user.uid);

      logger.i('accept as logged in');
      emit(AuthAuthenticated(user: user, biometricEnabled: false));
    } catch (e, t) {
      logger
        ..e('register failed')
        ..e(e)
        ..t(t);
      emit(AuthError(message: 'Registration failed: ${e.toString()}'));
    }
  }

  FutureOr<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      logger.i('auth check started');
      final lastUser = await BiometricService.getLastAuthenticatedUser();
      if (lastUser == null) {
        logger.i('auth check user is null');
        emit(const AuthUnauthenticated());
        return;
      }
      logger.i('auth check user is found');
      final user = await repo.getUser(lastUser);
      final biometricEnabled = await BiometricService.getBiometricPreference(
        lastUser,
      );
      logger.i('auth check user is authenticated');
      emit(AuthAuthenticated(user: user, biometricEnabled: biometricEnabled));
    } catch (e, t) {
      logger
        ..e(e)
        ..t(t)
        ..i('auth check user is not authenticated');
      emit(const AuthUnauthenticated());
    }
  }

  FutureOr<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthUnauthenticated());
  }

  FutureOr<void> _onLoginWithPinRequested(
    AuthLoginWithPinRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final Map<String, String> errors = {};

      // Validate input
      if (event.name.trim().isEmpty) {
        errors['name'] = 'Name cannot be empty';
      } else if (event.name.trim().length < 2) {
        errors['name'] = 'Name must be at least 2 characters';
      }

      if (event.pin.isEmpty) {
        errors['pin'] = 'Please enter a PIN';
      } else if (event.pin.length < 4) {
        errors['pin'] = 'PIN must be at least 4 digits';
      }

      if (errors.isNotEmpty) {
        emit(
          AuthError(
            message: 'Please fix the errors below',
            fieldsErrors: errors,
          ),
        );
        return;
      }

      final user = await repo.verifyPin(event.name, event.pin);

      if (user == null) {
        emit(const AuthError(message: 'login failed'));
        return;
      }

      await BiometricService.setLastAuthenticatedUser(user.uid);

      emit(AuthAuthenticated(user: user, biometricEnabled: false));
    } catch (e, t) {
      logger
        ..e('login failed')
        ..e(e)
        ..t(t);
      emit(AuthError(message: 'Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onBiometricToggleRequested(
    AuthBiometricToggleRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (event.enabled) {
        // Check if biometric is available before enabling
        final isAvailable = await BiometricService.isBiometricAvailable();
        if (!isAvailable) {
          emit(
            const AuthError(
              message: 'Biometric authentication not available on this device',
            ),
          );
          return;
        }

        // Test biometric authentication before enabling
        final authResult = await BiometricService.authenticate();

        if (authResult != BiometricAuthResult.success) {
          emit(const AuthError(message: 'Biometric verification failed'));
          return;
        }
      }

      // Update preference
      await BiometricService.setBiometricPreference(event.name, event.enabled);
      await repo.toggleBiometric(event.name, event.enabled);

      // If currently authenticated, update state
      if (state is AuthAuthenticated) {
        final currentState = state as AuthAuthenticated;
        emit(
          AuthAuthenticated(
            user: currentState.user,
            biometricEnabled: event.enabled,
          ),
        );
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to toggle biometric: ${e.toString()}'));
    }
  }
}
