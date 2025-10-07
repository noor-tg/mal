part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthReset extends AuthEvent {}

final class AuthRegisterAndLoginRequested extends AuthEvent {
  final String name;
  final String pin;
  final AppLocalizations l10n;

  const AuthRegisterAndLoginRequested({
    required this.name,
    required this.pin,
    required this.l10n,
  });

  @override
  List<Object> get props => [name, pin, l10n];
}

final class AuthLoginWithPinRequested extends AuthEvent {
  final String name;
  final String pin;
  final AppLocalizations l10n;

  const AuthLoginWithPinRequested({
    required this.name,
    required this.pin,
    required this.l10n,
  });

  @override
  List<Object> get props => [name, pin, l10n];
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

final class AuthRefreshData extends AuthEvent {
  final String uid;
  const AuthRefreshData(this.uid);
}

final class UpdateName extends AuthEvent {
  final String name;
  final String uid;

  const UpdateName({required this.name, required this.uid});

  @override
  List<Object> get props => [name, uid];
}

final class UpdatePin extends AuthEvent {
  final String pin;
  final String uid;

  const UpdatePin({required this.pin, required this.uid});

  @override
  List<Object> get props => [pin, uid];
}

final class UpdateAvatar extends AuthEvent {
  final File avatar;
  final String uid;

  const UpdateAvatar({required this.avatar, required this.uid});

  @override
  List<Object> get props => [avatar, uid];
}
