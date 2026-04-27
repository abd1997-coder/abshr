import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import '../cubit/address_cubit.dart';
import '../../domain/entities/address.dart';
import '../widgets/address_card.dart';
import 'add_edit_address_page.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late final AddressCubit _addressCubit = getIt.get<AddressCubit>();

  @override
  void initState() {
    super.initState();
    _addressCubit.loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppStrings.myAddress,
          style: const TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        bloc: _addressCubit,
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AddressLoaded) {
            if (state.addresses.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    AppStrings.noSavedAddressesYet,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              children: [
                ...state.addresses.map((address) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: AddressCard(
                      address: address,
                      onEdit: () => _showAddEditDialog(context, address),
                      onDelete: () => _confirmDelete(context, address.id),
                      onSetDefault:
                          () => _addressCubit.setDefaultAddress(address.id),
                    ),
                  );
                }),
              ],
            );
          } else if (state is AddressError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _showAddEditDialog(context, null),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              AppStrings.addNewAddressUpper,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reuses the default saved address, or the first in the list, to pre-fill a new address.
  Address? _prefillTemplateForNewAddress() {
    final state = _addressCubit.state;
    if (state is! AddressLoaded || state.addresses.isEmpty) return null;
    final list = state.addresses;
    for (final a in list) {
      if (a.isDefault) return a;
    }
    return list.first;
  }

  void _showAddEditDialog(BuildContext context, Address? address) async {
    final prefill =
        address == null ? _prefillTemplateForNewAddress() : null;
    final result = await Navigator.push<Address>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressPage(
          address: address,
          prefillTemplate: prefill,
        ),
      ),
    );

    if (result != null) {
      if (address == null) {
        _addressCubit.addAddress(result);
      } else {
        _addressCubit.updateAddress(result);
      }
    }
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppStrings.deleteAddress),
          content: Text(AppStrings.areYouSure),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                _addressCubit.deleteAddress(id);
                Navigator.pop(dialogContext);
              },
              child: Text(
                AppStrings.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
