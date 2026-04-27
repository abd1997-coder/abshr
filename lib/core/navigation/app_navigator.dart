import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/di/injection_container.dart' as di;
import 'package:marketplace/core/utils/storage_service.dart';
import 'package:marketplace/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:marketplace/features/auth/presentation/pages/login_page.dart';
import 'package:marketplace/features/home/presentation/cubit/home_cubit.dart';
import 'package:marketplace/features/home/presentation/pages/home_page.dart';
import 'package:marketplace/features/onboarding/presentation/pages/onboarding_page.dart';

/// Routes users to onboarding, login, or home based on auth and onboarding state.
class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  /// `null` until SharedPreferences is read.
  bool? _onboardingComplete;

  @override
  void initState() {
    super.initState();
    _loadOnboardingFlag();
  }

  Future<void> _loadOnboardingFlag() async {
    final storage = di.getIt<StorageService>();
    final done = storage.getBool(AppConstants.onboardingCompletedKey) ?? false;
    if (mounted) {
      setState(() => _onboardingComplete = done);
    }
  }

  void _onOnboardingFinished() {
    setState(() => _onboardingComplete = true);
    di.getIt<StorageService>().setBool(
      AppConstants.onboardingCompletedKey,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          return BlocProvider(
            create: (_) => di.getIt<HomeCubit>()..loadHome(),
            child: const HomePage(),
          );
        }

        if (_onboardingComplete == null ||
            authState is AuthInitial ||
            authState is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!_onboardingComplete!) {
          return OnboardingPage(onComplete: _onOnboardingFinished);
        }

        return const LoginPage();
      },
    );
  }
}
