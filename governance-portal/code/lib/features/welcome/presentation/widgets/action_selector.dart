import 'package:flutter/material.dart';
import 'package:governance_portal/core/config/framework_templates.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/design_system/app_typography.dart';

class ActionSelector extends StatelessWidget {
  final TrustFrameworkTemplate? framework;
  final String? selectedAction;
  final Function(String) onActionSelected;

  const ActionSelector({
    super.key,
    required this.framework,
    required this.selectedAction,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final actions = framework?.suggestedActions ?? [];

    if (actions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Action Type',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.brandPrimary,
                fontWeight: AppTypography.fontWeightBold,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing1),
        Text(
          'What action will this record authorize?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.neutral400,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing3),
        Wrap(
          spacing: AppSpacing.spacing2,
          runSpacing: AppSpacing.spacing2,
          children: actions.map((action) {
            return _ActionOption(
              action: action,
              isSelected: selectedAction == action,
              onTap: () => onActionSelected(action),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ActionOption extends StatelessWidget {
  final String action;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActionOption({
    required this.action,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getIcon() {
    switch (action.toLowerCase()) {
      case 'issue':
        return Icons.publish_outlined;
      case 'verify':
        return Icons.verified_outlined;
      case 'revoke':
        return Icons.block_outlined;
      default:
        return Icons.bolt_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing4,
          vertical: AppSpacing.spacing3,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentPurple.withOpacity(0.1)
              : AppColors.neutral0,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.accentPurple : AppColors.neutral200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(),
              size: 20,
              color:
                  isSelected ? AppColors.accentPurple : AppColors.brandPrimary,
            ),
            const SizedBox(width: AppSpacing.spacing2),
            Text(
              action,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isSelected
                        ? AppColors.accentPurple
                        : AppColors.brandPrimary,
                    fontWeight: AppTypography.fontWeightBold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
