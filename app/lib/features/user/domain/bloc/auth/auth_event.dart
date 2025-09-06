part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthRegisterAndLoginRequested extends AuthEvent {
  final String name;
  final String pin;

  const AuthRegisterAndLoginRequested({required this.name, required this.pin});

  @override
  List<Object> get props => [name, pin];
}

final class AuthLoginWithPinRequested extends AuthEvent {
  final String name;
  final String pin;

  const AuthLoginWithPinRequested({required this.name, required this.pin});

  @override
  List<Object> get props => [name, pin];
}

final class AuthLoginWithBiometricRequested extends AuthEvent {
  final String name;

  const AuthLoginWithBiometricRequested({required this.name});

  @override
  List<Object> get props => [name];
}

final class AuthBiometricToggleRequested extends AuthEvent {
  final String name;
  final bool enabled;

  const AuthBiometricToggleRequested({
    required this.name,
    required this.enabled,
  });

  @override
  List<Object> get props => [name, enabled];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

final class AuthCheckStatusRequested extends AuthEvent {
  const AuthCheckStatusRequested();
}
