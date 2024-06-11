part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

// .....................Authentication............!

// login...!

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent({required this.email, required this.password});
}

// signUp...!

class SignUp extends AuthEvent {
  final UserModel userModel;

  SignUp({required this.userModel});
}

// logout...!
class Logout extends AuthEvent {}

// .....................Form Validation..............!
class TextFieldTextChanged extends AuthEvent {
  final String text;

  TextFieldTextChanged({required this.text});
}

class TextFieldPasswordChanged extends AuthEvent {
  final String password;

  TextFieldPasswordChanged({required this.password});
}

// view Password...!

class TogglePasswordVisiblility extends AuthEvent {}

// error message...!

class AuthenticationErrors extends AuthEvent {
  final String errorMessage;

  AuthenticationErrors(this.errorMessage);
}

// is registered...!

class CheckUsrEvent extends AuthEvent {}
