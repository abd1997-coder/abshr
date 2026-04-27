import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:marketplace/core/utils/toast_service.dart';
import 'package:marketplace/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:marketplace/features/auth/presentation/pages/login_page.dart';
import 'package:marketplace/features/auth/presentation/pages/register_page.dart';
import 'package:marketplace/features/address/domain/entities/address.dart';
import 'package:marketplace/features/address/presentation/cubit/address_cubit.dart';
import 'package:marketplace/features/address/presentation/pages/address_page.dart';
import 'package:marketplace/features/cart/domain/entities/cart_item.dart';
import 'package:marketplace/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:marketplace/features/cart/presentation/cubit/cart_state.dart';
import 'package:marketplace/features/payment/presentation/payment_page.dart';
import 'package:marketplace/l10n/app_localizations.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final CartCubit _cartCubit;
  late final AddressCubit _addressCubit;
  Address? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _cartCubit = getIt.get<CartCubit>();
    _addressCubit = getIt.get<AddressCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthCubit>();
      if (auth.state is AuthAuthenticated) {
        _cartCubit.load();
        _addressCubit.loadAddresses();
      }
    });
  }

  @override
  void dispose() {
    _addressCubit.close();
    super.dispose();
  }

  void _onAddressesLoaded(AddressLoaded state) {
    final list = state.addresses;
    if (list.isEmpty) {
      if (_selectedAddress != null) setState(() => _selectedAddress = null);
      return;
    }
    final id = _selectedAddress?.id;
    final stillValid = id != null && list.any((a) => a.id == id);
    if (!stillValid) {
      final defaults = list.where((a) => a.isDefault);
      setState(() {
        _selectedAddress = defaults.isNotEmpty ? defaults.first : list.first;
      });
    }
  }

  String _addressHeading(Address a) {
    final s = a.street.trim();
    if (s.isNotEmpty) return s;
    final first = a.fullAddress.split('\n').first.trim();
    if (first.isNotEmpty) return first;
    return AppStrings.savedAddressFallback;
  }

  String _oneLineAddress(String full) {
    return full
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .join(' · ');
  }

  void _confirmRemoveLineItem(BuildContext context, String lineItemId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppStrings.removeFromCartTitle),
          content: Text(AppStrings.removeFromCartMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _cartCubit.remove(lineItemId);
              },
              child: Text(
                AppStrings.delete,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddressPicker(List<Address> addresses) {
    final orange = AppConstants.primaryColor;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 12, 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.whereShouldWeDeliver,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppStrings.tapAddressToUse,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const AddressPage(),
                                ),
                              )
                              .then((_) {
                                if (mounted) _addressCubit.loadAddresses();
                              });
                        },
                        child: Text(
                          AppStrings.editList,
                          style: TextStyle(
                            color: orange,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final a = addresses[index];
                      final selected = _selectedAddress?.id == a.id;
                      return Material(
                        color:
                            selected
                                ? orange.withValues(alpha: 0.08)
                                : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedAddress = a);
                            Navigator.pop(ctx);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  selected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color:
                                      selected ? orange : Colors.grey.shade400,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                            child: Text(
                                              _addressHeading(a),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade800,
                                              ),
                                            ),
                                          ),
                                          if (a.isDefault) ...[
                                            const SizedBox(width: 6),
                                            Text(
                                              AppStrings.defaultBadge,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: orange,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        a.fullAddress,
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartAuthShell({
    required Color orange,
    required Widget body,
  }) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.cart,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppStrings.doneUpper,
                      style: TextStyle(
                        color: orange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestSignInBody(BuildContext context, Color orange) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 72, color: orange),
          const SizedBox(height: 20),
          Text(
            AppStrings.cartSignInTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.cartSignInSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder:
                        (_) => const LoginPage(navigateToHomeOnSuccess: false),
                  ),
                );
              },
              child: Text(
                AppStrings.login,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: orange, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder:
                        (_) =>
                            const RegisterPage(replaceStackOnSuccess: false),
                  ),
                );
              },
              child: Text(
                AppStrings.signup,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: orange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _total(List<CartItem> items) {
    return items.fold(0.0, (sum, c) {
      final raw = c.item.price.replaceAll(RegExp(r'[^0-9\.]'), '');
      final p = double.tryParse(raw) ?? 0.0;
      return sum + p * c.quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final orange = AppConstants.primaryColor;
    final authCubit = context.read<AuthCubit>();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cartCubit),
        BlocProvider.value(value: _addressCubit),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        bloc: authCubit,
        listenWhen: (previous, current) =>
            current is AuthAuthenticated && previous is! AuthAuthenticated,
        listener: (context, state) {
          _cartCubit.load();
          _addressCubit.loadAddresses();
          showSuccessToast(context, AppStrings.cartSignedInToast);
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          bloc: authCubit,
          builder: (context, authState) {
            if (authState is! AuthAuthenticated) {
              if (authState is AuthInitial || authState is AuthLoading) {
                return _buildCartAuthShell(
                  orange: orange,
                  body: const Center(child: CircularProgressIndicator()),
                );
              }
              return _buildCartAuthShell(
                orange: orange,
                body: _buildGuestSignInBody(context, orange),
              );
            }
            return BlocListener<AddressCubit, AddressState>(
              bloc: _addressCubit,
              listener: (context, state) {
                if (state is AddressLoaded) _onAddressesLoaded(state);
              },
              child: Scaffold(
                backgroundColor: Colors.grey.shade100,
                body: SafeArea(
                  child: Column(
                    children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppStrings.cart,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          AppStrings.doneUpper,
                          style: TextStyle(
                            color: orange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: BlocBuilder<CartCubit, CartState>(
                    bloc: _cartCubit,
                    builder: (context, state) {
                      if (state is CartLoading || state is CartInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is CartError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(state.message),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () => _cartCubit.load(),
                                child: Text(AppStrings.retry),
                              ),
                            ],
                          ),
                        );
                      }
                      final items =
                          state is CartLoaded ? state.items : <CartItem>[];
                      if (items.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppStrings.cartEmpty,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final c = items[index];
                          final it = c.item;
                          final lineItemId = c.lineItemId ?? c.item.id;
                          final unitPrice = double.tryParse(
                                it.price.replaceAll(RegExp(r'[^0-9\.]'), ''),
                              ) ??
                              0.0;
                          final lineTotal = unitPrice * c.quantity;
                          final canEditQty =
                              lineItemId.isNotEmpty;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    it.imageUrl,
                                    width: 76,
                                    height: 76,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => Container(
                                          width: 76,
                                          height: 76,
                                          color: Colors.grey.shade200,
                                          child: Icon(
                                            Icons.inventory_2_outlined,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        it.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        it.subtitle,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            it.price.isNotEmpty
                                                ? '${l10n.currencySymbol}${lineTotal.toStringAsFixed(0)}'
                                                : '—',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                            ),
                                          ),
                                          if (c.quantity > 1 &&
                                              it.price.isNotEmpty)
                                            Text(
                                              '@ ${l10n.currencySymbol}${unitPrice.toStringAsFixed(0)} × ${c.quantity}',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => _confirmRemoveLineItem(
                                        context,
                                        lineItemId,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red.shade400,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (canEditQty)
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (c.quantity <= 1) {
                                                  _confirmRemoveLineItem(
                                                    context,
                                                    lineItemId,
                                                  );
                                                } else {
                                                  _cartCubit.updateQuantity(
                                                    lineItemId,
                                                    c.quantity - 1,
                                                  );
                                                }
                                              },
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(9),
                                                bottomLeft:
                                                    Radius.circular(9),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 20,
                                                  color: orange,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Text(
                                                '${c.quantity}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _cartCubit.updateQuantity(
                                                  lineItemId,
                                                  c.quantity + 1,
                                                );
                                              },
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(9),
                                                bottomRight:
                                                    Radius.circular(9),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: orange,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Text(
                                        AppStrings.qtyLabel(c.quantity),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                BlocBuilder<AddressCubit, AddressState>(
                  bloc: _addressCubit,
                  builder: (context, addrState) {
                    return BlocBuilder<CartCubit, CartState>(
                      bloc: _cartCubit,
                      builder: (context, state) {
                        final items =
                            state is CartLoaded ? state.items : <CartItem>[];
                        final total = _total(items);
                        final addresses =
                            addrState is AddressLoaded
                                ? addrState.addresses
                                : <Address>[];
                        final addrLoading =
                            addrState is AddressLoading ||
                            addrState is AddressInitial;
                        final addrErr =
                            addrState is AddressError
                                ? addrState.message
                                : null;
                        final selected =
                            _selectedAddress ??
                            (addresses.isNotEmpty ? addresses.first : null);

                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 12,
                                offset: const Offset(0, -4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.deliverTo,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppStrings.deliverSubtitle,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (addrLoading)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: orange,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        AppStrings.loadingAddresses,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (addrErr != null)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.red.shade100,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.wifi_off_rounded,
                                        color: Colors.red.shade400,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppStrings.couldNotLoadAddresses,
                                              style: TextStyle(
                                                color: Colors.grey.shade900,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              addrErr,
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 13,
                                                height: 1.35,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () =>
                                                      _addressCubit
                                                          .loadAddresses(),
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                foregroundColor: orange,
                                              ),
                                              child: Text(
                                                AppStrings.tryAgain,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (addresses.isEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: orange.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: orange.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.add_location_alt_outlined,
                                            color: orange,
                                            size: 26,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              AppStrings.addDeliveryAddress,
                                              style: TextStyle(
                                                color: Colors.grey.shade900,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        AppStrings.tellUsWhereDelivery,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: FilledButton.tonal(
                                          onPressed:
                                              () => Navigator.of(context)
                                                  .push(
                                                    MaterialPageRoute<void>(
                                                      builder:
                                                          (_) =>
                                                              const AddressPage(),
                                                    ),
                                                  )
                                                  .then(
                                                    (_) =>
                                                        _addressCubit
                                                            .loadAddresses(),
                                                  ),
                                          style: FilledButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: orange,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              side: BorderSide(
                                                color: orange.withValues(
                                                  alpha: 0.35,
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            AppStrings.addAddress,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Material(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(14),
                                  child: InkWell(
                                    onTap: () => _showAddressPicker(addresses),
                                    borderRadius: BorderRadius.circular(14),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 44,
                                            height: 44,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: orange.withValues(
                                                alpha: 0.12,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              color: orange,
                                              size: 22,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (selected != null)
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          _addressHeading(
                                                            selected,
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700,
                                                            color: orange,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      if (selected.isDefault)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8,
                                                                ),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 6,
                                                              vertical: 2,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey
                                                                  .shade200,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                6,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              AppStrings
                                                                  .defaultBadge,
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                Text(
                                                  _oneLineAddress(
                                                    selected?.fullAddress ??
                                                        '',
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color:
                                                        Colors.grey.shade900,
                                                    fontSize: 13,
                                                    height: 1.25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: Colors.grey.shade500,
                                            size: 22,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.totalColon,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    '${l10n.currencySymbol}${total.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
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
                                      items.isEmpty || selected == null
                                          ? null
                                          : () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (_) => PaymentPage(
                                                      total: total,
                                                    ),
                                              ),
                                            );
                                          },
                                  child: Text(
                                    AppStrings.placeOrder,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
            );
          },
        ),
      ),
    );
  }
}
