import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final result = await _repository.getProfile();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile(Profile profile) async {
    emit(ProfileLoaded(profile, isUpdating: true));
    final result = await _repository.updateProfile(profile);
    await result.fold<Future<void>>(
      (failure) async {
        emit(ProfileError(failure.message));
      },
      (_) async {
        final reload = await _repository.getProfile();
        reload.fold(
          (failure) => emit(ProfileError(failure.message)),
          (p) => emit(ProfileLoaded(p)),
        );
      },
    );
  }
}
