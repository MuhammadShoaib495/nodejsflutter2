part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginRequested extends LoginEvent{
  final String username;
  final String password;
  LoginRequested(this.username, this.password);
}
