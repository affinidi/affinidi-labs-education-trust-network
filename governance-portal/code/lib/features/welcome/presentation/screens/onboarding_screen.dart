import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:governance_portal/core/config/framework_templates.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/design_system/app_typography.dart';
import 'package:governance_portal/core/storage/settings_provider.dart';
import 'package:governance_portal/features/welcome/presentation/widgets/framework_selection.dart';
import 'package:governance_portal/features/welcome/presentation/screens/authority_setup_screen.dart';
import 'package:governance_portal/features/welcome/presentation/widgets/registry_name_section.dart';

/// Onboarding screen with framework selection and template-based setup
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _registryNameController;
  late final AnimationController _frameworkCardController;
  late final Animation<double> _frameworkCardAnimation;
  late final ScrollController _scrollController;

  int _currentStep = 0;
  TrustFrameworkTemplate? _selectedFramework;

  @override
  void initState() {
    super.initState();
    _registryNameController = TextEditingController();
    _scrollController = ScrollController();
    _frameworkCardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _frameworkCardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _frameworkCardController, curve: Curves.easeOut),
    );

    // Pre-fill registry name if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final registryName = ref.read(registryNameProvider);
      if (registryName != null && registryName.isNotEmpty) {
        _registryNameController.text = registryName;
        setState(() {
          _currentStep = 1;
        });
        _frameworkCardController.forward();
      }
    });

    // Listen to text changes and update provider
    _registryNameController.addListener(() async {
      final name = _registryNameController.text.trim();
      if (name.isNotEmpty) {
        final storage = ref.read(settingsStorageProvider).valueOrNull;
        if (storage != null) {
          await storage.setRegistryName(name);
          ref.read(registryNameProvider.notifier).state = name;
        }
      }
    });
  }

  @override
  void dispose() {
    _registryNameController.dispose();
    _frameworkCardController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for changes to registryNameProvider and update controller
    ref.listen<String?>(registryNameProvider, (previous, next) {
      if (next != null && next.isNotEmpty && next != _registryNameController.text) {
        _registryNameController.text = next;
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.navBackground,
        ),
        child: Stack(
          children: [
            // Background pink circle - stays fixed
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 800,
                  height: 800,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentPink.withOpacity(0.2),
                        AppColors.accentPink.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -200,
              left: -1000,
              right: 1,
              child: Center(
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentBlue.withOpacity(0.3),
                        AppColors.accentBlue.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Scrollable content
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: const EdgeInsets.all(AppSpacing.spacing6),
                child: SingleChildScrollView(
                  controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main content card
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.spacing6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step 0: Registry Name
                        RegistryNameSection(
                          controller: _registryNameController,
                          showContinueButton: _currentStep == 0,
                          onContinue: () async {
                            final name = _registryNameController.text.trim();
                            if (name.isNotEmpty) {
                              final storage =
                                  ref.read(settingsStorageProvider).valueOrNull;
                              if (storage != null) {
                                await storage.setRegistryName(name);
                                ref.read(registryNameProvider.notifier).state =
                                    name;
                                setState(() {
                                  _currentStep = 1;
                                });
                                _frameworkCardController.forward();
                              }
                            }
                          },
                        ),

                        // Step 1: Framework Selection
                        if (_currentStep >= 1) ...[
                          const SizedBox(height: AppSpacing.spacing12),
                          FadeTransition(
                            opacity: _frameworkCardAnimation,
                            child: FrameworkSelection(
                              selectedFramework: _selectedFramework,
                              onFrameworkSelected: (framework) {
                                setState(() {
                                  _selectedFramework = framework;
                                });
                              },
                            ),
                          ),
                        ],

                        // Continue button (shows after framework selection)
                        if (_currentStep >= 1 && _selectedFramework != null) ...[
                          const SizedBox(height: AppSpacing.spacing6),
                          SizedBox(
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.accentBlueDark,
                                    AppColors.accentPurpleDark,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AuthoritySetupScreen(
                                        selectedFramework: _selectedFramework,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.spacing4,
                                  ),
                                ),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(fontSize: AppTypography.fontSizeLg),
                                ),
                              ),
                            ),
                          ),
                        ],

                        // Skip button
                        if (_currentStep >= 1) ...[
                          const SizedBox(height: AppSpacing.spacing3),
                          Center(
                            child: TextButton(
                              onPressed: () => context.go('/dashboard'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.neutral400,
                              ),
                              child: Text(
                                'Skip for now',
                                style: TextStyle(fontSize: AppTypography.fontSizeMd),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
            ),
            
            // Toggle navigation button (bottom right)
            if (_selectedFramework != null && _registryNameController.text.trim().isNotEmpty)
              Positioned(
                bottom: AppSpacing.spacing6,
                right: AppSpacing.spacing6,
                child: _buildToggleButton(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AuthoritySetupScreen(
                selectedFramework: _selectedFramework,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.navText.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.navText,
            size: 32,
          ),
        ),
      ),
    );
  }
}
