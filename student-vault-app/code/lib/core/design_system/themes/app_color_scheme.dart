import 'package:flutter/material.dart';

// Helper notes:
// - All hex taken from 03-design-tokens.yaml
// - Keep useMaterial3: true in your ThemeData to fully use these fields.

class AppColorScheme {
  // Brand primary from tokens (colors.primary.500)
  static const _primary = Color(0xFFFF8E32);

  // ---------- LIGHT ----------------------------------------------------------
  static final light = const ColorScheme(
    brightness: Brightness.light,

    // Brand (Primary)
    primary: Color(0xFFFF8E32), // colors.primary.500
    onPrimary: Colors.white, // good contrast on brand orange
    primaryContainer: Color(
      0xFFFFEEC8,
    ), // colors.primary.100 as container (light)
    onPrimaryContainer: Color(0xFF1E1E1E), // text.light.primary
    // Secondary (Warm cream system track)
    secondary: Color(0xFFFFDC99), // colors.secondary.500
    onSecondary: Color(0xFF1E1E1E), // text.light.primary
    secondaryContainer: Color(0xFFFFEEC8), // colors.secondary.300
    onSecondaryContainer: Color(0xFF1E1E1E), // text.light.primary
    // Tertiary (Extended cyan accent)
    tertiary: Color(0xFF00BCD4), // extended.cyan
    onTertiary: Colors.white, // cyan works with white
    tertiaryContainer: Color(
      0xFF64B5F6,
    ), // borrow info.light as container tint (#64B5F6)
    onTertiaryContainer: Color(0xFF1E1E1E),

    // Error
    error: Color(0xFFF44336), // semantic.error.main
    onError: Colors.white, // semantic.error.contrast
    errorContainer: Color(0xFFE57373), // semantic.error.light
    onErrorContainer: Colors.white, // semantic.error.contrast
    // Surfaces & Backgrounds (light tokens)
    // background: Color(0xFFFFFDF7), // surface.light.background
    // onBackground: Color(0xFF1E1E1E), // text.light.primary
    surface: Color(0xFFFFEEC8), // surface.light.surface
    onSurface: Color(0xFF1E1E1E), // text.light.primary
    // surfaceVariant: Color(0xFFFFFBF7), // surface.light.surfaceVariant
    onSurfaceVariant: Color(0xFF4A4A4A), // text.light.secondary
    // Outline & outlineVariant (neutrals)
    outline: Color(0xFFBDBDBD), // neutral.400
    outlineVariant: Color(0xFFE0E0E0), // neutral.300
    // Dividers / scrims / shadows
    shadow: Color(0xFF000000), // neutral.1000
    scrim: Color(0xFF000000), // neutral.1000
    // Inverse (used on elevated components over light background)
    inverseSurface: Color(0xFF212121), // neutral.900
    onInverseSurface: Color(0xFFFFFFFF), // white
    inversePrimary: Color(0xFFFFB166), // colors.primary.300
    // Surface tint (M3 elevation)
    surfaceTint: _primary,

    // Container levels (Flutter 3.22+)
    surfaceContainerHighest: Color(
      0xFFFFFCF9,
    ), // surface.light.surfaceContainerHighest
    surfaceContainerHigh: Color(
      0xFFFFF6E1,
    ), // surface.light.surfaceContainerHigh
    surfaceContainer: Color(0xFFFFFAF7), // surface.light.surfaceContainer
    // Flutter also exposes surfaceContainerLow & surfaceContainerLowest in newer SDKs:
    // We'll derive them from the same light ramp (closest available tokens).
    surfaceContainerLow: Color(0xFFFFFBF7), // close to surfaceVariant
    surfaceContainerLowest: Color(
      0xFFFFFFFF,
    ), // neutral.0 (pure white) as the lowest
  );

  // ---------- DARK -----------------------------------------------------------
  static final dark = const ColorScheme(
    brightness: Brightness.dark,

    // Brand (Primary)
    primary: Color(0xFFFF8E32), // colors.primary.500
    onPrimary: Color(0xFF000000), // high contrast on bright orange (dark text)
    primaryContainer: Color(
      0xFFE67E28,
    ), // colors.primary.600 as container (dark)
    onPrimaryContainer: Color(0xFFFFFFFF), // white
    // Secondary (Warm cream accent)
    secondary: Color(0xFFFFDC99), // colors.secondary.500
    onSecondary: Color(0xFF212121), // neutral.900 for contrast on cream
    // Use a neutral container in dark to avoid glare
    secondaryContainer: Color(0xFF2E3034), // surface.dark.surfaceVariant
    onSecondaryContainer: Color(0xFFFFFFFF),

    // Tertiary (Extended cyan)
    tertiary: Color(0xFF00BCD4), // extended.cyan
    onTertiary: Color(0xFF000000), // cyan supports dark text at this luminance
    tertiaryContainer: Color(
      0xFF1976D2,
    ), // semantic.info.dark (cool, deeper blue)
    onTertiaryContainer: Color(0xFFFFFFFF),

    // Error
    error: Color(0xFFF44336), // semantic.error.main
    onError: Colors.white,
    errorContainer: Color(0xFFD32F2F), // semantic.error.dark
    onErrorContainer: Colors.white,

    // Surfaces & Backgrounds (dark tokens)
    // background: Color(0xFF000000), // surface.dark.background
    // onBackground: Color(0xFFFFFFFF), // text.dark.primary
    surface: Color(0xFF000000), // surface.dark.surface
    onSurface: Color(0xFFFFFFFF), // text.dark.primary
    // surfaceVariant: Color(0xFF2E3034), // surface.dark.surfaceVariant
    onSurfaceVariant: Color(0xFFB0B0B0), // text.dark.secondary
    // Outline & outlineVariant (neutrals)
    outline: Color(0xFF636363), // neutral.700
    outlineVariant: Color(0xFF424242), // neutral.800
    // Dividers / scrims / shadows
    shadow: Color(0xFF000000), // neutral.1000
    scrim: Color(0xFF000000), // neutral.1000
    // Inverse (for dark, inverseSurface is a light surface)
    inverseSurface: Color(0xFFFAFAFA), // neutral.50
    onInverseSurface: Color(0xFF212121), // neutral.900
    inversePrimary: Color(
      0xFFFFB166,
    ), // colors.primary.300 (pleasant highlight on light inverse)
    // Surface tint
    surfaceTint: Color(0xFFFF8E32), // primary
    // Container levels (dark)
    surfaceContainerHighest: Color(
      0xFF000000,
    ), // surface.dark.surfaceContainerHighest
    surfaceContainerHigh: Color(
      0xFF2E3034,
    ), // surface.dark.surfaceContainerHigh
    surfaceContainer: Color(0xFF000000), // surface.dark.surfaceContainer
    // As above, fill in derived lower levels:
    surfaceContainerLow: Color(
      0xFF1A1B1E,
    ), // derived: between #000000 and #2E3034
    surfaceContainerLowest: Color(0xFF000000), // darkest
  );
}
