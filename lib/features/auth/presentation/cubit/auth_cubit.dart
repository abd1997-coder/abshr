import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final isAuthResult = await _repository.isAuthenticated();

    isAuthResult.fold((failure) => emit(AuthError(failure.message)), (
      isAuthenticated,
    ) {
      if (isAuthenticated) {
        _loadCurrentUser();
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> _loadCurrentUser() async {
    final userResult = await _repository.getCurrentUser();
    userResult.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await _repository.login(email, password);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    emit(AuthLoading());
    final result = await _repository.register(
      email,
      password,
      firstName,
      lastName,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await _repository.logout();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  /// Sends OTP to [phoneNumber]. On success emits [AuthOtpSent].
  Future<void> sendOtp(String phoneNumber) async {
    emit(AuthLoading());
    final result = await _repository.sendOtp(phoneNumber);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (verificationId) => emit(AuthOtpSent(
        verificationId: verificationId,
        phoneNumber: phoneNumber,
      )),
    );
  }

  /// Verifies OTP and signs in. [verificationId] and [smsCode] from OTP flow.
  Future<void> verifyOtp(String verificationId, String smsCode) async {
    emit(AuthLoading());
    final result = await _repository.verifyOtp(verificationId, smsCode);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
