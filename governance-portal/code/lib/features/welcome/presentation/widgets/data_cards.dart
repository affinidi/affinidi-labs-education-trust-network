import 'package:flutter/material.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/features/authorities/domain/entities/authority.dart';
import 'package:governance_portal/features/entities/domain/entities/entity.dart';

class AuthorityCard extends StatelessWidget {
  final Authority authority;

  const AuthorityCard({
    super.key,
    required this.authority,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing3),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.admin_panel_settings_outlined,
                  size: 20, color: AppColors.brandPrimary),
              const SizedBox(width: AppSpacing.spacing2),
              Expanded(
                child: Text(
                  authority.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Row(
            children: [
              Icon(Icons.fingerprint_outlined,
                  size: 16, color: AppColors.neutral400),
              const SizedBox(width: AppSpacing.spacing1),
              Expanded(
                child: Text(
                  authority.did,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral400,
                        fontFamily: 'monospace',
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EntityCard extends StatelessWidget {
  final Entity entity;

  const EntityCard({
    super.key,
    required this.entity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing3),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.business_outlined,
                  size: 20, color: AppColors.brandPrimary),
              const SizedBox(width: AppSpacing.spacing2),
              Expanded(
                child: Text(
                  entity.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Row(
            children: [
              Icon(Icons.fingerprint_outlined,
                  size: 16, color: AppColors.neutral400),
              const SizedBox(width: AppSpacing.spacing1),
              Expanded(
                child: Text(
                  entity.did,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral400,
                        fontFamily: 'monospace',
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
