import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/storage/settings_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appName = ref.watch(appNameProvider);
    final registryName = ref.watch(registryNameProvider);
    final storage = ref.watch(settingsStorageProvider).valueOrNull;

    // Check if registry is already created
    final hasRegistry = registryName != null && registryName.isNotEmpty;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/start-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient blob - Top left corner (purple for existing users, teal for new users)
            Positioned(
              top: -200,
              left: -200,
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (hasRegistry
                              ? AppColors.accentPurple
                              : AppColors.semanticSuccess)
                          .withOpacity(0.4),
                      (hasRegistry
                              ? AppColors.accentPurple
                              : AppColors.semanticSuccess)
                          .withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Gradient blob - Middle (purple for existing users, teal for new users)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: MediaQuery.of(context).size.width * 0.3,
              child: Container(
                width: 650,
                height: 650,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (hasRegistry
                              ? AppColors.accentPurple
                              : AppColors.semanticSuccess)
                          .withOpacity(0.4),
                      (hasRegistry
                              ? AppColors.accentPurple
                              : AppColors.semanticSuccess)
                          .withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // White container with rounded top corners and drop shadow
            Positioned(
              top: 120, // Adjust to show gradient background above
              left: MediaQuery.of(context).size.width * 0.5,
              right: MediaQuery.of(context).size.width * 0.1,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        AppColors.accentBlue.withOpacity(0.4),
                        AppColors.accentPurple.withOpacity(0.4),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(29),
                          topRight: Radius.circular(29),
                        ),
                      ),
                      child: hasRegistry
                          ? _buildExistingRegistryView(
                              context, ref, appName, registryName)
                          : _buildCreateRegistryView(
                              context, ref, appName, storage),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // View when registry already exists
  Widget _buildExistingRegistryView(
    BuildContext context,
    WidgetRef ref,
    String appName,
    String registryName,
  ) {
    return Column(
      children: [
        // Scrollable content area
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacing8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.spacing3),
                // Welcome back message
                Text(
                  'Welcome back to',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.neutral400,
                        fontWeight: FontWeight.w400,
                      ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  registryName,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.left,
                ),

                // Subtitle
                Text(
                  'Trust Registry Governance Portal',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.neutral400,
                        fontWeight: FontWeight.w300,
                      ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: AppSpacing.spacing6),

                // Description text
                Text(
                  'Create and manage your existing records, oversee, track and verify your entities, and manage issuing and verifying authorities.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.neutral500,
                        height: 1.6,
                      ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),

        // CTA Button - Sticky at bottom
        Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing6),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accentBlue,
                    AppColors.accentPurple,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.go('/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacing4,
                    vertical: AppSpacing.spacing3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Open Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spacing2),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // View when creating a new registry
  Widget _buildCreateRegistryView(
    BuildContext context,
    WidgetRef ref,
    String appName,
    dynamic storage,
  ) {
    final controller = TextEditingController();

    return Column(
      children: [
        // Scrollable content area
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacing8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.spacing3),
                Text(
                  "Build Trust at Ecosystem Scale",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: AppSpacing.spacing3),
                // Subtitle
                Text(
                  'Create a Trust Registry to set the rules of trust for who\'s in the ecosystem, how they are governed, and how trust is verified.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.neutral400,
                        fontWeight: FontWeight.w300,
                      ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: AppSpacing.spacing8),
                Text(
                  'Enter a name for your trust registry to get started. You can rename it anytime.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.spacing5),
                // TextField with drop shadow
                SizedBox(
                  height: 88,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 24,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Registry Name',
                        hintText: 'e.g., Hong Kong Education Registry',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacing2,
                          vertical: 22,
                        ),
                        labelStyle: TextStyle(
                          color: AppColors.neutral300,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: TextStyle(
                          color: AppColors.neutral300,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        color: AppColors.neutral500,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      onSubmitted: (value) async {
                        if (value.isNotEmpty && storage != null) {
                          await storage.setRegistryName(value);
                          ref.read(registryNameProvider.notifier).state = value;
                          context.go('/onboarding');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // CTA Button - Sticky at bottom
        Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing6),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accentBlue,
                    AppColors.accentPurple,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  final name = controller.text.trim();
                  if (name.isNotEmpty && storage != null) {
                    await storage.setRegistryName(name);
                    ref.read(registryNameProvider.notifier).state = name;
                    context.go('/onboarding');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacing4,
                    vertical: AppSpacing.spacing3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create Registry',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spacing2),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.brandPrimary,
          size: 24,
        ),
        const SizedBox(width: AppSpacing.spacing3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.neutral500,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral400,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
