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
    // on<AuthLoginWithPinRequested>(_onLoginWithPinRequested);
    // on<AuthLoginWithBiometricRequested>(_onLoginWithBiometricRequested);
    // on<AuthBiometricToggleRequested>(_onBiometricToggleRequested);
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
      emit(
        AuthRegistrationSuccessWithLogin(user: user, biometricEnabled: false),
      );
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
}
