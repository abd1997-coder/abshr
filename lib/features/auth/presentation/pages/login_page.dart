import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/utils/toast_service.dart';
import 'package:marketplace/core/widgets/widgets.dart';
import 'package:marketplace/features/home/presentation/pages/home_page.dart';
import '../cubit/auth_cubit.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  /// When false (e.g. opened from cart), only pops after success instead of pushing [HomePage].
  final bool navigateToHomeOnSuccess;

  const LoginPage({super.key, this.navigateToHomeOnSuccess = true});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(AuthCubit authCubit) {
    if (_formKey.currentState!.validate()) {
      authCubit.login(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = (screenHeight * 0.30).clamp(120.0, double.infinity);
    final orangeColor = AppConstants.primaryColor;
    final darkBlueColor = const Color(0xFF1A237E); // Dark indigo/blue

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        bloc: authCubit,
        listener: (context, state) {
          if (state is AuthError) {
            showErrorToast(context, state.message);
          }
          if (state is AuthAuthenticated) {
            if (widget.navigateToHomeOnSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              showSuccessToast(context, AppStrings.loginSuccessful);
            } else {
              Navigator.of(context).pop();
            }
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: headerHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(color: darkBlueColor),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.loginTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.loginSubtitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 30),
                            // EMAIL field
                            Text(
                              AppStrings.emailUpper,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppTextFormField(
                              controller: _emailController,
                              hintText: AppStrings.hintEmailExample,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.validationEmailRequired;
                                }
                                if (!value.contains('@')) {
                                  return AppStrings.validationEmailInvalid;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // PASSWORD field
                            Text(
                              AppStrings.passwordUpper,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppTextFormField(
                              controller: _passwordController,
                              hintText: AppStrings.hintPasswordEnter,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.validationPasswordRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            PrimaryButton(
                              label: AppStrings.logInButton,
                              onPressed: () => _handleLogin(authCubit),
                              isLoading: state is AuthLoading,
                            ),
                            const SizedBox(height: 16),
                            // CONTINUE AS GUEST button
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: orangeColor, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                AppStrings.continueAsGuest,
                                style: TextStyle(
                                  color: orangeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Footer link
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: AppStrings.dontHaveAccount,
                                    ),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => RegisterPage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          AppStrings.signUpUpper,
                                          style: TextStyle(
                                            color: orangeColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
