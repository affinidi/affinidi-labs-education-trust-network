import 'package:flutter/material.dart';

/// NovaCorp Employer Verification Portal - Spacing Tokens
/// Version: 2.0.0
/// Last Updated: 2026-01-07
///
/// Design Token Reference: verifier-portal/design-language/03-design-tokens.yaml
/// Section: spacing
///
/// Usage:
/// ```dart
/// final spacing = Theme.of(context).extension<SpacingTokens>()!;
/// Container(padding: EdgeInsets.all(spacing.spacing2));
/// ```

class SpacingTokens extends ThemeExtension<SpacingTokens> {
  // ===========================================================================
  // SPACING SCALE (8px Grid)
  // Token: spacing.*
  // ===========================================================================

  final double spacing0; // 0px - No spacing
  final double spacing1; // 8px - Micro spacing
  final double spacing2; // 16px - Small spacing (most common)
  final double spacing3; // 24px - Medium spacing
  final double spacing4; // 32px - Large spacing
  final double spacing5; // 40px - XL spacing
  final double spacing6; // 48px - 2XL spacing
  final double spacing8; // 64px - 3XL spacing
  final double spacing10; // 80px - 4XL spacing
  final double spacing12; // 96px - 5XL spacing
  final double spacing16; // 128px - 6XL spacing (rarely used)

  const SpacingTokens({
    required this.spacing0,
    required this.spacing1,
    required this.spacing2,
    required this.spacing3,
    required this.spacing4,
    required this.spacing5,
    required this.spacing6,
    required this.spacing8,
    required this.spacing10,
    required this.spacing12,
    required this.spacing16,
  });

  // ===========================================================================
  // DEFAULT SPACING (8px Grid)
  // ===========================================================================

  static const SpacingTokens standard = SpacingTokens(
    spacing0: 0.0,
    spacing1: 8.0,
    spacing2: 16.0,
    spacing3: 24.0,
    spacing4: 32.0,
    spacing5: 40.0,
    spacing6: 48.0,
    spacing8: 64.0,
    spacing10: 80.0,
    spacing12: 96.0,
    spacing16: 128.0,
  );

  @override
  ThemeExtension<SpacingTokens> copyWith({
    double? spacing0,
    double? spacing1,
    double? spacing2,
    double? spacing3,
    double? spacing4,
    double? spacing5,
    double? spacing6,
    double? spacing8,
    double? spacing10,
    double? spacing12,
    double? spacing16,
  }) {
    return SpacingTokens(
      spacing0: spacing0 ?? this.spacing0,
      spacing1: spacing1 ?? this.spacing1,
      spacing2: spacing2 ?? this.spacing2,
      spacing3: spacing3 ?? this.spacing3,
      spacing4: spacing4 ?? this.spacing4,
      spacing5: spacing5 ?? this.spacing5,
      spacing6: spacing6 ?? this.spacing6,
      spacing8: spacing8 ?? this.spacing8,
      spacing10: spacing10 ?? this.spacing10,
      spacing12: spacing12 ?? this.spacing12,
      spacing16: spacing16 ?? this.spacing16,
    );
  }

  @override
  ThemeExtension<SpacingTokens> lerp(
    ThemeExtension<SpacingTokens>? other,
    double t,
  ) {
    if (other is! SpacingTokens) return this;

    return SpacingTokens(
      spacing0: spacing0,
      spacing1: spacing1,
      spacing2: spacing2,
      spacing3: spacing3,
      spacing4: spacing4,
      spacing5: spacing5,
      spacing6: spacing6,
      spacing8: spacing8,
      spacing10: spacing10,
      spacing12: spacing12,
      spacing16: spacing16,
    );
  }
}
