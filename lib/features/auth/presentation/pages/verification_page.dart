import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/utils/toast_service.dart';
import 'package:marketplace/core/widgets/widgets.dart';
import 'package:marketplace/features/home/presentation/pages/home_page.dart';
import 'package:pinput/pinput.dart';
import '../cubit/auth_cubit.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;
  final bool isLogin;
  final String? firstName;
  final String? lastName;

  const VerificationPage({
    super.key,
    required this.phoneNumber,
    required this.isLogin,
    this.firstName,
    this.lastName,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  static const int _otpLength = 4; // Changed to 4 digits based on API example
  late TextEditingController _pinController;
  int _resendCountdown = 60;
  bool _canResend = false;
  late AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    _startCountdown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authCubit = context.read<AuthCubit>();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
            _canResend = false;
            _startCountdown();
          } else {
            _canResend = true;
          }
        });
      }
    });
  }

  void _handleVerify() {
    final code = _pinController.text;
    if (code.length == _otpLength) {
      _authCubit.verifyOtp(
        phone: widget.phoneNumber,
        otp: code,
        isLogin: widget.isLogin,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.completeSixDigitCode),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleResend() {
    if (_canResend) {
      setState(() {
        _resendCountdown = 60;
        _canResend = false;
      });
      _startCountdown();
      if (widget.isLogin) {
        _authCubit.loginWithPhone(widget.phoneNumber);
      } else if (widget.firstName != null && widget.lastName != null) {
        _authCubit.registerWithPhone(
          firstName: widget.firstName!,
          lastName: widget.lastName!,
          phone: widget.phoneNumber,
        );
      } else {
        _authCubit.loginWithPhone(widget.phoneNumber);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.35;
    final orangeColor = AppConstants.primaryColor;
    const darkBlueColor = Color(0xFF1A237E);

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
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
            showSuccessToast(context, AppStrings.loginSuccessful);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          }
          if (state is AuthOtpSent && state.phoneNumber == widget.phoneNumber) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.verificationCodeResent),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section – same style as login
                    Container(
                      height: headerHeight,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: darkBlueColor),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            left: 20,
                            child: CustomPaint(
                              size: const Size(100, 100),
                              painter: _RadiatingLinesPainter(),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            right: 20,
                            child: CustomPaint(
                              size: const Size(80, 80),
                              painter: _DashedShapePainter(),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 8,
                            left: 16,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 18,
                                ),
                                onPressed: () => Navigator.pop(context),
                                padding: EdgeInsets.zero,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 100,
                            bottom: 0,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppStrings.verificationTitle,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppStrings.verificationSentSubtitle,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.phoneNumber,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // White content section – rounded top like login
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            // CODE label and Resend
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.codeUpper,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _canResend ? _handleResend : null,
                                    child: Text(
                                      _canResend
                                          ? AppStrings.resend
                                          : AppStrings.resendInSeconds(
                                            _resendCountdown,
                                          ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            _canResend
                                                ? orangeColor
                                                : Colors.grey.shade600,
                                        decoration:
                                            _canResend
                                                ? TextDecoration.underline
                                                : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Code input fields
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: Pinput(
                                controller: _pinController,
                                length: _otpLength,
                                defaultPinTheme: PinTheme(
                                  width: 48,
                                  height: 56,
                                  textStyle: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                focusedPinTheme: PinTheme(
                                  width: 48,
                                  height: 56,
                                  textStyle: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppConstants.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                submittedPinTheme: PinTheme(
                                  width: 48,
                                  height: 56,
                                  textStyle: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppConstants.primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            // VERIFY button
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: PrimaryButton(
                                  label: AppStrings.verifyButton,
                                  onPressed: _handleVerify,
                                  isLoading: state is AuthLoading,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
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

// Custom painter for radiating lines pattern
class _RadiatingLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * math.pi / 180;
      final endX = center.dx + radius * 0.7 * math.cos(angle);
      final endY = center.dy + radius * 0.7 * math.sin(angle);
      canvas.drawLine(center, Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for dashed shape pattern
class _DashedShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final path = Path();
    final dashWidth = 8.0;
    final dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      path.moveTo(startX, size.height / 2);
      path.lineTo(startX + dashWidth, size.height / 2);
      startX += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
