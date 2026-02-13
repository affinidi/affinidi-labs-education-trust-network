import 'package:flutter/material.dart';
import 'package:governance_portal/core/config/framework_templates.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/design_system/app_typography.dart';

class ResourceSelector extends StatelessWidget {
  final TrustFrameworkTemplate? framework;
  final String? selectedResource;
  final Function(String) onResourceSelected;

  const ResourceSelector({
    super.key,
    required this.framework,
    required this.selectedResource,
    required this.onResourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final resources = framework?.suggestedResources ?? [];

    if (resources.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Resource Type',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.brandPrimary,
                fontWeight: AppTypography.fontWeightBold,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing1),
        Text(
          'What type of credential or resource will be managed?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.neutral400,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing3),
        Wrap(
          spacing: AppSpacing.spacing2,
          runSpacing: AppSpacing.spacing2,
          children: resources.map((resource) {
            return _ResourceOption(
              resource: resource,
              isSelected: selectedResource == resource,
              onTap: () => onResourceSelected(resource),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ResourceOption extends StatelessWidget {
  final String resource;
  final bool isSelected;
  final VoidCallback onTap;

  const _ResourceOption({
    required this.resource,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getIcon() {
    if (resource.toLowerCase().contains('certificate') ||
        resource.toLowerCase().contains('degree')) {
      return Icons.card_membership_outlined;
    } else if (resource.toLowerCase().contains('transcript')) {
      return Icons.description_outlined;
    } else if (resource.toLowerCase().contains('kyc') ||
        resource.toLowerCase().contains('identity')) {
      return Icons.badge_outlined;
    } else if (resource.toLowerCase().contains('token') ||
        resource.toLowerCase().contains('access')) {
      return Icons.key_outlined;
    } else if (resource.toLowerCase().contains('license')) {
      return Icons.workspace_premium_outlined;
    } else {
      return Icons.insert_drive_file_outlined;
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
            Flexible(
              child: Text(
                resource,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? AppColors.accentPurple
                          : AppColors.brandPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
