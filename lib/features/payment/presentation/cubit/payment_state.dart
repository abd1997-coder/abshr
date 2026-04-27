import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_method.dart';

abstract class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentMethodsLoading extends PaymentState {}

class PaymentMethodsLoaded extends PaymentState {
  final List<PaymentMethod> methods;

  PaymentMethodsLoaded(this.methods);

  @override
  List<Object?> get props => [methods];
}

class PaymentMethodsFailure extends PaymentState {
  final String message;

  PaymentMethodsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentProcessing extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String message;
  PaymentFailure(this.message);

  @override
  List<Object?> get props => [message];
}
