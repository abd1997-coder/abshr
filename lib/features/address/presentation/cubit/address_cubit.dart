import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository _repository;

  AddressCubit(this._repository) : super(AddressInitial());

  Future<void> loadAddresses() async {
    emit(AddressLoading());
    final result = await _repository.getAllAddresses();
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (addresses) => emit(AddressLoaded(addresses)),
    );
  }

  Future<void> addAddress(Address address) async {
    emit(AddressLoading());
    final result = await _repository.addAddress(address);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => loadAddresses(),
    );
  }

  Future<void> updateAddress(Address address) async {
    emit(AddressLoading());
    final result = await _repository.updateAddress(address);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => loadAddresses(),
    );
  }

  Future<void> deleteAddress(String id) async {
    emit(AddressLoading());
    final result = await _repository.deleteAddress(id);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => loadAddresses(),
    );
  }

  Future<void> setDefaultAddress(String id) async {
    final result = await _repository.setDefaultAddress(id);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => loadAddresses(),
    );
  }
}
