part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}

class LoginSuccess extends LoginState {}

class LoginSuccessCashier extends LoginState {}

class LoginException extends LoginState {
  final String title;

  LoginException(this.title);
}
