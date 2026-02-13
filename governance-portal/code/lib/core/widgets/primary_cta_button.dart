import 'package:flutter/material.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';

/// Primary CTA Button with vibrant blue-purple gradient
///
/// This is the standard button for primary actions like "Create Record", "Save", "Submit".
/// Implements the design system specifications from 05-components.md.
///
/// Key Features:
/// - Vibrant blue-purple gradient (AppColors.accentBlue → AppColors.accentPurple)
/// - White text, semibold (600)
/// - 44px minimum height
/// - 8px border radius
/// - Increased padding (28px/14px) to prevent text cutoff
/// - Hover/pressed states with darker gradient
///
/// Usage:
/// ```dart
/// PrimaryCTAButton(
///   label: 'Create Record',
///   icon: Icons.add,
///   onPressed: () => _handleCreate(),
/// )
/// ```
class PrimaryCTAButton extends StatelessWidget {
  /// The text label for the button
  final String label;

  /// Optional icon to display before the label
  final IconData? icon;

  /// Optional icon to display after the label
  final IconData? trailingIcon;

  /// Callback when button is pressed. If null, button is disabled.
  final VoidCallback? onPressed;

  /// Whether to show loading indicator
  final bool isLoading;

  /// Whether button should expand to fill available width
  final bool fullWidth;

  const PrimaryCTAButton({
    super.key,
    required this.label,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    Widget buttonChild;

    if (isLoading) {
      buttonChild = const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (icon != null || trailingIcon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.32,
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            Icon(
              trailingIcon,
              size: 20,
              color: Colors.white,
            ),
          ],
        ],
      );
    } else {
      buttonChild = Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.32,
        ),
      );
    }

    return Container(
      width: fullWidth ? double.infinity : null,
      height: 44,
      decoration: BoxDecoration(
        gradient: isDisabled || isLoading
            ? null
            : const LinearGradient(
                colors: [
                  AppColors.accentPurple, // Purple
                  AppColors.accentBlue, // Vibrant Blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: isDisabled || isLoading ? AppColors.neutral200 : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: AppColors.neutral400,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          elevation: 0,
        ),
        child: buttonChild,
      ),
    );
  }
}
