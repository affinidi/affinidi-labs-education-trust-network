import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_vault_app/core/hooks/ct_notifier.dart';
import 'package:student_vault_app/core/design_system/convex_container.dart';
import 'package:student_vault_app/features/profile/domain/entities/user_profile.dart';
import 'package:student_vault_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:student_vault_app/core/navigation/navigator.dart';
import 'package:student_vault_app/features/settings/data/settings_service/settings_service.dart';
import 'package:student_vault_app/core/infrastructure/configuration/environment.dart';
import 'package:uuid/uuid.dart';

class OnboardingProfileCard extends HookConsumerWidget {
  const OnboardingProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(environmentProvider);

    // Form key
    final formKey = useMemoized(GlobalKey<FormState>.new);

    // Text controllers with default values from environment
    final firstNameController = useTextEditingController(
      text: environment.studentFirstName,
    );
    final lastNameController = useTextEditingController(
      text: environment.studentLastName,
    );
    final currentCompanyController = useTextEditingController(text: 'Affinidi');
    final currentJobTitleController = useTextEditingController(
      text: 'Senior UX Designer',
    );
    final totalExperienceController = useTextEditingController(text: '60');

    // Loading state
    final isLoadingNotifier = useCTNotifier(false);
    final isLoading = useValueListenable(isLoadingNotifier);

    Future<void> handleSubmit() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      isLoadingNotifier.value = true;

      try {
        // Create user profile with unique ID
        const uuid = Uuid();
        final profile = UserProfile(
          id: uuid.v4(),
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          profilePicPath: '/default/profile.png', // Hardcoded for now
          currentCompany: currentCompanyController.text.trim(),
          currentJobTitle: currentJobTitleController.text.trim(),
          totalExperienceMonths: int.parse(
            totalExperienceController.text.trim(),
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save profile using provider
        await ref.read(userProfileProvider.notifier).saveProfile(profile);
        await ref
            .read(settingsServiceProvider.notifier)
            .setAlreadyOnboarded(true);

        if (context.mounted) {
          // Navigate to dashboard credentials
          ref.read(navigatorProvider).go('/dashboard/credentials');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving profile: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (context.mounted) {
          isLoadingNotifier.value = false;
        }
      }
    }

    return ConvexContainer(
      color: const Color.fromARGB(255, 255, 246, 225),
      curveHeight: 20,
      edgeHeight: 40,
      overlapOffset: -40,
      child: SizedBox.expand(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Create your Student Profile',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 8),
                  // Text(
                  //   'Please provide your details to get started',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  // ),
                  const SizedBox(height: 32),

                  // First Name
                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      hintText: 'Enter your first name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      hintText: 'Enter your last name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Current Company
                  TextFormField(
                    controller: currentCompanyController,
                    decoration: InputDecoration(
                      labelText: 'Current Company',
                      hintText: 'Enter your current company',
                      prefixIcon: const Icon(Icons.business),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your current company';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Current Job Title
                  TextFormField(
                    controller: currentJobTitleController,
                    decoration: InputDecoration(
                      labelText: 'Current Job Title',
                      hintText: 'Enter your current job title',
                      prefixIcon: const Icon(Icons.work_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your current job title';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Total Experience (Months)
                  TextFormField(
                    controller: totalExperienceController,
                    decoration: InputDecoration(
                      labelText: 'Total Experience (Months)',
                      hintText: 'Enter your total experience in months',
                      prefixIcon: const Icon(Icons.timer_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      helperText: 'e.g., 24 for 2 years',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your total experience';
                      }
                      final months = int.tryParse(value);
                      if (months == null || months < 0) {
                        return 'Please enter a valid number of months';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  ElevatedButton(
                    onPressed: isLoading ? null : handleSubmit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
