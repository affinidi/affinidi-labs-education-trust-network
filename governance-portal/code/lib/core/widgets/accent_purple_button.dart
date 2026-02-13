import 'package:flutter/material.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';

/// Accent Purple Button
///
/// Used for special actions like DID generation that need to stand out
/// with the purple accent color from the design system.
///
/// Usage:
/// ```dart
/// AccentPurpleButton(
///   onPressed: _generateDid,
///   icon: Icons.auto_awesome,
///   label: 'Generate',
///   isLoading: _isGeneratingDid,
/// )
/// ```
class AccentPurpleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String label;
  final bool isLoading;

  const AccentPurpleButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.label,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: onPressed == null
            ? null
            : const LinearGradient(
                colors: [
                  AppColors.accentPink, // Pink
                  AppColors.accentPurple, // Purple
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: onPressed == null ? AppColors.neutral200 : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(icon ?? Icons.auto_awesome, size: 16),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
