import 'package:flutter/material.dart';

/// NovaCorp Employer Verification Portal - Typography Tokens
/// Version: 2.0.0
/// Last Updated: 2026-01-07
///
/// Design Token Reference: verifier-portal/design-language/03-design-tokens.yaml
/// Section: typography
///
/// Usage:
/// ```dart
/// final typography = Theme.of(context).extension<TypographyTokens>()!;
/// Text('Hello', style: typography.bodyLarge);
/// ```

class TypographyTokens extends ThemeExtension<TypographyTokens> {
  // ===========================================================================
  // FONT FAMILY
  // Token: typography.fontFamily.primary
  // ===========================================================================

  final String fontFamilyPrimary;
  final String fontFamilyMonospace;

  // ===========================================================================
  // FONT SIZES (8px baseline grid)
  // Token: typography.fontSize.*
  // ===========================================================================

  final double fontSizeXs; // 10px - Caption, labels (used sparingly)
  final double fontSizeSm; // 12px - Small text, metadata
  final double fontSizeBase; // 14px - Body text (medium)
  final double fontSizeMd; // 16px - Body text (large) - minimum for readability
  final double fontSizeLg; // 18px - Subheadings
  final double fontSizeXl; // 20px - H3, card titles
  final double fontSize2xl; // 24px - H2
  final double fontSize3xl; // 28px - H1 (mobile)
  final double fontSize4xl; // 32px - H1 (tablet)
  final double fontSize5xl; // 36px - H1 (desktop)
  final double fontSize6xl; // 48px - Display text (hero)

  // ===========================================================================
  // FONT WEIGHTS
  // Token: typography.fontWeight.*
  // ===========================================================================

  final FontWeight fontWeightLight; // 300 - Rarely used
  final FontWeight fontWeightRegular; // 400 - Body text default
  final FontWeight fontWeightMedium; // 500 - Emphasis, subheadings
  final FontWeight fontWeightSemibold; // 600 - Strong emphasis
  final FontWeight fontWeightBold; // 700 - Headings, buttons

  // ===========================================================================
  // LINE HEIGHTS (Relative to font size)
  // Token: typography.lineHeight.*
  // ===========================================================================

  final double lineHeightTight; // 1.2 - Headings, tight layouts
  final double lineHeightNormal; // 1.5 - Body text default
  final double lineHeightRelaxed; // 1.75 - Long-form content

  // ===========================================================================
  // LETTER SPACING
  // Token: typography.letterSpacing.*
  // ===========================================================================

  final double letterSpacingTight; // -0.02em - Large headings
  final double letterSpacingNormal; // 0em - Default
  final double letterSpacingWide; // 0.05em - All-caps text, buttons

  // ===========================================================================
  // TEXT STYLES - HEADINGS
  // ===========================================================================

  final TextStyle h1Desktop; // 36px bold
  final TextStyle h1Tablet; // 32px bold
  final TextStyle h1Mobile; // 28px bold
  final TextStyle h2; // 24px bold
  final TextStyle h3; // 20px semibold
  final TextStyle h4; // 18px semibold

  // ===========================================================================
  // TEXT STYLES - BODY
  // ===========================================================================

  final TextStyle bodyLarge; // 16px regular
  final TextStyle bodyMedium; // 14px regular
  final TextStyle bodySmall; // 12px regular

  // ===========================================================================
  // TEXT STYLES - LABELS & BUTTONS
  // ===========================================================================

  final TextStyle labelLarge; // 16px medium
  final TextStyle labelMedium; // 14px medium
  final TextStyle labelSmall; // 12px medium

  // ===========================================================================
  // TEXT STYLES - SPECIAL
  // ===========================================================================

  final TextStyle caption; // 10px regular
  final TextStyle overline; // 10px medium
  final TextStyle monospace; // 14px regular

  const TypographyTokens({
    // Font Family
    required this.fontFamilyPrimary,
    required this.fontFamilyMonospace,
    // Font Sizes
    required this.fontSizeXs,
    required this.fontSizeSm,
    required this.fontSizeBase,
    required this.fontSizeMd,
    required this.fontSizeLg,
    required this.fontSizeXl,
    required this.fontSize2xl,
    required this.fontSize3xl,
    required this.fontSize4xl,
    required this.fontSize5xl,
    required this.fontSize6xl,
    // Font Weights
    required this.fontWeightLight,
    required this.fontWeightRegular,
    required this.fontWeightMedium,
    required this.fontWeightSemibold,
    required this.fontWeightBold,
    // Line Heights
    required this.lineHeightTight,
    required this.lineHeightNormal,
    required this.lineHeightRelaxed,
    // Letter Spacing
    required this.letterSpacingTight,
    required this.letterSpacingNormal,
    required this.letterSpacingWide,
    // Text Styles - Headings
    required this.h1Desktop,
    required this.h1Tablet,
    required this.h1Mobile,
    required this.h2,
    required this.h3,
    required this.h4,
    // Text Styles - Body
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    // Text Styles - Labels
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    // Text Styles - Special
    required this.caption,
    required this.overline,
    required this.monospace,
  });

  // ===========================================================================
  // DEFAULT TYPOGRAPHY
  // ===========================================================================

  static const TypographyTokens standard = TypographyTokens(
    // Font Family
    fontFamilyPrimary: 'Figtree',
    fontFamilyMonospace: 'Fira Code',
    // Font Sizes
    fontSizeXs: 10.0,
    fontSizeSm: 12.0,
    fontSizeBase: 14.0,
    fontSizeMd: 16.0,
    fontSizeLg: 18.0,
    fontSizeXl: 20.0,
    fontSize2xl: 24.0,
    fontSize3xl: 28.0,
    fontSize4xl: 32.0,
    fontSize5xl: 36.0,
    fontSize6xl: 48.0,
    // Font Weights
    fontWeightLight: FontWeight.w300,
    fontWeightRegular: FontWeight.w400,
    fontWeightMedium: FontWeight.w500,
    fontWeightSemibold: FontWeight.w600,
    fontWeightBold: FontWeight.w700,
    // Line Heights
    lineHeightTight: 1.2,
    lineHeightNormal: 1.5,
    lineHeightRelaxed: 1.75,
    // Letter Spacing
    letterSpacingTight: -0.02,
    letterSpacingNormal: 0.0,
    letterSpacingWide: 0.05,
    // Text Styles - Headings
    h1Desktop: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 36.0,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.02,
    ),
    h1Tablet: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.02,
    ),
    h1Mobile: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.02,
    ),
    h2: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
    h3: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
    h4: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      height: 1.5,
    ),
    // Text Styles - Body
    bodyLarge: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    // Text Styles - Labels
    labelLarge: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.05,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.05,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.05,
    ),
    // Text Styles - Special
    caption: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 10.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    overline: TextStyle(
      fontFamily: 'Figtree',
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.05,
    ),
    monospace: TextStyle(
      fontFamily: 'Fira Code',
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
  );

  @override
  ThemeExtension<TypographyTokens> copyWith({
    String? fontFamilyPrimary,
    String? fontFamilyMonospace,
    double? fontSizeXs,
    double? fontSizeSm,
    double? fontSizeBase,
    double? fontSizeMd,
    double? fontSizeLg,
    double? fontSizeXl,
    double? fontSize2xl,
    double? fontSize3xl,
    double? fontSize4xl,
    double? fontSize5xl,
    double? fontSize6xl,
    FontWeight? fontWeightLight,
    FontWeight? fontWeightRegular,
    FontWeight? fontWeightMedium,
    FontWeight? fontWeightSemibold,
    FontWeight? fontWeightBold,
    double? lineHeightTight,
    double? lineHeightNormal,
    double? lineHeightRelaxed,
    double? letterSpacingTight,
    double? letterSpacingNormal,
    double? letterSpacingWide,
    TextStyle? h1Desktop,
    TextStyle? h1Tablet,
    TextStyle? h1Mobile,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? caption,
    TextStyle? overline,
    TextStyle? monospace,
  }) {
    return TypographyTokens(
      fontFamilyPrimary: fontFamilyPrimary ?? this.fontFamilyPrimary,
      fontFamilyMonospace: fontFamilyMonospace ?? this.fontFamilyMonospace,
      fontSizeXs: fontSizeXs ?? this.fontSizeXs,
      fontSizeSm: fontSizeSm ?? this.fontSizeSm,
      fontSizeBase: fontSizeBase ?? this.fontSizeBase,
      fontSizeMd: fontSizeMd ?? this.fontSizeMd,
      fontSizeLg: fontSizeLg ?? this.fontSizeLg,
      fontSizeXl: fontSizeXl ?? this.fontSizeXl,
      fontSize2xl: fontSize2xl ?? this.fontSize2xl,
      fontSize3xl: fontSize3xl ?? this.fontSize3xl,
      fontSize4xl: fontSize4xl ?? this.fontSize4xl,
      fontSize5xl: fontSize5xl ?? this.fontSize5xl,
      fontSize6xl: fontSize6xl ?? this.fontSize6xl,
      fontWeightLight: fontWeightLight ?? this.fontWeightLight,
      fontWeightRegular: fontWeightRegular ?? this.fontWeightRegular,
      fontWeightMedium: fontWeightMedium ?? this.fontWeightMedium,
      fontWeightSemibold: fontWeightSemibold ?? this.fontWeightSemibold,
      fontWeightBold: fontWeightBold ?? this.fontWeightBold,
      lineHeightTight: lineHeightTight ?? this.lineHeightTight,
      lineHeightNormal: lineHeightNormal ?? this.lineHeightNormal,
      lineHeightRelaxed: lineHeightRelaxed ?? this.lineHeightRelaxed,
      letterSpacingTight: letterSpacingTight ?? this.letterSpacingTight,
      letterSpacingNormal: letterSpacingNormal ?? this.letterSpacingNormal,
      letterSpacingWide: letterSpacingWide ?? this.letterSpacingWide,
      h1Desktop: h1Desktop ?? this.h1Desktop,
      h1Tablet: h1Tablet ?? this.h1Tablet,
      h1Mobile: h1Mobile ?? this.h1Mobile,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      h4: h4 ?? this.h4,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      caption: caption ?? this.caption,
      overline: overline ?? this.overline,
      monospace: monospace ?? this.monospace,
    );
  }

  @override
  ThemeExtension<TypographyTokens> lerp(
    ThemeExtension<TypographyTokens>? other,
    double t,
  ) {
    if (other is! TypographyTokens) return this;

    return TypographyTokens(
      fontFamilyPrimary: fontFamilyPrimary,
      fontFamilyMonospace: fontFamilyMonospace,
      fontSizeXs: fontSizeXs,
      fontSizeSm: fontSizeSm,
      fontSizeBase: fontSizeBase,
      fontSizeMd: fontSizeMd,
      fontSizeLg: fontSizeLg,
      fontSizeXl: fontSizeXl,
      fontSize2xl: fontSize2xl,
      fontSize3xl: fontSize3xl,
      fontSize4xl: fontSize4xl,
      fontSize5xl: fontSize5xl,
      fontSize6xl: fontSize6xl,
      fontWeightLight: fontWeightLight,
      fontWeightRegular: fontWeightRegular,
      fontWeightMedium: fontWeightMedium,
      fontWeightSemibold: fontWeightSemibold,
      fontWeightBold: fontWeightBold,
      lineHeightTight: lineHeightTight,
      lineHeightNormal: lineHeightNormal,
      lineHeightRelaxed: lineHeightRelaxed,
      letterSpacingTight: letterSpacingTight,
      letterSpacingNormal: letterSpacingNormal,
      letterSpacingWide: letterSpacingWide,
      h1Desktop: TextStyle.lerp(h1Desktop, other.h1Desktop, t)!,
      h1Tablet: TextStyle.lerp(h1Tablet, other.h1Tablet, t)!,
      h1Mobile: TextStyle.lerp(h1Mobile, other.h1Mobile, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      h4: TextStyle.lerp(h4, other.h4, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      overline: TextStyle.lerp(overline, other.overline, t)!,
      monospace: TextStyle.lerp(monospace, other.monospace, t)!,
    );
  }
}
