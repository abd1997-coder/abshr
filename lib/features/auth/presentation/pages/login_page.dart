import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:marketplace/core/utils/toast_service.dart';
import 'package:marketplace/core/widgets/widgets.dart';
import 'package:marketplace/features/home/presentation/pages/home_page.dart';
import '../cubit/auth_cubit.dart';
import 'register_page.dart';
import 'verification_page.dart';

class LoginPage extends StatefulWidget {
  final bool navigateToHomeOnSuccess;

  const LoginPage({super.key, this.navigateToHomeOnSuccess = true});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  CountryCode _selectedCountry = CountryCode.fromCountryCode('SY');
  AuthCubit authCubit =  getIt<AuthCubit>();
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _getFullPhoneNumber() {
    String countryCode = _selectedCountry.dialCode ?? '+963';
    String phone = _phoneController.text.trim();
    phone = phone.replaceAll(RegExp(r'^0+'), '');
    return '$countryCode$phone';
  }

  void _handleLogin(AuthCubit authCubit) {
    if (_formKey.currentState!.validate()) {
      authCubit.loginWithPhone(_getFullPhoneNumber());
    }
  }

  void _navigateToHome() {
    if (widget.navigateToHomeOnSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = (screenHeight * 0.30).clamp(120.0, double.infinity);
    final orangeColor = AppConstants.primaryColor;
    const darkBlueColor = Color(0xFF1A237E);

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        bloc: authCubit,
        listener: (context, state) {
          if (state is AuthError) {
            showErrorToast(context, state.message);
          }
          if (state is AuthOtpSent) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder:
                    (innerContext) => VerificationPage(
                      phoneNumber: state.phoneNumber,
                      isLogin: state.isLogin,
                      firstName: state.firstName,
                      lastName: state.lastName,
                    ),
              ),
            );
          }
          if (state is AuthAuthenticated) {
            showSuccessToast(context, AppStrings.loginSuccessful);
            _navigateToHome();
          }
          if (state is AuthAuthenticatedFromLogin) {
            showSuccessToast(context, AppStrings.loginSuccessful);
            _navigateToHome();
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
                      decoration: const BoxDecoration(color: darkBlueColor),
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
                                color: Colors.white.withValues(alpha: 0.9),
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
                            Text(
                              AppStrings.phoneUpper,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: CountryCodePicker(
                                    onChanged: (country) {
                                      setState(() {
                                        _selectedCountry = country;
                                      });
                                    },
                                    initialSelection: _selectedCountry.code,
                                    favorite: const [
                                      '+963',
                                      '+966',
                                      '+971',
                                      '+20',
                                      '+1',
                                    ],
                                    showCountryOnly: false,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _phoneController,
                                    hintText: '912345678',
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Phone number is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            PrimaryButton(
                              label: AppStrings.logInButton,
                              onPressed: () => _handleLogin(authCubit),
                              isLoading: state is AuthLoading,
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
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
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(text: AppStrings.dontHaveAccount),
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
