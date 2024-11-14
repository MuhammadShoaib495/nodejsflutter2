part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}
final class LoginLoading extends LoginState {}
final class LoginSuccess extends LoginState {
  final Map<String, dynamic> userDetails;
  LoginSuccess(this.userDetails);
}
final class LoginFailure extends LoginState{
  final String message;
  LoginFailure(this.message);
}