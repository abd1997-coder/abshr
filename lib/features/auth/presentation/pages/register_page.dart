import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/utils/toast_service.dart';
import 'package:marketplace/core/widgets/widgets.dart';
import 'package:marketplace/features/home/presentation/pages/home_page.dart';
import '../cubit/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  /// When false (e.g. opened from cart), pops back on success instead of replacing the stack with home.
  final bool replaceStackOnSuccess;

  const RegisterPage({super.key, this.replaceStackOnSuccess = true});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister(AuthCubit authCubit) {
    if (_formKey.currentState!.validate()) {
      authCubit.register(
        _emailController.text.trim(),
        _passwordController.text,
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.35;
    final darkBlueColor = const Color(0xFF1A237E); // Dark indigo/blue

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        bloc: authCubit,
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is AuthAuthenticated) {
            if (widget.replaceStackOnSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (innerContext) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (innerContext.mounted) {
                        showSuccessToast(
                          innerContext,
                          AppStrings.accountCreatedSuccess,
                        );
                      }
                    });
                    return const HomePage();
                  },
                ),
                (route) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Section with dark blue background
                Container(
                  height: headerHeight - 50,
                  width: double.infinity,
                  decoration: BoxDecoration(color: darkBlueColor),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              customBorder: const CircleBorder(),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Title and subtitle
                      Text(
                        AppStrings.signUpTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.signUpSubtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                // White content section with rounded top corners
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        // FIRST NAME field
                        Text(
                          AppStrings.firstNameUpper,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextFormField(
                          controller: _firstNameController,
                          hintText: AppStrings.hintNameExample,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.validationFirstNameRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        // LAST NAME field
                        Text(
                          AppStrings.lastNameUpper,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextFormField(
                          controller: _lastNameController,
                          hintText: '',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.validationLastNameRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
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
                        const SizedBox(height: 12),
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
                            if (value.length < 6) {
                              return AppStrings.validationPasswordMin6;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        // RE-TYPE PASSWORD field
                        Text(
                          AppStrings.retypePasswordUpper,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextFormField(
                          controller: _confirmPasswordController,
                          hintText: AppStrings.hintReenterPassword,
                          obscureText: _obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.validationConfirmPassword;
                            }
                            if (value != _passwordController.text) {
                              return AppStrings.validationPasswordsMismatch;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        // SIGN UP button
                        PrimaryButton(
                          label: AppStrings.signUpButton,
                          onPressed: () => _handleRegister(authCubit),
                          isLoading: state is AuthLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
