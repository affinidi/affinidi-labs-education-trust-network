import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';

/// Filter chip component with optional close button
///
/// Follows design system: neutral background, clean typography,
/// removable chips for active filters, pinned chips for defaults
class FilterChip extends StatelessWidget {
  final String label;
  final bool isPinned;
  final VoidCallback? onRemove;

  const FilterChip({
    super.key,
    required this.label,
    this.isPinned = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing1_5,
      ),
      decoration: BoxDecoration(
        color: isPinned
            ? const Color(0xFF7C3AED) // Selected: solid purple
            : AppColors.neutral100, // Inactive: darker grey
        border: null, // No border for both states
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isPinned
                      ? Colors.white // Selected: white text
                      : AppColors.neutral500, // Inactive: dark text
                  fontWeight: FontWeight.w500,
                ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: isPinned
                      ? Colors.white // Selected: white icon
                      : AppColors.neutral400, // Inactive: gray icon
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
