import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:student_vault_app/core/hooks/ct_notifier.dart';
import 'package:student_vault_app/core/design_system/convex_container.dart';
import 'package:student_vault_app/features/authentication/domain/login_service/login_service_state.dart';

class LoginCard extends HookWidget {
  const LoginCard({
    super.key,
    required this.onLogin,
    required this.isLoading,
    required this.step,
    this.errorMessage,
    this.statusMessage,
  });

  final Future<void> Function(String) onLogin;
  final bool isLoading;
  final LoginFlowStep step;
  final String? errorMessage;
  final String? statusMessage;

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: '@certizen.com');
    final otpController = useTextEditingController(text: '123456');
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final otpSentNotifier = useCTNotifier(false);
    final isSendingOtpNotifier = useCTNotifier(false);

    final otpSent = useValueListenable(otpSentNotifier);
    final isSendingOtp = useValueListenable(isSendingOtpNotifier);

    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final secondaryColor = colorScheme.secondary;

    Future<void> sendOtp() async {
      if (!formKey.currentState!.validate()) return;

      isSendingOtpNotifier.value = true;

      try {
        // Call the onLogin with a special flag or modify to handle OTP request
        // For now, we'll just simulate sending OTP
        await Future<void>.delayed(const Duration(seconds: 1));

        otpSentNotifier.value = true;
        isSendingOtpNotifier.value = false;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent to your email'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      } catch (e) {
        isSendingOtpNotifier.value = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    Widget buildSignInButton() {
      final isDisabled = isLoading || isSendingOtp;
      final buttonText = otpSent ? 'Verify OTP' : 'Send OTP';

      return Container(
        // Asking for a friend:
        // Why doesn't use a button?
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          // gradient: isDisabled
          //     ? null
          //     : LinearGradient(
          //         colors: [primaryColor, secondaryColor],
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //       ),
          color: isDisabled
              ? Colors.grey.shade700
              : const Color.fromARGB(255, 255, 142, 5),
        ),
        child: Material(
          color: primaryColor,
          surfaceTintColor: secondaryColor,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: isDisabled
                ? null
                : () async {
                    if (!otpSent) {
                      // Send OTP
                      await sendOtp();
                    } else {
                      // Verify OTP
                      if (formKey.currentState!.validate()) {
                        await onLogin(emailController.text.trim());
                      }
                    }
                  },
            borderRadius: BorderRadius.circular(30),
            child: Center(
              child: (isLoading || isSendingOtp)
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        // color: Colors.white,
                      ),
                    )
                  : Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        // color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      );
    }

    final theme = Theme.of(context);

    return ConvexContainer(
      color: const Color.fromARGB(255, 255, 246, 225),
      curveHeight: 20,
      edgeHeight: 40,
      overlapOffset: -40,
      child: SizedBox.expand(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Log in',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        // 'Don\'t have an account? Sign up.',
                        'Enter your email address to continue',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 64),

                  // Email Field
                  Text(
                    'Email',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'your.email@company.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade700.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF4F39F6),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    // style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 64),

                  // OTP Field (shown after OTP is sent)
                  if (otpSent) ...[
                    Text(
                      'Enter OTP',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        // color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: otpController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter 6-digit OTP',
                        prefixIcon: const Icon(Icons.pin_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade700.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF4F39F6),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        // fillColor: Colors.grey.shade900,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      // style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      // maxLength: 6,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter OTP';
                        }
                        if (value.length != 6) {
                          return 'OTP must be 6 digits';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: isSendingOtp ? null : sendOtp,
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: isSendingOtp
                                  ? Colors.grey.shade600
                                  : const Color(0xFF4F39F6),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            otpSentNotifier.value = false;
                            otpController.clear();
                          },
                          child: const Text(
                            'Change Email',
                            // style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Error Message
                  if (errorMessage != null && errorMessage!.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.red.shade100,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Status Message
                  if (statusMessage != null &&
                      statusMessage!.isNotEmpty &&
                      errorMessage == null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: step == LoginFlowStep.completed
                              ? Colors.green.shade300
                              : Colors.grey.shade300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Sign In Button
                  SizedBox(width: double.infinity, child: buildSignInButton()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
