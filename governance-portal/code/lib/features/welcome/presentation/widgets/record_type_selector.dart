import 'package:flutter/material.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/design_system/app_typography.dart';

class RecordTypeSelector extends StatelessWidget {
  final String? selectedRecordType;
  final Function(String) onRecordTypeSelected;

  const RecordTypeSelector({
    super.key,
    required this.selectedRecordType,
    required this.onRecordTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Record Type',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.brandPrimary,
                fontWeight: AppTypography.fontWeightBold,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing1),
        Text(
          'Choose the type of relationship this record represents',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.neutral400,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing3),
        Row(
          children: [
            Expanded(
              child: _RecordTypeOption(
                value: 'authorizing',
                title: 'Authorizing',
                description:
                    'Authority authorizes the entity to perform actions',
                icon: Icons.verified_user_outlined,
                isSelected: selectedRecordType == 'authorizing',
                onTap: () => onRecordTypeSelected('authorizing'),
              ),
            ),
            const SizedBox(width: AppSpacing.spacing3),
            Expanded(
              child: _RecordTypeOption(
                value: 'recognizing',
                title: 'Recognizing',
                description: 'Authority recognizes the entity\'s capabilities',
                icon: Icons.badge_outlined,
                isSelected: selectedRecordType == 'recognizing',
                onTap: () => onRecordTypeSelected('recognizing'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecordTypeOption extends StatelessWidget {
  final String value;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RecordTypeOption({
    required this.value,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.spacing3),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.accentPurple
                      : AppColors.brandPrimary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.spacing2),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? AppColors.accentPurple
                            : AppColors.brandPrimary,
                        fontWeight: AppTypography.fontWeightBold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacing1),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.neutral400,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
