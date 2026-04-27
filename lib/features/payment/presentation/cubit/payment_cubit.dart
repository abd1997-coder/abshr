import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/errors/exceptions.dart';
import 'package:marketplace/features/cart/domain/entities/checkout_shipping_address.dart';
import 'package:marketplace/features/cart/domain/usecases/submit_mobile_checkout.dart';
import '../../domain/usecases/get_payment_methods.dart';
import '../../domain/usecases/process_payment.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(
    this._processPayment,
    this._getPaymentMethods,
    this._submitMobileCheckout,
  ) : super(PaymentInitial());

  final ProcessPayment _processPayment;
  final GetPaymentMethods _getPaymentMethods;
  final SubmitMobileCheckout _submitMobileCheckout;

  Future<void> loadPaymentMethods({required String regionId}) async {
    emit(PaymentMethodsLoading());
    try {
      final methods = await _getPaymentMethods.call(regionId: regionId);
      if (methods.isEmpty) {
        emit(PaymentMethodsFailure('No payment methods available'));
        return;
      }
      emit(PaymentMethodsLoaded(methods));
    } catch (_) {
      emit(PaymentMethodsFailure('Failed to load payment methods'));
    }
  }

  Future<void> pay(String method, double amount) async {
    emit(PaymentProcessing());
    try {
      final ok = await _processPayment.call(method, amount);
      if (ok) {
        emit(PaymentSuccess());
      } else {
        emit(PaymentFailure('Payment was declined'));
      }
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> placeOrder({
    required String cartId,
    required String email,
    required CheckoutShippingAddress shippingAddress,
    required String shippingOptionId,
    required String paymentProviderId,
  }) async {
    try {
      await _submitMobileCheckout(
        cartId: cartId,
        email: email,
        shippingAddress: shippingAddress,
        shippingOptionId: shippingOptionId,
        paymentProviderId: paymentProviderId,
      );
      emit(PaymentSuccess());
    } on DioException catch (e) {
      if (e.error is ValidationException) {
        emit(PaymentFailure((e.error! as ValidationException).message));
      } else if (e.error is ServerException) {
        emit(PaymentFailure((e.error! as ServerException).message));
      } else if (e.error is NetworkException) {
        emit(PaymentFailure((e.error! as NetworkException).message));
      } else {
        emit(PaymentFailure(e.message ?? e.toString()));
      }
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}
