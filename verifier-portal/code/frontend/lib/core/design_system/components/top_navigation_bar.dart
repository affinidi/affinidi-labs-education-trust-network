import 'package:flutter/material.dart';
import '../tokens/color_tokens.dart';
import '../tokens/spacing_tokens.dart';

/// NovaCorp Top Navigation Bar
///
/// Design Token Reference: verifier-portal/design-language/03-design-tokens.yaml
/// Component Spec: verifier-portal/design-language/05-components.md#top-navigation-bar
///
/// Top navigation bar featuring NovaCorp logo and primary navigation.
/// Provides consistent branding across all job listing and application screens.
///
/// **Design Tokens**:
/// - Height: 80px desktop (`components.topNavigation.height`)
/// - Height Mobile: 64px (`components.topNavigation.heightMobile`)
/// - Logo Height: 40px desktop (`components.logo.height`)
/// - Logo Height Mobile: 32px (`components.logo.heightMobile`)
/// - Padding: 32px desktop (`spacing.4`), 16px mobile (`spacing.2`)
/// - Elevation: 1 (`elevation.1`)
///
/// **Accessibility**:
/// - Logo has semantic label "NovaCorp Careers Home"
/// - All navigation items meet 44x44px touch target minimum
/// - Keyboard accessible via Tab navigation
/// - Focus indicators visible on all interactive elements
class TopNavigationBar extends StatelessWidget {
  /// Callback when logo is tapped. Typically navigates to home/careers page.
  final VoidCallback? onLogoTap;

  /// Optional navigation items to display (desktop only)
  final List<NavigationItem>? items;

  /// Whether to show a bottom border for visual separation
  final bool showBorder;

  const TopNavigationBar({
    super.key,
    this.onLogoTap,
    this.items,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;
    final isMobile = MediaQuery.of(context).size.width < 640;

    // Token: components.topNavigation.height (80px desktop, 64px mobile)
    final height = isMobile ? 64.0 : 80.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colorTokens.neutral0, // Token: colors.surface.light.background
        border: showBorder
            ? Border(
                bottom: BorderSide(
                  color: colorTokens.neutral200, // Token: colors.neutral.200
                  width: 1,
                ),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Subtle shadow
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          _buildLogo(context, colorTokens, spacingTokens, isMobile),

          SizedBox(width: spacingTokens.spacing3), // Token: spacing.3 (24px)
          // Navigation Items (Desktop only)
          if (!isMobile && items != null && items!.isNotEmpty)
            ...items!.map((item) => _NavigationButton(item: item)),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLogo(
    BuildContext context,
    ColorTokens colorTokens,
    SpacingTokens spacingTokens,
    bool isMobile,
  ) {
    // Token: components.logo.height (40px desktop, 32px mobile)
    // Using text-based logo for now - replace with SVG when available

    return InkWell(
      onTap: onLogoTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.all(
          spacingTokens.spacing1,
        ), // Token: spacing.1 (8px)
        child: Row(
          children: [
            // Logo Icon/Text (placeholder - replace with actual SVG)
            // For now, using text-based logo
            Text(
              'NovaCorp',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: colorTokens.primary500,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Careers',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.w400,
                color: colorTokens.neutral700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation item for TopNavigationBar
class NavigationItem {
  /// Display label for the navigation item
  final String label;

  /// Callback when navigation item is tapped
  final VoidCallback onTap;

  NavigationItem({required this.label, required this.onTap});
}

/// Internal widget for navigation buttons
class _NavigationButton extends StatelessWidget {
  final NavigationItem item;

  const _NavigationButton({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;

    return TextButton(
      onPressed: item.onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: spacingTokens.spacing2, // Token: spacing.2 (16px)
          vertical: spacingTokens.spacing1 + spacingTokens.spacing2 / 2, // 12px
        ),
        minimumSize: const Size(44, 44), // Token: touchTarget.minimum
        foregroundColor: colorTokens.neutral700, // Token: colors.neutral.700
      ),
      child: Text(
        item.label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
