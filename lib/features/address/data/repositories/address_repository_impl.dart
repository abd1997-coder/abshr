import 'package:dartz/dartz.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/errors/exceptions.dart';
import 'package:marketplace/core/errors/failures.dart';
import 'package:marketplace/core/utils/storage_service.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_remote_datasource.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl({
    required AddressRemoteDataSource remoteDataSource,
    required StorageService storage,
  }) : _remote = remoteDataSource,
       _storage = storage;

  final AddressRemoteDataSource _remote;
  final StorageService _storage;

  List<Address> _withDefaultFlag(List<AddressModel> models) {
    final defaultId = _storage.getString(
      AppConstants.defaultShippingAddressIdKey,
    );
    return models.map((m) {
      final e = m.toEntity();
      final isDef =
          (defaultId != null && defaultId.isNotEmpty)
              ? e.id == defaultId
              : e.isDefault;
      return Address(
        id: e.id,
        street: e.street,
        city: e.city,
        zipCode: e.zipCode,
        phone: e.phone,
        lat: e.lat,
        lng: e.lng,
        isDefault: isDef,
      );
    }).toList();
  }

  @override
  Future<Either<Failure, List<Address>>> getAllAddresses() async {
    try {
      final list = await _remote.getAddresses();
      return Right(_withDefaultFlag(list));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on DioException catch (e) {
      final err = e.error;
      if (err is ValidationException) {
        return Left(ValidationFailure(err.message));
      }
      if (err is ServerException) {
        return Left(ServerFailure(err.message));
      }
      if (err is NetworkException) {
        return Left(NetworkFailure(err.message));
      }
      return Left(ServerFailure(e.message ?? 'Failed to load addresses'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addAddress(Address address) async {
    try {
      final model = AddressModel.fromEntity(address);
      await _remote.createAddress(model);
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on DioException catch (e) {
      final err = e.error;
      if (err is ValidationException) {
        return Left(ValidationFailure(err.message));
      }
      if (err is ServerException) {
        return Left(ServerFailure(err.message));
      }
      if (err is NetworkException) {
        return Left(NetworkFailure(err.message));
      }
      return Left(ServerFailure(e.message ?? 'Failed to add address'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAddress(Address address) async {
    if (address.id.isEmpty) {
      return const Left(ServerFailure('Invalid address id'));
    }
    try {
      final model = AddressModel.fromEntity(address);
      await _remote.updateAddress(address.id, model);
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on DioException catch (e) {
      final err = e.error;
      if (err is ValidationException) {
        return Left(ValidationFailure(err.message));
      }
      if (err is ServerException) {
        return Left(ServerFailure(err.message));
      }
      if (err is NetworkException) {
        return Left(NetworkFailure(err.message));
      }
      return Left(ServerFailure(e.message ?? 'Failed to update address'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String id) async {
    try {
      await _remote.deleteAddress(id);
      final defaultId = _storage.getString(
        AppConstants.defaultShippingAddressIdKey,
      );
      if (defaultId == id) {
        await _storage.remove(AppConstants.defaultShippingAddressIdKey);
      }
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on DioException catch (e) {
      final err = e.error;
      if (err is ValidationException) {
        return Left(ValidationFailure(err.message));
      }
      if (err is ServerException) {
        return Left(ServerFailure(err.message));
      }
      if (err is NetworkException) {
        return Left(NetworkFailure(err.message));
      }
      return Left(ServerFailure(e.message ?? 'Failed to delete address'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress(String id) async {
    try {
      await _storage.setString(AppConstants.defaultShippingAddressIdKey, id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
