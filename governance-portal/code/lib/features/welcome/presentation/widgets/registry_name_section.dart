import 'package:flutter/material.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/design_system/app_typography.dart';

class RegistryNameSection extends StatelessWidget {
  final TextEditingController controller;
  final bool showContinueButton;
  final VoidCallback onContinue;

  const RegistryNameSection({
    super.key,
    required this.controller,
    required this.showContinueButton,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Your Trust Registry',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing2),
        Text(
          'Enter a name for your trust registry to get started',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
        ),
        const SizedBox(height: AppSpacing.spacing3),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accentPurple.withOpacity(0.4),
                AppColors.accentBlue.withOpacity(0.45),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          padding: const EdgeInsets.all(3),
          child: TextField(
            controller: controller,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppTypography.fontSizeLg,
            ),
            decoration: InputDecoration(
              hintText: 'e.g., Hong Kong Education Registry',
              hintStyle: TextStyle(
                color: AppColors.textTertiary,
                fontSize: AppTypography.fontSizeLg,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd - 3),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd - 3),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd - 3),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.neutral0,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing3,
                vertical: AppSpacing.spacing4,
              ),
            ),
            onSubmitted: (_) => onContinue(),
          ),
        ),
        if (showContinueButton) ...[
          const SizedBox(height: AppSpacing.spacing4),
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
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: AppTypography.fontSizeLg,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
