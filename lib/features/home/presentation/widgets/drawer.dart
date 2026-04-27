import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:marketplace/core/navigation/app_navigator.dart';
import 'package:marketplace/core/utils/storage_service.dart';
import 'package:marketplace/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:marketplace/features/auth/presentation/pages/guest_mode_required_page.dart';
import 'package:marketplace/features/auth/presentation/pages/login_page.dart';
import 'package:marketplace/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:marketplace/features/orders/presentation/pages/orders_page.dart';
import 'package:marketplace/features/profile/presentation/pages/profile_page.dart';
import 'package:marketplace/features/settings/settings_page.dart';
import 'package:marketplace/features/address/presentation/pages/address_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final storedName = getIt.get<StorageService>().getString(
      AppConstants.userNameKey,
    );
    final displayName =
        (storedName != null && storedName.trim().isNotEmpty)
            ? storedName.trim()
            : AppStrings.guest;

    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      child: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: AppConstants.primaryColor),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 32,
                            color: AppConstants.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(AppStrings.profile),
                    onTap: () {
                      _openDrawerDestination(
                        context,
                        () => const ProfilePage(),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: Text(AppStrings.orders),
                    onTap: () {
                      _openDrawerDestination(
                        context,
                        () => const OrdersPage(),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(AppStrings.addresses),
                    onTap: () {
                      _openDrawerDestination(
                        context,
                        () => const AddressPage(),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(AppStrings.settings),
                    onTap: () {
                      _openDrawerDestination(
                        context,
                        () => const SettingsPage(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            SafeArea(
              top: false,
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoggedIn = state is AuthAuthenticated;
                  if (!isLoggedIn) {
                    return ListTile(
                      leading: Icon(
                        Icons.login_rounded,
                        color: AppConstants.primaryColor,
                      ),
                      title: Text(
                        AppStrings.login,
                        style: TextStyle(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                    );
                  }
                  return ListTile(
                    leading: Icon(Icons.logout_rounded, color: Colors.red.shade700),
                    title: Text(
                      AppStrings.logout,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () => _showLogoutConfirmDialog(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Opens [page] after closing the drawer, or a full-screen guest prompt (localized).
  void _openDrawerDestination(
    BuildContext context,
    Widget Function() page,
  ) {
    final loggedIn = context.read<AuthCubit>().state is AuthAuthenticated;
    final nav = Navigator.of(context);
    nav.pop();
    if (!loggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!nav.context.mounted) return;
        nav.push<void>(
          MaterialPageRoute<void>(
            builder: (_) => const GuestModeRequiredPage(),
          ),
        );
      });
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!nav.context.mounted) return;
      nav.push<void>(MaterialPageRoute<void>(builder: (_) => page()));
    });
  }

  void _showLogoutConfirmDialog(BuildContext drawerContext) {
    showDialog<void>(
      context: drawerContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppStrings.confirmLogoutTitle),
          content: Text(AppStrings.confirmLogoutMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                final auth = drawerContext.read<AuthCubit>();
                final nav = Navigator.of(drawerContext);
                Navigator.pop(dialogContext);
                nav.pop();
                await auth.logout();
                await getIt<CartCubit>().load();
                if (!nav.mounted) return;
                nav.pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) => const SafeArea(
                      top: false,
                      bottom: true,
                      child: AppNavigator(),
                    ),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                AppStrings.logout,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        );
      },
    );
  }
}
