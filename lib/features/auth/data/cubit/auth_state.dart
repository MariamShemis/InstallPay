import 'package:smart_installment_management/features/auth/data/model/user_model.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class RegisterLoadingState extends AuthState {}

class RegisterSuccessState extends AuthState {
  final UserModel user;

  RegisterSuccessState(this.user);
}

class RegisterErrorState extends AuthState {
  final String message;

  RegisterErrorState(this.message);
}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final UserModel user;

  LoginSuccessState(this.user);
}

class LoginErrorState extends AuthState {
  final String message;

  LoginErrorState(this.message);
}

class ResetPasswordLoadingState extends AuthState {}

class ResetPasswordSuccessState extends AuthState {}

class ResetPasswordErrorState extends AuthState {
  final String message;

  ResetPasswordErrorState(this.message);
}

class LogoutLoadingState extends AuthState {}

class LogoutSuccessState extends AuthState {}

class LogoutErrorState extends AuthState {
  final String message;

  LogoutErrorState(this.message);
}
