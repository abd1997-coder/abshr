import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:marketplace/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:marketplace/features/cart/domain/entities/checkout_shipping_address.dart';
import 'package:marketplace/features/cart/domain/repositories/cart_repository.dart';
import 'package:marketplace/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:marketplace/features/payment/domain/entities/payment_method.dart';
import 'package:marketplace/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:marketplace/features/payment/presentation/cubit/payment_state.dart';
import 'package:marketplace/features/payment/presentation/payment_success_page.dart';
import 'package:marketplace/l10n/app_localizations.dart';

class PaymentPage extends StatefulWidget {
  final double total;

  const PaymentPage({super.key, required this.total});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const String _regionId = 'reg_01KFAR92G9DD6EESPD97XA6K3M';

  late final PaymentCubit _paymentCubit = getIt.get<PaymentCubit>();

  String _selected = '';
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _paymentCubit.loadPaymentMethods(regionId: _regionId);
  }

  @override
  void dispose() {
    _paymentCubit.close();
    super.dispose();
  }

  ({String first, String last}) _splitName(String? name) {
    final t = (name ?? '').trim();
    if (t.isEmpty) return (first: AppStrings.customerFallback, last: '');
    final parts = t.split(RegExp(r'\s+'));
    if (parts.length == 1) return (first: parts[0], last: '');
    return (first: parts.first, last: parts.sublist(1).join(' '));
  }

  Future<void> _processPayment() async {
    final cartId = getIt<CartRepository>().getCartId();
    if (cartId == null || cartId.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.cartNotFound)),
      );
      return;
    }

    final user = await getIt<AuthLocalDataSource>().getCachedUser();
    final email = user?.email.trim() ?? '';
    if (email.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.pleaseSignInValidEmail)),
      );
      return;
    }

    final names = _splitName(user?.name);
    final shippingAddress = CheckoutShippingAddress(
      firstName: "test",
      lastName: "last",
      address1: 'Al-Hamra Street',
      city: 'Damascus',
      countryCode: 'sy',
      postalCode: '00000',
      province: 'Damascus',
      phone: '+963911234567',
      lat: 33.513,
      lng: 36.292,
    );

    setState(() => _processing = true);
    await _paymentCubit.placeOrder(
      cartId: cartId,
      email: email,
      shippingAddress: shippingAddress,
      shippingOptionId: AppConstants.defaultMobileShippingOptionId,
      paymentProviderId: _selected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final orange = AppConstants.primaryColor;

    return BlocProvider.value(
      value: _paymentCubit,
      child: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentMethodsLoaded &&
              _selected.isEmpty &&
              state.methods.isNotEmpty) {
            setState(() => _selected = state.methods.first.id);
          }
          if (state is PaymentSuccess) {
            getIt<CartCubit>().clear();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PaymentSuccessPage()),
            );
          }
          if (state is PaymentFailure) {
            if (!mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            setState(() => _processing = false);
            context.read<PaymentCubit>().loadPaymentMethods(
              regionId: _regionId,
            );
          }
        },
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.grey.shade100,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black87,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                title: Text(
                  AppStrings.payment,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
              body: Column(
                children: [
                  const SizedBox(height: 12),
                  SizedBox(height: 96, child: _buildMethodsSection()),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.totalColon,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text(
                          '${l10n.currencySymbol}${widget.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            _processing || _selected.isEmpty
                                ? null
                                : _processPayment,
                        child: Text(
                          AppStrings.payAndConfirm,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_processing)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodsSection() {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        if (state is PaymentMethodsLoading || state is PaymentInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PaymentMethodsFailure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message),
                const SizedBox(height: 6),
                TextButton(
                  onPressed:
                      () => context.read<PaymentCubit>().loadPaymentMethods(
                        regionId: _regionId,
                      ),
                  child: Text(AppStrings.retry),
                ),
              ],
            ),
          );
        }
        final methods =
            state is PaymentMethodsLoaded ? state.methods : <PaymentMethod>[];
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: methods.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final method = methods[index];
            return GestureDetector(
              onTap: () => setState(() => _selected = method.id),
              child: _methodCard(
                _iconForMethod(method.label),
                method.label,
                selected: _selected == method.id,
              ),
            );
          },
        );
      },
    );
  }

  IconData _iconForMethod(String label) {
    final normalized = label.toLowerCase();
    if (normalized.contains('cash')) return Icons.money;
    if (normalized.contains('visa') ||
        normalized.contains('card') ||
        normalized.contains('master')) {
      return Icons.credit_card;
    }
    return Icons.account_balance_wallet_outlined;
  }

  Widget _methodCard(IconData icon, String label, {bool selected = false}) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.grey.shade50,
        border:
            selected
                ? Border.all(color: AppConstants.primaryColor, width: 2)
                : null,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: selected ? AppConstants.primaryColor : Colors.grey.shade600,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 9),
          ),
        ],
      ),
    );
  }
}
