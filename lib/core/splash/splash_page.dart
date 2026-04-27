import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_assets.dart';
import 'package:marketplace/core/navigation/app_navigator.dart';
import 'package:marketplace/features/auth/presentation/cubit/auth_cubit.dart';

const _kMinSplashDuration = Duration(milliseconds: 2000);

/// Branded splash with logo; then shows [AppNavigator] after a minimum delay
/// and once auth status is no longer loading.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _goToApp());
  }

  Future<void> _goToApp() async {
    if (!mounted) return;
    final cubit = context.read<AuthCubit>();
    await Future.wait<void>([
      Future<void>.delayed(_kMinSplashDuration),
      _waitUntilAuthResolved(cubit),
    ]);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder:
            (_) =>
                const SafeArea(top: false, bottom: true, child: AppNavigator()),
      ),
    );
  }

  Future<void> _waitUntilAuthResolved(AuthCubit cubit) async {
    if (!_isAuthPending(cubit.state)) return;
    await cubit.stream.firstWhere((s) => !_isAuthPending(s));
  }

  bool _isAuthPending(AuthState state) =>
      state is AuthInitial || state is AuthLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: Image.asset(
            AppAssets.logo,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) {
              return Icon(Icons.storefront_rounded, size: 96);
            },
          ),
        ),
      ),
    );
  }
}
