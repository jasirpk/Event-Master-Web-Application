part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

// .................Authentication............!

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;
  Authenticated(this.user);
}

class ValidationSuccess extends AuthState {}

class UnAuthenticated extends AuthState {}

// error message...!

class AuthenticatedErrors extends AuthState {
  final String message;

  AuthenticatedErrors({required this.message});
}
// ......................validation..................!

class TextValid extends AuthState {}

class TextInvalid extends AuthState {
  final String message;

  TextInvalid({required this.message});
}

class passwordValid extends AuthState {}

class passwordInvalid extends AuthState {
  final String message;

  passwordInvalid({required this.message});
}

// view Password...!

class PasswordVisibilityToggled extends AuthState {
  final bool isVisible;

  PasswordVisibilityToggled({required this.isVisible});
}
