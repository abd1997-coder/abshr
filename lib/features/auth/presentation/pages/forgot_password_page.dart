import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/widgets/widgets.dart';
import '../cubit/auth_cubit.dart';
import 'verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendCode() {
    if (_formKey.currentState!.validate()) {
      // Navigate to verification page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationPage(
            phoneNumber: _emailController.text.trim(),
            verificationId: '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.35;
    final darkBlueColor = const Color(0xFF1A237E); // Dark indigo/blue

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
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Header Section with dark blue background
                  Container(
                    height: headerHeight,
                    decoration: BoxDecoration(color: darkBlueColor),
                    child: Stack(
                      children: [
                        // Decorative pattern top-left
                        Positioned(
                          top: 20,
                          left: 20,
                          child: CustomPaint(
                            size: const Size(100, 100),
                            painter: _RadiatingLinesPainter(),
                          ),
                        ),
                        // Decorative pattern top-right
                        Positioned(
                          top: 30,
                          right: 20,
                          child: CustomPaint(
                            size: const Size(80, 80),
                            painter: _DashedShapePainter(),
                          ),
                        ),
                        // Back button
                        Positioned(
                          top: 50,
                          left: 20,
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
                        // Title and subtitle
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
                                  AppStrings.forgotPasswordTitle,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppStrings.forgotPasswordSubtitle,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // White content section with rounded top corners
                  Positioned(
                    top: headerHeight - 30,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(24.0),
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
                              const SizedBox(height: 40),
                              // SEND CODE button
                              PrimaryButton(
                                label: AppStrings.sendCode,
                                onPressed: _handleSendCode,
                                isLoading: state is AuthLoading,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
    final paint = Paint()
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
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final dashWidth = 8.0;
    final dashSpace = 4.0;
    double startX = 0;

    // Draw dashed lines forming a shape
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
