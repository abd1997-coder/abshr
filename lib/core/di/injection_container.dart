import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../utils/storage_service.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/restaurant/data/datasources/restaurant_remote_datasource.dart';
import '../../features/restaurant/data/repositories/restaurant_repository_impl.dart';
import '../../features/restaurant/domain/repositories/restaurant_repository.dart';
import '../../features/restaurant/presentation/cubit/restaurant_cubit.dart';
import '../../features/orders/data/datasources/orders_remote_datasource.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/address/data/datasources/address_remote_datasource.dart';
import '../../features/address/data/repositories/address_repository_impl.dart';
import '../../features/address/domain/repositories/address_repository.dart';
import '../../features/address/presentation/cubit/address_cubit.dart';
import '../../features/product_detail/data/datasources/product_detail_remote_datasource.dart';
import '../../features/product_detail/data/repositories/product_detail_repository_impl.dart';
import '../../features/product_detail/domain/repositories/product_detail_repository.dart';
import '../../features/product_detail/presentation/cubit/product_detail_cubit.dart';
import '../../features/cart/data/datasources/cart_remote_datasource.dart';
import '../../features/cart/data/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/cart/domain/usecases/submit_mobile_checkout.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../features/payment/data/datasources/payment_remote_datasource.dart';
import '../../features/payment/data/payment_repository_impl.dart';
import '../../features/payment/domain/repositories/payment_repository.dart';
import '../../features/payment/domain/usecases/get_payment_methods.dart';
import '../../features/payment/domain/usecases/process_payment.dart';
import '../../features/payment/presentation/cubit/payment_cubit.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Core
  getIt.registerLazySingleton(() => StorageService(getIt()));
  getIt.registerLazySingleton(() => ApiClient(getIt()));

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt(), getIt()),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));

  // Home
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt()),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));

  // Restaurant
  getIt.registerLazySingleton<RestaurantRemoteDataSource>(
    () => RestaurantRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(getIt()),
  );
  getIt.registerFactory<RestaurantCubit>(() => RestaurantCubit(getIt()));

  // Orders
  getIt.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<OrderRepository>(
    () => OrdersRepositoryImpl(getIt()),
  );
  getIt.registerFactory<OrdersCubit>(() => OrdersCubit(getIt()));

  // Profile
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));

  // Address
  getIt.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      remoteDataSource: getIt(),
      storage: getIt(),
    ),
  );
  getIt.registerFactory<AddressCubit>(() => AddressCubit(getIt()));

  // Product Detail
  getIt.registerLazySingleton<ProductDetailRemoteDataSource>(
    () => ProductDetailRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProductDetailRepository>(
    () => ProductDetailRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerFactory<ProductDetailCubit>(() => ProductDetailCubit(getIt()));

  // Cart
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<CartCubit>(() => CartCubit(getIt()));

  // Favorites
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(getIt())..load(),
  );

  // Payment
  getIt.registerLazySingleton<PaymentRemoteDataSource>(() => PaymentRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => ProcessPayment(getIt()));
  getIt.registerLazySingleton(() => GetPaymentMethods(getIt()));
  getIt.registerLazySingleton(() => SubmitMobileCheckout(getIt()));
  getIt.registerFactory<PaymentCubit>(
    () => PaymentCubit(getIt(), getIt(), getIt()),
  );
}
