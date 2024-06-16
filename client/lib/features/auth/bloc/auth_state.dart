import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

final class Authenticated extends AuthState {
  final String token;
  final int userId;
  final String userRole;

  const Authenticated(this.token, this.userId, this.userRole);

  @override
  List<Object> get props => [token];
}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthUnauthenticated extends AuthState {
  @override
  List<Object> get props => [];
}