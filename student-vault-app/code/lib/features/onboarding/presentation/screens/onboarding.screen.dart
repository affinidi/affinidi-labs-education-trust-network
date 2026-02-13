import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../authentication/presentation/widgets/login_hero.dart';
import '../widgets/onboarding_profile_card.dart';

const _logKey = 'Onboarding';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Read state from providers

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: const Row(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Text('Welcome', style: TextStyle(fontWeight: FontWeight.bold)),
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
          Expanded(child: const OnboardingProfileCard(key: ValueKey('setup'))),
        ],
      ),
    );
  }
}
