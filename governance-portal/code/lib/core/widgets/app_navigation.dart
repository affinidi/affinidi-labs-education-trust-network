import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:governance_portal/core/design_system/app_typography.dart';
import 'package:governance_portal/features/records/data/repositories/records_repository.provider.dart';
import 'package:governance_portal/features/records/presentation/screens/record_form_screen.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../storage/settings_provider.dart';
import 'app_modal.dart';
import 'primary_cta_button.dart';

/// Provider for navigation collapse state
final navigationCollapsedProvider = StateProvider<bool>((ref) => false);

/// Dark sidebar navigation following design system specs
/// - Background: #0B1B2B (nav.background)
/// - Width: 280px (expanded), 64px (collapsed)
/// - White text on dark background
/// - Icons: 20px, Labels: 16px medium
class AppNavigation extends ConsumerWidget {
  const AppNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(navigationCollapsedProvider);
    final currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      width: isCollapsed ? 64 : 260,
      color: AppColors.navBackground,
      child: Column(
        children: [
          // Logo area - 64px height
          _buildLogoArea(context, isCollapsed, ref),

          // Create Record CTA - Fixed at top
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              12,
            ),
            child: isCollapsed
                ? Center(child: _buildCollapsedCTAButton(context))
                : _buildExpandedCTAButton(context),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  route: '/dashboard',
                  isSelected: currentRoute == '/dashboard',
                  isCollapsed: isCollapsed,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context: context,
                  icon: Icons.admin_panel_settings,
                  label: 'Authorities',
                  route: '/authorities',
                  isSelected: currentRoute == '/authorities',
                  isCollapsed: isCollapsed,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context: context,
                  icon: Icons.business,
                  label: 'Entities',
                  route: '/entities',
                  isSelected: currentRoute == '/entities',
                  isCollapsed: isCollapsed,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context: context,
                  icon: Icons.inventory_2,
                  label: 'Records',
                  route: '/records',
                  isSelected: currentRoute == '/records',
                  isCollapsed: isCollapsed,
                ),
              ],
            ),
          ),

          // Spacer to push profile/settings to bottom
          const Spacer(),

          // Profile and Settings at bottom
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 8,
            ),
            child: Column(
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.person_outline,
                  label: 'Profile',
                  route: '/profile',
                  isSelected: currentRoute == '/profile',
                  isCollapsed: isCollapsed,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  route: '/settings',
                  isSelected: currentRoute == '/settings',
                  isCollapsed: isCollapsed,
                ),
              ],
            ),
          ),

          // Collapse toggle at bottom
          _buildCollapseButton(context, isCollapsed, ref),
        ],
      ),
    );
  }

  /// Logo area with ministry branding
  Widget _buildLogoArea(
    BuildContext context,
    bool isCollapsed,
    WidgetRef ref,
  ) {
    final registryName = ref.watch(registryNameProvider);

    return Container(
      height: 64,
      padding: isCollapsed
          ? EdgeInsets.zero
          : const EdgeInsets.only(
              left: 12,
              right: 16,
              top: 16,
              bottom: 16,
            ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.navHover.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: isCollapsed
          ? Center(
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Center(
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: AppColors.textOnDark,
                    size: 32,
                  ),
                ),
              ),
            )
          : Row(
              children: [
                const Icon(
                  Icons.blur_circular_outlined,
                  color: AppColors.textOnDark,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    registryName ?? 'Trust Registry',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.navText,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );
  }

  /// Navigation item (48px height per design spec)
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isSelected,
    required bool isCollapsed,
    int? badge,
  }) {
    if (isCollapsed) {
      // Collapsed: 48x48 square button
      return Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.go(route);
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Center(
              child: Icon(
                icon,
                color: AppColors.navText,
                size: 24,
              ),
            ),
          ),
        ),
      );
    }

    // Expanded: full-width button with text
    return InkWell(
      onTap: () {
        context.go(route);
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.navText,
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.navText,
                      fontWeight: isSelected
                          ? AppTypography.fontWeightBold
                          : AppTypography.fontWeightMedium,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.semanticSuccess,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  badge.toString(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.semanticSuccessContrast,
                        fontWeight: AppTypography.fontWeightBold,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Create Record CTA - Collapsed state (gradient icon button)
  Widget _buildCollapsedCTAButton(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.accentPurple, // Purple
            AppColors.accentBlue, // Vibrant Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // Open modal to create record
            await _showCreateRecordModal(context);
          },
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  /// Create Record CTA - Expanded state (full button)
  Widget _buildExpandedCTAButton(BuildContext context) {
    return PrimaryCTAButton(
      label: 'Create Record',
      icon: Icons.add,
      fullWidth: true,
      onPressed: () async {
        // Open modal to create record
        await _showCreateRecordModal(context);
      },
    );
  }

  /// Collapse toggle button at bottom
  Widget _buildCollapseButton(
    BuildContext context,
    bool isCollapsed,
    WidgetRef ref,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isCollapsed ? 0 : 12,
        12,
        isCollapsed ? 0 : 12,
        12,
      ),
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.navHover.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: isCollapsed
          ? Center(
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ref.read(navigationCollapsedProvider.notifier).state =
                          !isCollapsed;
                    },
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: const Center(
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: AppColors.navText,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : InkWell(
              onTap: () {
                ref.read(navigationCollapsedProvider.notifier).state =
                    !isCollapsed;
              },
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_left,
                      color: AppColors.navText,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Collapse',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.navText,
                            fontWeight: AppTypography.fontWeightMedium,
                          ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Show create record modal
  Future<void> _showCreateRecordModal(BuildContext context) async {
    // Get repository from provider
    final container = ProviderScope.containerOf(context);
    final repositoryAsync =
        await container.read(recordsRepositoryProvider.future);

    if (context.mounted) {
      await showAppModal(
        context: context,
        title: 'Create Record',
        body: RecordFormScreen(
          isModal: true,
          repository: repositoryAsync,
        ),
      );
    }
  }
}
