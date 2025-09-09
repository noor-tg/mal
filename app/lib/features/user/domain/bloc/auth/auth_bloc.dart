import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/features/user/data/services/biometric_service.dart';
import 'package:mal/features/user/domain/repositories/user_repository.dart';
import 'package:mal/shared/data/models/user.dart';
import 'package:mal/utils.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysprovider;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository repo;

  AuthBloc({required this.repo}) : super(const AuthInitial()) {
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthRegisterAndLoginRequested>(_onRegisterAndLoginRequested);
    on<AuthLoginWithPinRequested>(_onLoginWithPinRequested);
    on<AuthLoginWithBiometricRequested>(_onLoginWithBiometricRequested);
    on<AuthBiometricToggleRequested>(_onBiometricToggleRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<UpdateName>(_onUpdateName);
    on<UpdatePin>(_onUpdatePin);
    on<UpdateAvatar>(_onUpdateAvatar);
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

      emit(
        AuthAuthenticated(user: user, biometricEnabled: user.biometricEnabled),
      );
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

  FutureOr<void> _onLoginWithBiometricRequested(
    AuthLoginWithBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Check if biometric is available
      final isAvailable = await BiometricService.isBiometricAvailable();
      if (!isAvailable) {
        emit(
          const AuthError(message: 'Biometric authentication not available'),
        );
        return;
      }

      // Check if user has biometric enabled
      final biometricEnabled = await BiometricService.getBiometricPreference(
        event.name,
      );
      if (!biometricEnabled) {
        emit(
          const AuthError(
            message: 'Biometric authentication not enabled for this user',
          ),
        );
        return;
      }

      // Authenticate with biometric
      final authResult = await BiometricService.authenticate();

      switch (authResult) {
        case BiometricAuthResult.success:
          final user = await repo.getUserByName(event.name);
          if (user != null) {
            await BiometricService.setLastAuthenticatedUser(event.name);
            logger.i(user);
            emit(AuthAuthenticated(user: user, biometricEnabled: true));
          } else {
            emit(const AuthError(message: 'User not found'));
          }
          break;
        case BiometricAuthResult.failed:
          emit(const AuthError(message: 'Biometric authentication failed'));
          break;
        case BiometricAuthResult.notAvailable:
          emit(
            const AuthError(message: 'Biometric authentication not available'),
          );
          break;
        case BiometricAuthResult.notEnrolled:
          emit(const AuthError(message: 'No biometric credentials enrolled'));
          break;
        case BiometricAuthResult.lockedOut:
          emit(const AuthError(message: 'Biometric authentication locked out'));
          break;
        case BiometricAuthResult.cancelled:
          emit(const AuthError(message: 'Biometric authentication canceled'));
          break;
        case BiometricAuthResult.systemCancelled:
          emit(
            const AuthError(message: 'Biometric authentication SystemCancel'),
          );
          break;
        case BiometricAuthResult.invalidContext:
          emit(
            const AuthError(message: 'Biometric authentication invalidContext'),
          );
        case BiometricAuthResult.notSetUp:
          emit(const AuthError(message: 'Biometric authentication notSetup'));
      }
    } catch (e) {
      emit(AuthError(message: 'Biometric login failed: ${e.toString()}'));
    }
  }

  FutureOr<void> _onUpdateName(
    UpdateName event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      final db = await createOrOpenDB();
      var user = await repo.getUser(event.uid);
      await BiometricService.removeBiometricPreference(user.name);
      await db.update(
        'users',
        {'name': event.name},
        where: 'uid = ?',
        whereArgs: [event.uid],
      );

      await BiometricService.setBiometricPreference(
        event.name,
        user.biometricEnabled,
      );

      user = await repo.getUser(event.uid);

      emit(
        AuthAuthenticated(user: user, biometricEnabled: user.biometricEnabled),
      );
    }
  }

  FutureOr<void> _onUpdatePin(UpdatePin event, Emitter<AuthState> emit) async {
    if (state is AuthAuthenticated) {
      final db = await createOrOpenDB();

      var user = await repo.getUser(event.uid);
      final hashed = repo.hashPin(event.pin, user.salt);

      await db.update(
        'users',
        {'pin_hash': hashed},
        where: 'uid = ?',
        whereArgs: [event.uid],
      );

      user = await repo.getUser(event.uid);

      emit(
        AuthAuthenticated(user: user, biometricEnabled: user.biometricEnabled),
      );
    }
  }

  FutureOr<void> _onUpdateAvatar(
    UpdateAvatar event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      final db = await createOrOpenDB();
      final stored = await storImage(event.avatar);

      await db.update(
        'users',
        {'avatar': stored.path},
        where: 'uid = ?',
        whereArgs: [event.uid],
      );

      final user = await repo.getUser(event.uid);

      emit(
        AuthAuthenticated(user: user, biometricEnabled: user.biometricEnabled),
      );
    }
  }

  Future<File> storImage(File image) async {
    final appDir = await sysprovider.getApplicationDocumentsDirectory();
    final ext = path.extension(image.path);
    final uid = uuid.v4();
    final name = '$uid$ext';
    return image.copy('${appDir.path}/$name');
  }
}
