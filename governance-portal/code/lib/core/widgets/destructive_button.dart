import 'package:flutter/material.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';

/// Destructive Button (Text Button variant)
///
/// Used for destructive actions like "Delete" or "Revoke" that should be
/// clearly marked with error/danger color.
///
/// Usage:
/// ```dart
/// DestructiveButton(
///   label: 'Delete',
///   onPressed: () => _handleDelete(),
/// )
/// ```
class DestructiveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const DestructiveButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: Theme.of(context).textButtonTheme.style?.copyWith(
              foregroundColor: WidgetStateProperty.all(AppColors.semanticError),
            ),
      );
    }

    return TextButton(
      onPressed: onPressed,
      style: Theme.of(context).textButtonTheme.style?.copyWith(
            foregroundColor: WidgetStateProperty.all(AppColors.semanticError),
          ),
      child: Text(label),
    );
  }
}
