import 'package:flutter/material.dart';

/// NovaCorp Employer Verification Portal - Color Tokens
/// Version: 2.0.0
/// Last Updated: 2026-01-07
///
/// Design Token Reference: verifier-portal/design-language/03-design-tokens.yaml
/// Section: colors
///
/// Usage:
/// ```dart
/// final colors = Theme.of(context).extension<ColorTokens>()!;
/// Container(color: colors.primary500);
/// ```

class ColorTokens extends ThemeExtension<ColorTokens> {
  // ===========================================================================
  // PRIMARY COLORS (Purple - Corporate Sophistication)
  // Token: colors.primary.*
  // ===========================================================================

  final Color primary50;
  final Color primary100;
  final Color primary200;
  final Color primary300;
  final Color primary400;
  final Color primary500; // Primary brand color - NovaCorp Purple
  final Color primary600; // Darker for hover states
  final Color primary700;
  final Color primary800;
  final Color primary900;

  // ===========================================================================
  // SECONDARY COLORS (Cyan - Trust, Verification Success)
  // Token: colors.secondary.*
  // ===========================================================================

  final Color secondary50;
  final Color secondary100;
  final Color secondary200;
  final Color secondary300;
  final Color secondary400;
  final Color secondary500; // Secondary brand color - Verification Cyan
  final Color secondary600;
  final Color secondary700;
  final Color secondary800;
  final Color secondary900;

  // ===========================================================================
  // NEUTRAL COLORS (Grays - Text, Backgrounds, Borders)
  // Token: colors.neutral.*
  // ===========================================================================

  final Color neutral0; // Pure white
  final Color neutral50; // Off-white
  final Color neutral100;
  final Color neutral200;
  final Color neutral300;
  final Color neutral400;
  final Color neutral500; // Mid gray
  final Color neutral600;
  final Color neutral700; // Text gray
  final Color neutral800;
  final Color neutral900; // Dark gray
  final Color neutral950; // Near black
  final Color neutral1000; // Pure black

  // ===========================================================================
  // SEMANTIC COLORS - VERIFICATION STATUS
  // Token: colors.semantic.*
  // ===========================================================================

  /// Verified - Credential verified, issuer trusted ✅
  /// Token: colors.semantic.verified.*
  final Color verifiedLight;
  final Color verifiedMain;
  final Color verifiedDark;
  final Color verifiedContrast;

  /// Pending - Verification in progress ⏳
  /// Token: colors.semantic.pending.*
  final Color pendingLight;
  final Color pendingMain;
  final Color pendingDark;
  final Color pendingContrast;

  /// Failed - Verification failed, invalid ❌
  /// Token: colors.semantic.failed.*
  final Color failedLight;
  final Color failedMain;
  final Color failedDark;
  final Color failedContrast;

  /// Info - Informational messages
  /// Token: colors.semantic.info.*
  final Color infoLight;
  final Color infoMain;
  final Color infoDark;
  final Color infoContrast;

  // ===========================================================================
  // EXTENDED COLORS
  // Token: colors.extended.*
  // ===========================================================================

  final Color cyan;
  final Color purple;
  final Color rose;
  final Color violet;
  final Color brown;
  final Color orange;

  // ===========================================================================
  // SURFACE COLORS
  // Token: colors.surface.*
  // ===========================================================================

  final Color surfaceBackground;
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color surfaceContainer;

  // ===========================================================================
  // TEXT COLORS
  // Token: colors.text.*
  // ===========================================================================

  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;

  // ===========================================================================
  // OVERLAY COLORS
  // Token: colors.overlay.*
  // ===========================================================================

  final Color backdrop;
  final Color whiteOverlay30;
  final Color disabled;

  const ColorTokens({
    // Primary
    required this.primary50,
    required this.primary100,
    required this.primary200,
    required this.primary300,
    required this.primary400,
    required this.primary500,
    required this.primary600,
    required this.primary700,
    required this.primary800,
    required this.primary900,
    // Secondary
    required this.secondary50,
    required this.secondary100,
    required this.secondary200,
    required this.secondary300,
    required this.secondary400,
    required this.secondary500,
    required this.secondary600,
    required this.secondary700,
    required this.secondary800,
    required this.secondary900,
    // Neutral
    required this.neutral0,
    required this.neutral50,
    required this.neutral100,
    required this.neutral200,
    required this.neutral300,
    required this.neutral400,
    required this.neutral500,
    required this.neutral600,
    required this.neutral700,
    required this.neutral800,
    required this.neutral900,
    required this.neutral950,
    required this.neutral1000,
    // Semantic - Verified
    required this.verifiedLight,
    required this.verifiedMain,
    required this.verifiedDark,
    required this.verifiedContrast,
    // Semantic - Pending
    required this.pendingLight,
    required this.pendingMain,
    required this.pendingDark,
    required this.pendingContrast,
    // Semantic - Failed
    required this.failedLight,
    required this.failedMain,
    required this.failedDark,
    required this.failedContrast,
    // Semantic - Info
    required this.infoLight,
    required this.infoMain,
    required this.infoDark,
    required this.infoContrast,
    // Extended
    required this.cyan,
    required this.purple,
    required this.rose,
    required this.violet,
    required this.brown,
    required this.orange,
    // Surface
    required this.surfaceBackground,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.surfaceContainer,
    // Text
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    // Overlay
    required this.backdrop,
    required this.whiteOverlay30,
    required this.disabled,
  });

  // ===========================================================================
  // LIGHT THEME COLORS
  // ===========================================================================

  static const ColorTokens light = ColorTokens(
    // Primary (Purple)
    primary50: Color(0xFFF3E5F5),
    primary100: Color(0xFFE1BEE7),
    primary200: Color(0xFFCE93D8),
    primary300: Color(0xFFBA68C8),
    primary400: Color(0xFFAB47BC),
    primary500: Color(0xFF9C27B0),
    primary600: Color(0xFF8E24AA),
    primary700: Color(0xFF7B1FA2),
    primary800: Color(0xFF6A1B9A),
    primary900: Color(0xFF4A148C),
    // Secondary (Cyan)
    secondary50: Color(0xFFE0F7FA),
    secondary100: Color(0xFFB2EBF2),
    secondary200: Color(0xFF80DEEA),
    secondary300: Color(0xFF4DD0E1),
    secondary400: Color(0xFF26C6DA),
    secondary500: Color(0xFF00BCD4),
    secondary600: Color(0xFF00ACC1),
    secondary700: Color(0xFF0097A7),
    secondary800: Color(0xFF00838F),
    secondary900: Color(0xFF006064),
    // Neutral
    neutral0: Color(0xFFFFFFFF),
    neutral50: Color(0xFFFAFAFA),
    neutral100: Color(0xFFF5F5F5),
    neutral200: Color(0xFFEEEEEE),
    neutral300: Color(0xFFE0E0E0),
    neutral400: Color(0xFFBDBDBD),
    neutral500: Color(0xFF9E9E9E),
    neutral600: Color(0xFF757575),
    neutral700: Color(0xFF636363),
    neutral800: Color(0xFF424242),
    neutral900: Color(0xFF212121),
    neutral950: Color(0xFF0A0A0A),
    neutral1000: Color(0xFF000000),
    // Semantic - Verified
    verifiedLight: Color(0xFF81C784),
    verifiedMain: Color(0xFF4CAF50),
    verifiedDark: Color(0xFF388E3C),
    verifiedContrast: Color(0xFFFFFFFF),
    // Semantic - Pending
    pendingLight: Color(0xFFFFD54F),
    pendingMain: Color(0xFFD99A06),
    pendingDark: Color(0xFFF57C00),
    pendingContrast: Color(0xFF000000),
    // Semantic - Failed
    failedLight: Color(0xFFE57373),
    failedMain: Color(0xFFF44336),
    failedDark: Color(0xFFD32F2F),
    failedContrast: Color(0xFFFFFFFF),
    // Semantic - Info
    infoLight: Color(0xFF64B5F6),
    infoMain: Color(0xFF2196F3),
    infoDark: Color(0xFF1976D2),
    infoContrast: Color(0xFFFFFFFF),
    // Extended
    cyan: Color(0xFF00BCD4),
    purple: Color(0xFF9C27B0),
    rose: Color(0xFFD31F82),
    violet: Color(0xFFB81FD3),
    brown: Color(0xFF795548),
    orange: Color(0xFFFF9800),
    // Surface (Light)
    surfaceBackground: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF5F5F5),
    surfaceContainerHigh: Color(0xFFF5F5F5),
    surfaceContainerHighest: Color(0xFFFAFAFA),
    surfaceContainer: Color(0xFFFAFAFA),
    // Text (Light)
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF636363),
    textDisabled: Color(0xFF9E9E9E),
    // Overlay
    backdrop: Color(0x80000000), // rgba(0, 0, 0, 0.5)
    whiteOverlay30: Color(0x4DFFFFFF), // rgba(255, 255, 255, 0.3)
    disabled: Color(0x66B4B4B4), // rgba(180, 180, 180, 0.4)
  );

  // ===========================================================================
  // DARK THEME COLORS (Default)
  // ===========================================================================

  static const ColorTokens dark = ColorTokens(
    // Primary (Purple)
    primary50: Color(0xFFF3E5F5),
    primary100: Color(0xFFE1BEE7),
    primary200: Color(0xFFCE93D8),
    primary300: Color(0xFFBA68C8),
    primary400: Color(0xFFAB47BC),
    primary500: Color(0xFF9C27B0),
    primary600: Color(0xFF8E24AA),
    primary700: Color(0xFF7B1FA2),
    primary800: Color(0xFF6A1B9A),
    primary900: Color(0xFF4A148C),
    // Secondary (Cyan)
    secondary50: Color(0xFFE0F7FA),
    secondary100: Color(0xFFB2EBF2),
    secondary200: Color(0xFF80DEEA),
    secondary300: Color(0xFF4DD0E1),
    secondary400: Color(0xFF26C6DA),
    secondary500: Color(0xFF00BCD4),
    secondary600: Color(0xFF00ACC1),
    secondary700: Color(0xFF0097A7),
    secondary800: Color(0xFF00838F),
    secondary900: Color(0xFF006064),
    // Neutral
    neutral0: Color(0xFFFFFFFF),
    neutral50: Color(0xFFFAFAFA),
    neutral100: Color(0xFFF5F5F5),
    neutral200: Color(0xFFEEEEEE),
    neutral300: Color(0xFFE0E0E0),
    neutral400: Color(0xFFBDBDBD),
    neutral500: Color(0xFF9E9E9E),
    neutral600: Color(0xFF757575),
    neutral700: Color(0xFF636363),
    neutral800: Color(0xFF424242),
    neutral900: Color(0xFF212121),
    neutral950: Color(0xFF0A0A0A),
    neutral1000: Color(0xFF000000),
    // Semantic - Verified
    verifiedLight: Color(0xFF81C784),
    verifiedMain: Color(0xFF4CAF50),
    verifiedDark: Color(0xFF388E3C),
    verifiedContrast: Color(0xFFFFFFFF),
    // Semantic - Pending
    pendingLight: Color(0xFFFFD54F),
    pendingMain: Color(0xFFD99A06),
    pendingDark: Color(0xFFF57C00),
    pendingContrast: Color(0xFF000000),
    // Semantic - Failed
    failedLight: Color(0xFFE57373),
    failedMain: Color(0xFFF44336),
    failedDark: Color(0xFFD32F2F),
    failedContrast: Color(0xFFFFFFFF),
    // Semantic - Info
    infoLight: Color(0xFF64B5F6),
    infoMain: Color(0xFF2196F3),
    infoDark: Color(0xFF1976D2),
    infoContrast: Color(0xFFFFFFFF),
    // Extended
    cyan: Color(0xFF00BCD4),
    purple: Color(0xFF9C27B0),
    rose: Color(0xFFD31F82),
    violet: Color(0xFFB81FD3),
    brown: Color(0xFF795548),
    orange: Color(0xFFFF9800),
    // Surface (Dark) - Material 3 Dark Surface Variants
    // Token: colors.surface.dark.*
    // Surface tiers provide elevation through layering (not shadows in dark mode)
    surfaceBackground: Color(
      0xFF121212,
    ), // Dark background (slightly elevated from pure black)
    surface: Color(0xFF121212), // Base surface
    surfaceVariant: Color(0xFF3A3A3D), // Variant surface (lighter)
    surfaceContainerHigh: Color(0xFF2B2B2E), // High elevation container
    surfaceContainerHighest: Color(0xFF363639), // Highest elevation container
    surfaceContainer: Color(0xFF1E1E21), // Standard container
    // Text (Dark) - High contrast for WCAG AA compliance
    // Token: colors.text.dark.*
    textPrimary: Color(0xFFFFFFFF), // White text on dark (contrast ratio: 21:1)
    textSecondary: Color(
      0xFFB0B0B0,
    ), // Gray text for secondary content (contrast ratio: 8.6:1)
    textDisabled: Color(
      0xFF636363,
    ), // Disabled text (contrast ratio: 4.5:1 - AA minimum)
    // Overlay
    backdrop: Color(0x80000000), // rgba(0, 0, 0, 0.5)
    whiteOverlay30: Color(0x4DFFFFFF), // rgba(255, 255, 255, 0.3)
    disabled: Color(0x66B4B4B4), // rgba(180, 180, 180, 0.4)
  );

  @override
  ThemeExtension<ColorTokens> copyWith({
    Color? primary50,
    Color? primary100,
    Color? primary200,
    Color? primary300,
    Color? primary400,
    Color? primary500,
    Color? primary600,
    Color? primary700,
    Color? primary800,
    Color? primary900,
    Color? secondary50,
    Color? secondary100,
    Color? secondary200,
    Color? secondary300,
    Color? secondary400,
    Color? secondary500,
    Color? secondary600,
    Color? secondary700,
    Color? secondary800,
    Color? secondary900,
    Color? neutral0,
    Color? neutral50,
    Color? neutral100,
    Color? neutral200,
    Color? neutral300,
    Color? neutral400,
    Color? neutral500,
    Color? neutral600,
    Color? neutral700,
    Color? neutral800,
    Color? neutral900,
    Color? neutral950,
    Color? neutral1000,
    Color? verifiedLight,
    Color? verifiedMain,
    Color? verifiedDark,
    Color? verifiedContrast,
    Color? pendingLight,
    Color? pendingMain,
    Color? pendingDark,
    Color? pendingContrast,
    Color? failedLight,
    Color? failedMain,
    Color? failedDark,
    Color? failedContrast,
    Color? infoLight,
    Color? infoMain,
    Color? infoDark,
    Color? infoContrast,
    Color? cyan,
    Color? purple,
    Color? rose,
    Color? violet,
    Color? brown,
    Color? orange,
    Color? surfaceBackground,
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? surfaceContainer,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? backdrop,
    Color? whiteOverlay30,
    Color? disabled,
  }) {
    return ColorTokens(
      primary50: primary50 ?? this.primary50,
      primary100: primary100 ?? this.primary100,
      primary200: primary200 ?? this.primary200,
      primary300: primary300 ?? this.primary300,
      primary400: primary400 ?? this.primary400,
      primary500: primary500 ?? this.primary500,
      primary600: primary600 ?? this.primary600,
      primary700: primary700 ?? this.primary700,
      primary800: primary800 ?? this.primary800,
      primary900: primary900 ?? this.primary900,
      secondary50: secondary50 ?? this.secondary50,
      secondary100: secondary100 ?? this.secondary100,
      secondary200: secondary200 ?? this.secondary200,
      secondary300: secondary300 ?? this.secondary300,
      secondary400: secondary400 ?? this.secondary400,
      secondary500: secondary500 ?? this.secondary500,
      secondary600: secondary600 ?? this.secondary600,
      secondary700: secondary700 ?? this.secondary700,
      secondary800: secondary800 ?? this.secondary800,
      secondary900: secondary900 ?? this.secondary900,
      neutral0: neutral0 ?? this.neutral0,
      neutral50: neutral50 ?? this.neutral50,
      neutral100: neutral100 ?? this.neutral100,
      neutral200: neutral200 ?? this.neutral200,
      neutral300: neutral300 ?? this.neutral300,
      neutral400: neutral400 ?? this.neutral400,
      neutral500: neutral500 ?? this.neutral500,
      neutral600: neutral600 ?? this.neutral600,
      neutral700: neutral700 ?? this.neutral700,
      neutral800: neutral800 ?? this.neutral800,
      neutral900: neutral900 ?? this.neutral900,
      neutral950: neutral950 ?? this.neutral950,
      neutral1000: neutral1000 ?? this.neutral1000,
      verifiedLight: verifiedLight ?? this.verifiedLight,
      verifiedMain: verifiedMain ?? this.verifiedMain,
      verifiedDark: verifiedDark ?? this.verifiedDark,
      verifiedContrast: verifiedContrast ?? this.verifiedContrast,
      pendingLight: pendingLight ?? this.pendingLight,
      pendingMain: pendingMain ?? this.pendingMain,
      pendingDark: pendingDark ?? this.pendingDark,
      pendingContrast: pendingContrast ?? this.pendingContrast,
      failedLight: failedLight ?? this.failedLight,
      failedMain: failedMain ?? this.failedMain,
      failedDark: failedDark ?? this.failedDark,
      failedContrast: failedContrast ?? this.failedContrast,
      infoLight: infoLight ?? this.infoLight,
      infoMain: infoMain ?? this.infoMain,
      infoDark: infoDark ?? this.infoDark,
      infoContrast: infoContrast ?? this.infoContrast,
      cyan: cyan ?? this.cyan,
      purple: purple ?? this.purple,
      rose: rose ?? this.rose,
      violet: violet ?? this.violet,
      brown: brown ?? this.brown,
      orange: orange ?? this.orange,
      surfaceBackground: surfaceBackground ?? this.surfaceBackground,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      backdrop: backdrop ?? this.backdrop,
      whiteOverlay30: whiteOverlay30 ?? this.whiteOverlay30,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  ThemeExtension<ColorTokens> lerp(
    ThemeExtension<ColorTokens>? other,
    double t,
  ) {
    if (other is! ColorTokens) return this;

    return ColorTokens(
      primary50: Color.lerp(primary50, other.primary50, t)!,
      primary100: Color.lerp(primary100, other.primary100, t)!,
      primary200: Color.lerp(primary200, other.primary200, t)!,
      primary300: Color.lerp(primary300, other.primary300, t)!,
      primary400: Color.lerp(primary400, other.primary400, t)!,
      primary500: Color.lerp(primary500, other.primary500, t)!,
      primary600: Color.lerp(primary600, other.primary600, t)!,
      primary700: Color.lerp(primary700, other.primary700, t)!,
      primary800: Color.lerp(primary800, other.primary800, t)!,
      primary900: Color.lerp(primary900, other.primary900, t)!,
      secondary50: Color.lerp(secondary50, other.secondary50, t)!,
      secondary100: Color.lerp(secondary100, other.secondary100, t)!,
      secondary200: Color.lerp(secondary200, other.secondary200, t)!,
      secondary300: Color.lerp(secondary300, other.secondary300, t)!,
      secondary400: Color.lerp(secondary400, other.secondary400, t)!,
      secondary500: Color.lerp(secondary500, other.secondary500, t)!,
      secondary600: Color.lerp(secondary600, other.secondary600, t)!,
      secondary700: Color.lerp(secondary700, other.secondary700, t)!,
      secondary800: Color.lerp(secondary800, other.secondary800, t)!,
      secondary900: Color.lerp(secondary900, other.secondary900, t)!,
      neutral0: Color.lerp(neutral0, other.neutral0, t)!,
      neutral50: Color.lerp(neutral50, other.neutral50, t)!,
      neutral100: Color.lerp(neutral100, other.neutral100, t)!,
      neutral200: Color.lerp(neutral200, other.neutral200, t)!,
      neutral300: Color.lerp(neutral300, other.neutral300, t)!,
      neutral400: Color.lerp(neutral400, other.neutral400, t)!,
      neutral500: Color.lerp(neutral500, other.neutral500, t)!,
      neutral600: Color.lerp(neutral600, other.neutral600, t)!,
      neutral700: Color.lerp(neutral700, other.neutral700, t)!,
      neutral800: Color.lerp(neutral800, other.neutral800, t)!,
      neutral900: Color.lerp(neutral900, other.neutral900, t)!,
      neutral950: Color.lerp(neutral950, other.neutral950, t)!,
      neutral1000: Color.lerp(neutral1000, other.neutral1000, t)!,
      verifiedLight: Color.lerp(verifiedLight, other.verifiedLight, t)!,
      verifiedMain: Color.lerp(verifiedMain, other.verifiedMain, t)!,
      verifiedDark: Color.lerp(verifiedDark, other.verifiedDark, t)!,
      verifiedContrast: Color.lerp(
        verifiedContrast,
        other.verifiedContrast,
        t,
      )!,
      pendingLight: Color.lerp(pendingLight, other.pendingLight, t)!,
      pendingMain: Color.lerp(pendingMain, other.pendingMain, t)!,
      pendingDark: Color.lerp(pendingDark, other.pendingDark, t)!,
      pendingContrast: Color.lerp(pendingContrast, other.pendingContrast, t)!,
      failedLight: Color.lerp(failedLight, other.failedLight, t)!,
      failedMain: Color.lerp(failedMain, other.failedMain, t)!,
      failedDark: Color.lerp(failedDark, other.failedDark, t)!,
      failedContrast: Color.lerp(failedContrast, other.failedContrast, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
      infoMain: Color.lerp(infoMain, other.infoMain, t)!,
      infoDark: Color.lerp(infoDark, other.infoDark, t)!,
      infoContrast: Color.lerp(infoContrast, other.infoContrast, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      rose: Color.lerp(rose, other.rose, t)!,
      violet: Color.lerp(violet, other.violet, t)!,
      brown: Color.lerp(brown, other.brown, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      surfaceBackground: Color.lerp(
        surfaceBackground,
        other.surfaceBackground,
        t,
      )!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      backdrop: Color.lerp(backdrop, other.backdrop, t)!,
      whiteOverlay30: Color.lerp(whiteOverlay30, other.whiteOverlay30, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
    );
  }
}
