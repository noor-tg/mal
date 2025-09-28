import 'package:mal/features/user/domain/bloc/auth/auth_bloc.dart';

String? getFieldError(AuthState state, String field) {
  if (state is AuthError && state.fieldsErrors != null) {
    return state.fieldsErrors![field];
  }
  return null;
}
