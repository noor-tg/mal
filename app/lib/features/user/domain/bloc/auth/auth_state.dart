part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticated extends AuthState {
  final User user;
  final bool biometricEnabled;

  const AuthAuthenticated({required this.user, required this.biometricEnabled});

  @override
  List<Object> get props => [user, biometricEnabled];
}

class AuthError extends AuthState {
  final String message;
  final Map<String, String>? fieldsErrors;

  const AuthError({required this.message, this.fieldsErrors});

  @override
  List<Object?> get props => [message, fieldsErrors];
}

class AuthRegistrationSuccessWithLogin extends AuthState {
  final User user;
  final bool biometricEnabled;

  const AuthRegistrationSuccessWithLogin({
    required this.user,
    required this.biometricEnabled,
  });

  @override
  List<Object> get props => [user, biometricEnabled];
}
