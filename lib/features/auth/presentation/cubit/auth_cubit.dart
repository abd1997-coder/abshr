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

  Future<void> registerWithPhone({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    emit(AuthLoading());
    final result = await _repository.registerWithPhone(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(
        AuthOtpSent(
          phoneNumber: phone,
          isLogin: false,
          firstName: firstName,
          lastName: lastName,
        ),
      ),
    );
  }

  Future<void> loginWithPhone(String phone) async {
    emit(AuthLoading());
    final result = await _repository.loginWithPhone(phone);

    result.fold((failure) => emit(AuthError(failure.message)), (loginResponse) {
      if (loginResponse.otpRequired == true) {
        emit(AuthOtpSent(phoneNumber: phone, isLogin: true));
      } else if (loginResponse.token != null &&
          loginResponse.token!.isNotEmpty &&
          loginResponse.customer != null) {
        emit(AuthAuthenticatedFromLogin(loginResponse.customer!));
      } else {
        emit(AuthOtpSent(phoneNumber: phone, isLogin: true));
      }
    });
  }

  Future<void> sendOtp({
    required String phone,
    required bool isLogin,
    String? firstName,
    String? lastName,
  }) async {
    if (isLogin) {
      await loginWithPhone(phone);
      return;
    }

    if (firstName == null || lastName == null) {
      emit(AuthError('Missing name information for resend.'));
      return;
    }

    await registerWithPhone(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
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

  Future<void> verifyOtp({
    required String phone,
    required String otp,
    required bool isLogin,
  }) async {
    emit(AuthLoading());
    final result = await _repository.verifyOtp(
      phone: phone,
      otp: otp,
      isLogin: isLogin,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
