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
  final Statistics statistics;

  const AuthAuthenticated({
    required this.user,
    required this.biometricEnabled,
    required this.statistics,
  });

  @override
  List<Object> get props => [user, biometricEnabled, statistics];
}

class AuthError extends AuthState {
  final String message;
  final Map<String, String>? fieldsErrors;

  const AuthError({required this.message, this.fieldsErrors});

  @override
  List<Object?> get props => [message, fieldsErrors];
}
