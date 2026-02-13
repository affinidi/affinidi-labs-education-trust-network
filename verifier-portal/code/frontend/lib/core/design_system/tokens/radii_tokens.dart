import 'package:flutter/material.dart';

/// NovaCorp Employer Verification Portal - Radii Tokens
/// Version: 2.0.0
/// Last Updated: 2026-01-07
///
/// Design Token Reference: verifier-portal/design-language/03-design-tokens.yaml
/// Section: radius
///
/// Usage:
/// ```dart
/// final radii = Theme.of(context).extension<RadiiTokens>()!;
/// Container(decoration: BoxDecoration(borderRadius: radii.borderMd));
/// ```

class RadiiTokens extends ThemeExtension<RadiiTokens> {
  // ===========================================================================
  // BORDER RADIUS VALUES
  // Token: radius.*
  // ===========================================================================

  final double none; // 0px - Sharp corners
  final double sm; // 4px - Subtle rounding
  final double md; // 8px - Default for most elements
  final double lg; // 12px - Cards, large containers
  final double xl; // 16px - Prominent rounding
  final double xl2; // 24px - Very rounded
  final double xl3; // 30px - Pills, rounded inputs
  final double full; // 9999px - Perfect circles, pills

  // ===========================================================================
  // BORDER RADIUS OBJECTS (Convenience)
  // ===========================================================================

  BorderRadius get borderNone => BorderRadius.circular(none);
  BorderRadius get borderSm => BorderRadius.circular(sm);
  BorderRadius get borderMd => BorderRadius.circular(md);
  BorderRadius get borderLg => BorderRadius.circular(lg);
  BorderRadius get borderXl => BorderRadius.circular(xl);
  BorderRadius get border2xl => BorderRadius.circular(xl2);
  BorderRadius get border3xl => BorderRadius.circular(xl3);
  BorderRadius get borderFull => BorderRadius.circular(full);

  // ===========================================================================
  // ROUNDED RECTANGLE BORDERS (ShapeBorder)
  // ===========================================================================

  RoundedRectangleBorder get shapeNone =>
      RoundedRectangleBorder(borderRadius: borderNone);
  RoundedRectangleBorder get shapeSm =>
      RoundedRectangleBorder(borderRadius: borderSm);
  RoundedRectangleBorder get shapeMd =>
      RoundedRectangleBorder(borderRadius: borderMd);
  RoundedRectangleBorder get shapeLg =>
      RoundedRectangleBorder(borderRadius: borderLg);
  RoundedRectangleBorder get shapeXl =>
      RoundedRectangleBorder(borderRadius: borderXl);
  RoundedRectangleBorder get shape2xl =>
      RoundedRectangleBorder(borderRadius: border2xl);
  RoundedRectangleBorder get shape3xl =>
      RoundedRectangleBorder(borderRadius: border3xl);
  RoundedRectangleBorder get shapeFull =>
      RoundedRectangleBorder(borderRadius: borderFull);

  const RadiiTokens({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xl2,
    required this.xl3,
    required this.full,
  });

  // ===========================================================================
  // DEFAULT RADII
  // ===========================================================================

  static const RadiiTokens standard = RadiiTokens(
    none: 0.0,
    sm: 4.0,
    md: 8.0,
    lg: 12.0,
    xl: 16.0,
    xl2: 24.0,
    xl3: 30.0,
    full: 9999.0,
  );

  @override
  ThemeExtension<RadiiTokens> copyWith({
    double? none,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xl2,
    double? xl3,
    double? full,
  }) {
    return RadiiTokens(
      none: none ?? this.none,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xl2: xl2 ?? this.xl2,
      xl3: xl3 ?? this.xl3,
      full: full ?? this.full,
    );
  }

  @override
  ThemeExtension<RadiiTokens> lerp(
    ThemeExtension<RadiiTokens>? other,
    double t,
  ) {
    if (other is! RadiiTokens) return this;

    return RadiiTokens(
      none: none,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xl2: xl2,
      xl3: xl3,
      full: full,
    );
  }
}
