part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthOtpSent extends AuthState {
  final String phoneNumber;
  final bool isLogin;
  final String? firstName;
  final String? lastName;

  const AuthOtpSent({
    required this.phoneNumber,
    required this.isLogin,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [phoneNumber, isLogin, firstName, lastName];
}

class AuthAuthenticatedFromLogin extends AuthState {
  final User user;

  const AuthAuthenticatedFromLogin(this.user);

  @override
  List<Object?> get props => [user];
}
