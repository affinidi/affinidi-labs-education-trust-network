import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import 'primary_cta_button.dart';

/// Main application header following design system specs
/// Layout: [Title] [Search Bar] [Actions: Create Button + Notifications]
class AppHeader extends ConsumerWidget {
  final String title;
  final String? searchPlaceholder;
  final ValueChanged<String>? onSearchChanged;
  final String? searchValue;
  final VoidCallback? onClearSearch;
  final bool showSearchBar;
  final bool showCreateButton;
  final bool showNotifications;
  final VoidCallback? onCreatePressed;
  final String createButtonLabel;
  final IconData createButtonIcon;

  const AppHeader({
    super.key,
    required this.title,
    this.searchPlaceholder = 'Search...',
    this.onSearchChanged,
    this.searchValue,
    this.onClearSearch,
    this.showSearchBar = false,
    this.showCreateButton = true,
    this.showNotifications = true,
    this.onCreatePressed,
    this.createButtonLabel = 'Create Record',
    this.createButtonIcon = Icons.add,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 900;

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        border: Border(
          bottom: BorderSide(
            color: AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Section Title (Left)
          if (!isSmallScreen)
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral500,
                    ),
              ),
            )
          else
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral500,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(width: 16),

          // Search Bar (Center/Flex) - Optional
          if (showSearchBar) ...[
            Expanded(
              flex: isSmallScreen ? 1 : 2,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 480),
                  height: 44,
                  child: TextField(
                    onChanged: onSearchChanged,
                    controller: searchValue != null
                        ? TextEditingController(text: searchValue)
                        : null,
                    decoration: InputDecoration(
                      hintText: searchPlaceholder,
                      hintStyle: TextStyle(
                        color: AppColors.neutral400,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.neutral400,
                        size: 20,
                      ),
                      suffixIcon: searchValue != null && searchValue!.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.neutral400,
                                size: 20,
                              ),
                              onPressed: onClearSearch,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.neutral100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.neutral500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Actions (Right)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Notifications Icon
              if (showNotifications) ...[
                IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: AppColors.neutral400,
                    size: 24,
                  ),
                  onPressed: () {
                    // TODO: Show notifications
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No notifications'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  tooltip: 'Notifications',
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Create Record Button (Primary CTA) - Hide on small screens
              if (showCreateButton && screenWidth >= 900)
                PrimaryCTAButton(
                  label: createButtonLabel,
                  icon: createButtonIcon,
                  onPressed: onCreatePressed ??
                      () {
                        context.go('/records/create');
                      },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
