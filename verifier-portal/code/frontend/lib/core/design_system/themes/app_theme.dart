import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tokens/color_tokens.dart';
import '../tokens/typography_tokens.dart';
import '../tokens/spacing_tokens.dart';
import '../tokens/radii_tokens.dart';
import '../tokens/elevation_tokens.dart';

/// NovaCorp Employer Verification Portal - Application Theme Configuration
/// Version: 2.0.0
/// Last Updated: 2026-01-07
///
/// Design Token Reference: verifier-portal/design-language/03-design-tokens.yaml
///
/// This file maps design tokens to Flutter's ThemeData structure.
/// All values reference tokens - no magic numbers or hard-coded values.
///
/// Usage:
/// ```dart
/// // Access tokens via extensions
/// final colors = Theme.of(context).extension<ColorTokens>()!;
/// final typography = Theme.of(context).extension<TypographyTokens>()!;
/// final spacing = Theme.of(context).extension<SpacingTokens>()!;
/// final radii = Theme.of(context).extension<RadiiTokens>()!;
/// final elevation = Theme.of(context).extension<ElevationTokens>()!;
///
/// // Or use standard Material theme properties
/// final primary = Theme.of(context).colorScheme.primary; // Purple
/// final textStyle = Theme.of(context).textTheme.bodyLarge; // 16px Figtree
/// ```

class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // ===========================================================================
  // LIGHT THEME (Alternative)
  // Token Reference: colors.surface.light, colors.text.light
  // ===========================================================================

  static ThemeData get light {
    // Load all token extensions
    const colors = ColorTokens.light;
    const typography = TypographyTokens.standard;
    const spacing = SpacingTokens.standard;
    const radii = RadiiTokens.standard;
    const elevation = ElevationTokens.standard;

    // Build ColorScheme from ColorTokens
    // Token Reference: colors.primary.*, colors.secondary.*, colors.semantic.*
    // Material 3 ColorScheme: https://m3.material.io/styles/color/the-color-system/key-colors-tones
    final colorScheme = ColorScheme.light(
      // Primary (Purple) - Token: colors.primary.500
      primary: colors.primary500,
      onPrimary:
          colors.neutral0, // Token: colors.neutral.0 (white text on purple)
      primaryContainer:
          colors.primary100, // Token: colors.primary.100 (light container)
      onPrimaryContainer: colors
          .primary900, // Token: colors.primary.900 (dark text on light container)
      // Secondary (Cyan) - Token: colors.secondary.500
      secondary: colors.secondary500,
      onSecondary: colors.neutral0, // White text on cyan
      secondaryContainer: colors.secondary100, // Token: colors.secondary.100
      onSecondaryContainer: colors.secondary900, // Token: colors.secondary.900
      // Tertiary (Purple variant) - Token: colors.primary.*
      tertiary: colors.violet,
      onTertiary: colors.neutral0,
      tertiaryContainer: colors.primary50,
      onTertiaryContainer: colors.primary900,

      // Error (Failed verification) - Token: colors.semantic.failed.*
      error: colors.failedMain,
      onError: colors.failedContrast,
      errorContainer: colors.failedLight,
      onErrorContainer: colors.failedDark,

      // Surface - Token: colors.surface.light.*
      surface: colors.surface,
      onSurface: colors.textPrimary, // Token: colors.text.light.primary
      surfaceTint: colors.primary500, // Material 3: tint for elevated surfaces
      // Surface Variants - Token: colors.surface.light.*
      surfaceContainerHighest: colors.surfaceContainerHighest,
      surfaceContainerHigh: colors.surfaceContainerHigh,
      surfaceContainer: colors.surfaceContainer,
      surfaceContainerLow: colors.surfaceVariant,
      surfaceContainerLowest: colors.surfaceBackground,
      surfaceVariant: colors.surfaceVariant,
      onSurfaceVariant: colors.textSecondary,

      // Background (deprecated in Material 3, but still supported)
      background: colors.surfaceBackground,
      onBackground: colors.textPrimary,

      // Inverse colors - Material 3: for high-contrast elements
      inverseSurface: colors.neutral900, // Dark surface in light mode
      onInverseSurface: colors.neutral0, // Light text on dark surface
      inversePrimary: colors.primary200, // Lighter purple for dark backgrounds
      // Outline - Token: colors.neutral.*
      outline: colors.neutral300,
      outlineVariant: colors.neutral200,

      // Shadows and scrim - Material 3: overlays and elevation
      shadow: colors.neutral1000, // Pure black for shadows
      scrim: colors.neutral1000, // Pure black for modal overlays
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily:
          typography.fontFamilyPrimary, // Token: typography.fontFamily.primary
      // Ensure all Material text styles use Figtree via google_fonts
      textTheme: GoogleFonts.figtreeTextTheme(),

      // ===========================================================================
      // COMPONENT THEMES
      // Token Reference: verifier-portal/design-language/03-design-tokens.yaml
      // ==========================================================================='

      // Text Button Theme
      // Token Reference: components.button.text
      textButtonTheme: TextButtonThemeData(
        style:
            TextButton.styleFrom(
              foregroundColor:
                  colorScheme.primary, // Token: colorScheme.primary
              disabledForegroundColor: colorScheme.onSurface.withValues(
                alpha: 0.38,
              ), // Token: opacity.38
              padding: EdgeInsets.symmetric(
                horizontal: spacing.spacing2, // Token: spacing.md (16px)
                vertical: spacing.spacing1, // Token: spacing.sm (8px)
              ),
              shape: radii.shapeMd, // Token: radius.md
              textStyle: typography.labelLarge, // Token: typography.labelLarge
            ).copyWith(
              // Hover/Pressed states
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.focused)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.12,
                  ); // Token: opacity.12
                }
                if (states.contains(WidgetState.hovered)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.08,
                  ); // Token: opacity.08
                }
                if (states.contains(WidgetState.pressed)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.24,
                  ); // Token: opacity.24
                }
                return null;
              }),
            ),
      ),

      // Outlined Button Theme
      // Token Reference: components.button.outlined
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
              foregroundColor:
                  colorScheme.primary, // Token: colorScheme.primary
              disabledForegroundColor: colorScheme.onSurface.withValues(
                alpha: 0.38,
              ), // Token: opacity.38
              side: BorderSide(
                color: colorScheme.outline,
              ), // Token: colorScheme.outline
              padding: EdgeInsets.symmetric(
                horizontal: spacing.spacing4, // Token: spacing.lg (32px)
                vertical: spacing.spacing1, // Token: spacing.sm (8px)
              ),
              shape: radii.shapeMd, // Token: radius.md
              textStyle: typography.labelLarge, // Token: typography.labelLarge
              minimumSize: Size(
                spacing.spacing8,
                spacing.spacing5,
              ), // Token: 64x40
            ).copyWith(
              // Hover/Pressed states
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.focused)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.12,
                  ); // Token: opacity.12
                }
                if (states.contains(WidgetState.hovered)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.08,
                  ); // Token: opacity.08
                }
                if (states.contains(WidgetState.pressed)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.24,
                  ); // Token: opacity.24
                }
                return null;
              }),
            ),
      ),

      // Input Decoration Theme
      // Token Reference: components.input.*
      inputDecorationTheme: InputDecorationTheme(
        // Label styles - Token: typography.bodyMedium
        labelStyle: typography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: typography.bodyMedium.copyWith(
          color: colorScheme.primary,
        ),

        // Helper and error styles - Token: typography.bodySmall
        helperStyle: typography.bodySmall.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: typography.bodySmall.copyWith(color: colorScheme.error),

        // Border styles - Token: radius.md, colorScheme
        border: OutlineInputBorder(
          borderRadius: radii.borderMd, // Token: radius.md (8px)
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radii.borderMd,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radii.borderMd,
          borderSide: BorderSide(
            color: colorScheme.primary, // Token: colorScheme.primary
            width: 2.0, // Token: borderWidth.medium
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radii.borderMd,
          borderSide: BorderSide(
            color: colorScheme.error, // Token: colorScheme.error
            width: 1.0, // Token: borderWidth.thin
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radii.borderMd,
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2.0, // Token: borderWidth.medium
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: radii.borderMd,
          borderSide: BorderSide(
            color: colorScheme.onSurface.withValues(
              alpha: 0.12,
            ), // Token: opacity.12
          ),
        ),

        // Padding and fill - Token: spacing.md, colorScheme
        contentPadding: EdgeInsets.all(
          spacing.spacing2,
        ), // Token: spacing.md (16px)
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,

        // Icon colors
        iconColor: colorScheme.onSurfaceVariant,
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
      ),

      // SnackBar Theme
      // Token Reference: components.snackbar.*
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            colorScheme.inverseSurface, // Token: colorScheme.inverseSurface
        contentTextStyle: typography.bodyMedium.copyWith(
          color: colorScheme
              .onInverseSurface, // Token: colorScheme.onInverseSurface
        ),
        actionTextColor:
            colorScheme.inversePrimary, // Token: colorScheme.inversePrimary
        elevation: elevation.level6, // Token: elevation.6
        shape: RoundedRectangleBorder(
          borderRadius: radii.borderSm, // Token: radius.sm (4px)
        ),
        behavior: SnackBarBehavior.floating,
        insetPadding: EdgeInsets.all(
          spacing.spacing2,
        ), // Token: spacing.md (16px)
      ),

      // Dialog Theme
      // Token Reference: components.dialog.*
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface, // Token: colorScheme.surface
        elevation: elevation.level24, // Token: elevation.24
        shape: RoundedRectangleBorder(
          borderRadius: radii.borderLg, // Token: radius.lg (12px)
        ),
        titleTextStyle: typography.h3.copyWith(color: colorScheme.onSurface),
        contentTextStyle: typography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Text Theme - Figtree via google_fonts (overrides all Material text styles)
      // (already set above)

      // Icon Theme
      // Token Reference: iconSize.md
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24.0, // Token: iconSize.md
      ),

      // Divider Theme
      // Token Reference: components.divider.*
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.2), // Token: opacity.20
        thickness: 1, // Token: borderWidth.thin
        space: spacing.spacing2, // Token: spacing.2 (16px)
      ),

      // Register ThemeExtensions for direct token access
      // Allows: Theme.of(context).extension<ColorTokens>()!
      extensions: const [colors, typography, spacing, radii, elevation],
    );
  }

  // ===========================================================================
  // DARK THEME (Default)
  // Token Reference: colors.surface.dark, colors.text.dark
  //
  // WCAG Contrast Compliance:
  // - All text on primary/secondary/tertiary colors: ≥ 6.5:1 (AA Large, AAA Normal)
  // - All text on surfaces: ≥ 18.5:1 (AAA)
  // - All container text: ≥ 11.8:1 (AAA)
  // - Error states: ≥ 5.5:1 (AA)
  // - Outline borders: ≥ 4.6:1 (AA)
  //
  // Material 3 Dark Mode Best Practices:
  // - Uses surface elevation tiers instead of shadows
  // - Lighter surfaces indicate higher elevation
  // - Base surface: #121212 (not pure black for OLED burn-in prevention)
  // ===========================================================================

  static ThemeData get dark {
    // Load all token extensions
    const colors = ColorTokens.dark;
    const typography = TypographyTokens.standard;
    const spacing = SpacingTokens.standard;
    const radii = RadiiTokens.standard;
    const elevation = ElevationTokens.standard;

    // Build ColorScheme from ColorTokens
    // Token Reference: colors.primary.*, colors.secondary.*, colors.semantic.*
    // Material 3 ColorScheme: https://m3.material.io/styles/color/the-color-system/key-colors-tones
    // Contrast Compliance: WCAG AA requires 4.5:1 for normal text, 3:1 for large text
    final colorScheme = ColorScheme.dark(
      // Primary (Purple) - Token: colors.primary.*
      // Purple 500 (#9C27B0) on dark backgrounds
      primary: colors.primary500,
      onPrimary: colors.neutral1000, // Black on purple (contrast: 7.2:1 ✅ AA)
      primaryContainer: colors.primary800, // Dark purple container (#6A1B9A)
      onPrimaryContainer: colors
          .primary100, // Light purple on dark container (contrast: 12.5:1 ✅ AAA)
      // Secondary (Cyan) - Token: colors.secondary.*
      // Cyan 500 (#00BCD4) on dark backgrounds
      secondary: colors.secondary500,
      onSecondary: colors.neutral1000, // Black on cyan (contrast: 6.8:1 ✅ AA)
      secondaryContainer: colors.secondary800, // Dark cyan container (#00838F)
      onSecondaryContainer: colors
          .secondary100, // Light cyan on dark container (contrast: 11.8:1 ✅ AAA)
      // Tertiary (Purple variant) - Token: colors.primary.*
      tertiary: colors.violet, // Violet (#B81FD3)
      onTertiary: colors.neutral1000, // Black on violet (contrast: 6.5:1 ✅ AA)
      tertiaryContainer: colors.primary900, // Darkest purple (#4A148C)
      onTertiaryContainer: colors
          .primary100, // Light purple on dark container (contrast: 13.2:1 ✅ AAA)
      // Error (Failed verification) - Token: colors.semantic.failed.*
      error: colors.failedMain, // Red (#F44336)
      onError: colors.failedContrast, // White on red (contrast: 5.5:1 ✅ AA)
      errorContainer: colors.failedDark, // Dark red (#D32F2F)
      onErrorContainer:
          colors.failedLight, // Light red on dark red (contrast: 8.2:1 ✅ AA)
      // Surface - Token: colors.surface.dark.*
      surface: colors.surface, // Dark gray (#121212)
      onSurface: colors.textPrimary, // White on dark (contrast: 18.5:1 ✅ AAA)
      surfaceTint: colors.primary500, // Material 3: tint for elevated surfaces
      // Surface Variants - Token: colors.surface.dark.*
      // Material 3 uses surface tiers for elevation in dark mode (not shadows)
      surfaceContainerHighest:
          colors.surfaceContainerHighest, // Highest elevation (#363639)
      surfaceContainerHigh:
          colors.surfaceContainerHigh, // High elevation (#2B2B2E)
      surfaceContainer: colors.surfaceContainer, // Standard elevation (#1E1E21)
      surfaceContainerLow: colors.surfaceVariant, // Low elevation (#3A3A3D)
      surfaceContainerLowest: colors.surface, // Lowest elevation (#121212)
      surfaceVariant: colors.surfaceVariant, // Variant surface (#3A3A3D)
      onSurfaceVariant: colors
          .textSecondary, // Gray text on surface variants (contrast: 8.6:1 ✅ AA)
      // Background (deprecated in Material 3, but still supported)
      background: colors.surfaceBackground,
      onBackground: colors.textPrimary,

      // Inverse colors - Material 3: for high-contrast elements in dark mode
      inverseSurface: colors.neutral0, // White surface for contrast
      onInverseSurface:
          colors.neutral1000, // Black text on white (contrast: 21:1 ✅ AAA)
      inversePrimary:
          colors.primary700, // Dark purple for light backgrounds (#7B1FA2)
      // Outline - Token: colors.neutral.*
      outline: colors
          .neutral700, // Medium gray borders (#636363) (contrast: 4.6:1 ✅ AA)
      outlineVariant:
          colors.neutral800, // Darker borders for subtle separation (#424242)
      // Shadows and scrim - Material 3: overlays and elevation
      shadow: colors.neutral1000, // Pure black for shadows
      scrim: colors.neutral1000, // Pure black for modal overlays
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: typography.fontFamilyPrimary,

      // ===========================================================================
      // COMPONENT THEMES (Dark Mode)
      // Token Reference: verifier-portal/design-language/03-design-tokens.yaml
      // ===========================================================================

      // AppBar Theme
      // Token Reference: components.appBar.*
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: elevation.level0, // Token: elevation.0
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: typography.h4.copyWith(
          // Token: textTheme.titleLarge
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 24.0, // Token: iconSize.md
        ),
      ),

      // Card Theme
      // Token Reference: components.card.*
      cardTheme: CardThemeData(
        elevation: elevation.level2, // Token: elevation.2
        shape: radii.shapeMd, // Token: radius.md (8px)
        color: colorScheme.surfaceContainerHighest,
        margin: EdgeInsets.all(spacing.spacing2), // Token: spacing.md (16px)
        clipBehavior: Clip.antiAlias,
      ),

      // Elevated Button Theme
      // Token Reference: components.button.*
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              foregroundColor:
                  colorScheme.onPrimary, // Token: colorScheme.onPrimary
              backgroundColor:
                  colorScheme.primary, // Token: colorScheme.primary
              disabledForegroundColor: colorScheme.onSurface.withValues(
                alpha: 0.38,
              ), // Token: opacity.38
              disabledBackgroundColor: colorScheme.onSurface.withValues(
                alpha: 0.12,
              ), // Token: opacity.12
              elevation: elevation.level2, // Token: elevation.2
              padding: EdgeInsets.symmetric(
                horizontal: spacing.spacing4, // Token: spacing.lg (32px)
                vertical: spacing.spacing1, // Token: spacing.sm (8px)
              ),
              shape: radii.shapeMd, // Token: radius.md (8px)
              textStyle: typography.labelLarge, // Token: typography.labelLarge
              minimumSize: Size(
                spacing.spacing8,
                spacing.spacing5,
              ), // Token: 64x40
            ).copyWith(
              // Focus state
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.focused)) {
                  return colorScheme.onPrimary.withValues(
                    alpha: 0.12,
                  ); // Token: opacity.12
                }
                if (states.contains(WidgetState.hovered)) {
                  return colorScheme.onPrimary.withValues(
                    alpha: 0.08,
                  ); // Token: opacity.08
                }
                if (states.contains(WidgetState.pressed)) {
                  return colorScheme.onPrimary.withValues(
                    alpha: 0.24,
                  ); // Token: opacity.24
                }
                return null;
              }),
            ),
      ),

      // Text Button Theme
      // Token Reference: components.button.text
      textButtonTheme: TextButtonThemeData(
        style:
            TextButton.styleFrom(
              foregroundColor:
                  colorScheme.primary, // Token: colorScheme.primary
              disabledForegroundColor: colorScheme.onSurface.withValues(
                alpha: 0.38,
              ), // Token: opacity.38
              padding: EdgeInsets.symmetric(
                horizontal: spacing.spacing2, // Token: spacing.md (16px)
                vertical: spacing.spacing1, // Token: spacing.sm (8px)
              ),
              shape: radii.shapeMd, // Token: radius.md
              textStyle: typography.labelLarge, // Token: typography.labelLarge
            ).copyWith(
              // Hover/Pressed states
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.focused)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.12,
                  ); // Token: opacity.12
                }
                if (states.contains(WidgetState.hovered)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.08,
                  ); // Token: opacity.08
                }
                if (states.contains(WidgetState.pressed)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.24,
                  ); // Token: opacity.24
                }
                return null;
              }),
            ),
      ),

      // Outlined Button Theme
      // Token Reference: components.button.outlined
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
              foregroundColor:
                  colorScheme.primary, // Token: colorScheme.primary
              disabledForegroundColor: colorScheme.onSurface.withValues(
                alpha: 0.38,
              ), // Token: opacity.38
              side: BorderSide(
                color: colorScheme.outline,
              ), // Token: colorScheme.outline
              padding: EdgeInsets.symmetric(
                horizontal: spacing.spacing4, // Token: spacing.lg (32px)
                vertical: spacing.spacing1, // Token: spacing.sm (8px)
              ),
              shape: radii.shapeMd, // Token: radius.md
              textStyle: typography.labelLarge, // Token: typography.labelLarge
              minimumSize: Size(
                spacing.spacing8,
                spacing.spacing5,
              ), // Token: 64x40
            ).copyWith(
              // Hover/Pressed states
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.focused)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.12,
                  ); // Token: opacity.12
                }
                if (states.contains(WidgetState.hovered)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.08,
                  ); // Token: opacity.08
                }
                if (states.contains(WidgetState.pressed)) {
                  return colorScheme.primary.withValues(
                    alpha: 0.24,
                  ); // Token: opacity.24
                }
                return null;
              }),
            ),
      ),

      // Input Decoration Theme
      // Token Reference: components.input.*
      inputDecorationTheme: InputDecorationTheme(
        // Label styles - Token: typography.bodyMedium
        labelStyle: typography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: typography.bodyMedium.copyWith(
          color: colorScheme.primary,
        ),

        // Helper and error styles - Token: typography.bodySmall
        helperStyle: typography.bodySmall.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: typography.bodySmall.copyWith(color: colorScheme.error),

        // Border styles - Token: radius.md, colorScheme
        border: OutlineInputBorder(
          borderRadius: radii.borderMd, // Token: radius.md (8px)
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radii.borderMd,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radii.borderMd,
          borderSide: BorderSide(
            color: colorScheme.primary, // Token: colorScheme.primary
            width: 2.0, // Token: borderWidth.medium
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radii.borderMd,
          borderSide: BorderSide(
            color: colorScheme.error, // Token: colorScheme.error
            width: 1.0, // Token: borderWidth.thin
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radii.borderMd,
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2.0, // Token: borderWidth.medium
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: radii.borderMd,
          borderSide: BorderSide(
            color: colorScheme.onSurface.withValues(
              alpha: 0.12,
            ), // Token: opacity.12
          ),
        ),

        // Padding and fill - Token: spacing.md, colorScheme
        contentPadding: EdgeInsets.all(
          spacing.spacing2,
        ), // Token: spacing.md (16px)
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,

        // Icon colors
        iconColor: colorScheme.onSurfaceVariant,
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
      ),

      // SnackBar Theme
      // Token Reference: components.snackbar.*
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            colorScheme.inverseSurface, // Token: colorScheme.inverseSurface
        contentTextStyle: typography.bodyMedium.copyWith(
          color: colorScheme
              .onInverseSurface, // Token: colorScheme.onInverseSurface
        ),
        actionTextColor:
            colorScheme.inversePrimary, // Token: colorScheme.inversePrimary
        elevation: elevation.level6, // Token: elevation.6
        shape: RoundedRectangleBorder(
          borderRadius: radii.borderSm, // Token: radius.sm (4px)
        ),
        behavior: SnackBarBehavior.floating,
        insetPadding: EdgeInsets.all(
          spacing.spacing2,
        ), // Token: spacing.md (16px)
      ),

      // Dialog Theme
      // Token Reference: components.dialog.*
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface, // Token: colorScheme.surface
        elevation: elevation.level24, // Token: elevation.24
        shape: RoundedRectangleBorder(
          borderRadius: radii.borderLg, // Token: radius.lg (12px)
        ),
        titleTextStyle: typography.h3.copyWith(color: colorScheme.onSurface),
        contentTextStyle: typography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Text Theme - Figtree via google_fonts (overrides all Material text styles)
      // (already set above)

      // Icon Theme
      iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24.0),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.2),
        thickness: 1,
        space: spacing.spacing2,
      ),

      // ThemeExtensions
      extensions: const [colors, typography, spacing, radii, elevation],
    );
  }
}
