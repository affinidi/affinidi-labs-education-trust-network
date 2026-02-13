import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/navigation/routes/route_paths.dart';
import '../../../domain/login_service/login_service.dart';
import '../../../domain/login_service/login_service_state.dart';
import '../../../../settings/data/settings_service/settings_service.dart';

import '../../widgets/login_card.dart';
import '../../widgets/login_hero.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Initialize pulse animation for logo using useAnimationController
    // final pulseController = useAnimationController(
    //   duration: const Duration(milliseconds: 2000),
    // )..repeat(reverse: true);

    // final pulseAnimation = useMemoized(
    //   () => Tween<double>(begin: 0.6, end: 1.0).animate(
    //     CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    //   ),
    //   [pulseController],
    // );

    final loginState = ref.watch(loginServiceProvider);

    // Listen for login completion and navigate
    useEffect(() {
      debugPrint('Login step changed: ${loginState.step}');
      if (loginState.step == LoginFlowStep.completed) {
        // Check if user has profile and onboarding status
        Future.microtask(() async {
          try {
            debugPrint('Checking profile and onboarding status...');

            // Check settings first (simpler check)
            final settingsState = ref.read(settingsServiceProvider);
            final hasOnboarded = settingsState.alreadyOnboarded ?? false;
            debugPrint('Has onboarded from settings: $hasOnboarded');

            if (context.mounted) {
              if (!hasOnboarded) {
                // First time user - go to onboarding
                debugPrint('Navigating to onboarding (first time user)...');
                context.replace(RoutePaths.onboarding);
              } else {
                // Returning user - go to dashboard
                debugPrint('Navigating to dashboard (returning user)...');
                context.replace('/dashboard/credentials');
              }
            }
          } catch (e, stack) {
            debugPrint('Error checking profile/onboarding: $e');
            debugPrint('Stack trace: $stack');
          }
        });
      }
      return null;
    }, [loginState.step]);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: const Row(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Text(
      //         'Universal Student App',
      //         style: TextStyle(fontWeight: FontWeight.bold),
      //       ),
      //     ],
      //   ),
      // ),
      body: Column(
        children: [
          // login hero banner
          FloatingEmojiBanner(
            height: 200,
            emojis: const ['🎓', '💼', '📁'], // Any 3 emojis
            amplitude: 10,
            period: const Duration(seconds: 7),
            gradientBoost: 0.22, // keep as-is; exposed for future tuning
            semanticLabel: 'Playful banner with floating emojis',
          ),
          // login form
          Expanded(
            child: LoginCard(
              key: const ValueKey('login'),
              onLogin: (String email) async {
                await ref
                    .read(loginServiceProvider.notifier)
                    .login(email: email);
              },
              isLoading: loginState.isLoading,
              errorMessage: loginState.errorMessage,
              statusMessage: loginState.statusMessage,
              step: loginState.step,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildAnimatedLogo(Animation<double> pulseAnimation) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 20),
  //     child: Center(
  //       child: AnimatedBuilder(
  //         animation: pulseAnimation,
  //         builder: (context, child) {
  //           return Container(
  //             width: 120,
  //             height: 120,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               border: Border.all(
  //                 color: Colors.white.withValues(alpha: 0.2),
  //                 width: 3,
  //               ),
  //               boxShadow: [
  //                 // Purple glow
  //                 BoxShadow(
  //                   color: const Color(
  //                     0xFF4F39F6,
  //                   ).withValues(alpha: 0.6 * pulseAnimation.value),
  //                   blurRadius: 30 * pulseAnimation.value,
  //                   spreadRadius: 5 * pulseAnimation.value,
  //                 ),
  //                 // Magenta glow
  //                 BoxShadow(
  //                   color: const Color(
  //                     0xFF9810FA,
  //                   ).withValues(alpha: 0.5 * pulseAnimation.value),
  //                   blurRadius: 40 * pulseAnimation.value,
  //                   spreadRadius: 3 * pulseAnimation.value,
  //                 ),
  //                 // Pink glow
  //                 BoxShadow(
  //                   color: const Color(
  //                     0xFFE60076,
  //                   ).withValues(alpha: 0.4 * pulseAnimation.value),
  //                   blurRadius: 50 * pulseAnimation.value,
  //                   spreadRadius: 2 * pulseAnimation.value,
  //                 ),
  //               ],
  //             ),
  //             child: ClipOval(child: _buildLogo()),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildLogo() {
  //   return Container(
  //     width: 120,
  //     height: 120,
  //     decoration: const BoxDecoration(
  //       shape: BoxShape.circle,
  //       gradient: LinearGradient(
  //         colors: [Color(0xFF4F39F6), Color(0xFF9810FA)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //     ),
  //     child: const Icon(Icons.business_rounded, size: 60, color: Colors.white),
  //   );
  // }
}
