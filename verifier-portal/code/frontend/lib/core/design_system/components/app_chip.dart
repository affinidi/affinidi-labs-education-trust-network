import 'package:flutter/material.dart';
import '../tokens/color_tokens.dart';
import '../tokens/spacing_tokens.dart';

/// NovaCorp Job Attribute Chip/Pill
///
/// Design Token Reference: verifier-portal/design-language/03-design-tokens.yaml
/// Component Spec: verifier-portal/design-language/05-components.md#chippill
///
/// Compact UI elements displaying job attributes, tags, or metadata.
/// Pills provide visual categorization and quick scanning of job characteristics
/// like employment type, location, and candidate count.
///
/// **Design Tokens**:
/// - Padding: 12px horizontal, 6px vertical (`components.chip.paddingHorizontal/Vertical`)
/// - Border Radius: 16px (`components.chip.borderRadius`)
/// - Font Size: 12px (`components.chip.fontSize`)
/// - Font Weight: 500 (`components.chip.fontWeight`)
/// - Min Height: 28px (`components.chip.minHeight`)
/// - Gap: 8px between chips (`components.chip.gap`)
///
/// **Variants**:
/// - Standard: Light gray background (neutral.100), for general attributes
/// - Primary: Light purple background (primary.50), for emphasized features
/// - Success: Light green background (verified.light), for positive indicators
/// - Info: Light cyan background (secondary.50), for metadata
///
/// **Usage**:
/// ```dart
/// AppChip.standard(label: 'Full Time')
/// AppChip.primary(label: 'Featured')
/// AppChip.success(label: 'Verified Employer', icon: Icons.check_circle)
/// AppChip.info(label: '23 Candidates')
/// ```
class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final bool isLarge;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    required this.backgroundColor,
    required this.textColor,
    this.isLarge = false,
  });

  /// Standard chip - light gray background
  ///
  /// Use for general job attributes: employment type, location, department
  /// Token: components.chip.backgroundDefault (neutral.100)
  factory AppChip.standard({
    required String label,
    IconData? icon,
    VoidCallback? onTap,
    bool isLarge = false,
    required BuildContext context,
  }) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    return AppChip(
      label: label,
      icon: icon,
      onTap: onTap,
      isLarge: isLarge,
      backgroundColor: colorTokens.neutral100, // Token: colors.neutral.100
      textColor: colorTokens.neutral700, // Token: colors.neutral.700
    );
  }

  /// Primary chip - light purple background
  ///
  /// Use for highlighted features: "Featured", "Hot", "New"
  /// Token: components.chip.backgroundPrimary (primary.50)
  factory AppChip.primary({
    required String label,
    IconData? icon,
    VoidCallback? onTap,
    bool isLarge = false,
    required BuildContext context,
  }) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    return AppChip(
      label: label,
      icon: icon,
      onTap: onTap,
      isLarge: isLarge,
      backgroundColor: colorTokens.primary50, // Token: colors.primary.50
      textColor: colorTokens.primary700, // Token: colors.primary.700
    );
  }

  /// Success chip - light green background
  ///
  /// Use for positive indicators: "Verified Employer", "Trusted"
  /// Token: components.chip.backgroundSuccess (verified.light)
  factory AppChip.success({
    required String label,
    IconData? icon,
    VoidCallback? onTap,
    bool isLarge = false,
    required BuildContext context,
  }) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    return AppChip(
      label: label,
      icon: icon,
      onTap: onTap,
      isLarge: isLarge,
      backgroundColor:
          colorTokens.verifiedLight, // Token: colors.semantic.verified.light
      textColor:
          colorTokens.verifiedDark, // Token: colors.semantic.verified.dark
    );
  }

  /// Info chip - light cyan background
  ///
  /// Use for neutral information: "100% Remote", "Hybrid", candidate counts
  /// Token: components.chip.backgroundInfo (secondary.50)
  factory AppChip.info({
    required String label,
    IconData? icon,
    VoidCallback? onTap,
    bool isLarge = false,
    required BuildContext context,
  }) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    return AppChip(
      label: label,
      icon: icon,
      onTap: onTap,
      isLarge: isLarge,
      backgroundColor: colorTokens.secondary50, // Token: colors.secondary.50
      textColor: colorTokens.secondary700, // Token: colors.secondary.700
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;

    // Token: components.chip.paddingHorizontal/Vertical (12px/6px standard, 16px/8px large)
    final horizontalPadding = isLarge ? 16.0 : 12.0;
    final verticalPadding = isLarge ? 8.0 : 6.0;

    // Token: components.chip.fontSize (12px standard, 14px large)
    final fontSize = isLarge ? 14.0 : 12.0;

    // Token: components.chip.borderRadius (16px standard, 20px large)
    final borderRadius = isLarge ? 20.0 : 16.0;

    final chipContent = Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius), // Fully rounded pill
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isLarge ? 18 : 16, color: textColor),
            SizedBox(width: spacingTokens.spacing1 / 2), // 4px gap
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: textColor,
              height: 1.2, // Compact line height
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: chipContent,
      );
    }

    return chipContent;
  }
}

/// Chip group wrapper for displaying multiple chips together
///
/// Automatically handles wrapping and spacing between chips
/// Token: components.chip.gap (8px)
class ChipGroup extends StatelessWidget {
  final List<Widget> chips;
  final double spacing;
  final double runSpacing;

  const ChipGroup({
    super.key,
    required this.chips,
    this.spacing = 8.0, // Token: components.chip.gap
    this.runSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: spacing, runSpacing: runSpacing, children: chips);
  }
}
