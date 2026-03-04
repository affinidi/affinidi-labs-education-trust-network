import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/widgets/app_header.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'Profile',
            searchPlaceholder: 'Search...',
            showCreateButton: false,
            showNotifications: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.spacing6),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile header card
                      _buildProfileHeader(context),
                      const SizedBox(height: AppSpacing.spacing6),

                      // Account Information
                      _buildSection(
                        context: context,
                        title: 'Account Information',
                        items: [
                          _buildInfoItem(
                            context: context,
                            icon: Icons.person_outline,
                            label: 'Name',
                            value: 'Johnny Demo',
                          ),
                          _buildInfoItem(
                            context: context,
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: 'johnny.demo@nexigen.com',
                          ),
                          _buildInfoItem(
                            context: context,
                            icon: Icons.business_outlined,
                            label: 'Organization',
                            value: 'Nexigen Inc.',
                          ),
                          _buildInfoItem(
                            context: context,
                            icon: Icons.badge_outlined,
                            label: 'Role',
                            value: 'Administrator',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.spacing6),

                      // DID Information
                      _buildSection(
                        context: context,
                        title: 'DID Configuration',
                        items: [
                          _buildInfoItem(
                            context: context,
                            icon: Icons.fingerprint,
                            label: 'DID',
                            value: 'did:peer:2.Vz6Mk...',
                            isMonospace: true,
                          ),
                          _buildInfoItem(
                            context: context,
                            icon: Icons.vpn_key_outlined,
                            label: 'Key Type',
                            value: 'Ed25519',
                          ),
                          _buildInfoItem(
                            context: context,
                            icon: Icons.verified_user_outlined,
                            label: 'Status',
                            value: 'Active',
                            valueColor: AppColors.semanticSuccess,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.spacing6),

                      // // Activity Summary
                      // _buildSection(
                      //   context: context,
                      //   title: 'Activity Summary',
                      //   items: [
                      //     _buildStatItem(
                      //       context: context,
                      //       icon: Icons.inventory_2_outlined,
                      //       label: 'Records Created',
                      //       value: '127',
                      //       color: AppColors.linkMain,
                      //     ),
                      //     _buildStatItem(
                      //       context: context,
                      //       icon: Icons.edit_outlined,
                      //       label: 'Records Updated',
                      //       value: '45',
                      //       color: AppColors.semanticWarning,
                      //     ),
                      //     _buildStatItem(
                      //       context: context,
                      //       icon: Icons.delete_outline,
                      //       label: 'Records Deleted',
                      //       value: '12',
                      //       color: AppColors.semanticError,
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: AppSpacing.spacing6),

                      // Actions
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandPrimary,
            AppColors.brandPrimaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      padding: const EdgeInsets.all(AppSpacing.spacing6),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.neutral0,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              Icons.person,
              size: 48,
              color: AppColors.brandPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.spacing4),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin User',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.spacing1),
                Text(
                  'Administrator',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.navTextSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.spacing2),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: AppColors.semanticSuccess,
                    ),
                    const SizedBox(width: AppSpacing.spacing1),
                    Text(
                      'Active',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.navTextSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.spacing2,
            bottom: AppSpacing.spacing3,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.neutral400,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.neutral0,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: AppColors.neutral200,
              width: 1,
            ),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isMonospace = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              icon,
              color: AppColors.neutral400,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral400,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: valueColor ?? AppColors.neutral500,
                        fontFamily: isMonospace ? 'monospace' : null,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement edit profile
            },
            icon: Icon(Icons.edit_outlined),
            label: Text('Edit Profile'),
            // style: OutlinedButton.styleFrom(
            //   padding: const EdgeInsets.all(AppSpacing.spacing4),
            //   side: BorderSide(color: AppColors.neutral200),
            //   foregroundColor: AppColors.neutral500,
            // ),
          ),
        ),
        const SizedBox(width: AppSpacing.spacing3),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement change password
            },
            icon: Icon(Icons.lock_outlined),
            label: Text('Change Password'),
            // style: ElevatedButton.styleFrom(
            //   padding: const EdgeInsets.all(AppSpacing.spacing4),
            //   backgroundColor: AppColors.linkMain,
            //   foregroundColor: AppColors.neutral0,
            // ),
          ),
        ),
      ],
    );
  }
}
