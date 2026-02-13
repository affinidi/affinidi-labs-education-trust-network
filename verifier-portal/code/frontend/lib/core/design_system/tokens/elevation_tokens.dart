import 'package:flutter/material.dart';

/// NovaCorp Employer Verification Portal - Elevation Tokens
/// Version: 2.0.0
/// Last Updated: 2026-01-07
///
/// Design Token Reference: verifier-portal/design-language/03-design-tokens.yaml
/// Section: elevation
///
/// Usage:
/// ```dart
/// final elevation = Theme.of(context).extension<ElevationTokens>()!;
/// Card(elevation: elevation.level2);
/// ```

class ElevationTokens extends ThemeExtension<ElevationTokens> {
  // ===========================================================================
  // ELEVATION LEVELS (Material Design)
  // Token: elevation.*
  // ===========================================================================

  final double level0; // 0 - Flat, no shadow
  final double level1; // 1 - Subtle
  final double level2; // 2 - Cards (default)
  final double level3; // 3 - Raised elements
  final double level4; // 4 - AppBar, snackbars
  final double level6; // 6 - FAB resting
  final double level8; // 8 - FAB pressed, navigation drawer
  final double level12; // 12 - Dialogs
  final double level16; // 16 - Modal dialogs
  final double level24; // 24 - Highest elevation (rarely used)

  const ElevationTokens({
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level6,
    required this.level8,
    required this.level12,
    required this.level16,
    required this.level24,
  });

  // ===========================================================================
  // DEFAULT ELEVATION
  // ===========================================================================

  static const ElevationTokens standard = ElevationTokens(
    level0: 0.0,
    level1: 1.0,
    level2: 2.0,
    level3: 3.0,
    level4: 4.0,
    level6: 6.0,
    level8: 8.0,
    level12: 12.0,
    level16: 16.0,
    level24: 24.0,
  );

  @override
  ThemeExtension<ElevationTokens> copyWith({
    double? level0,
    double? level1,
    double? level2,
    double? level3,
    double? level4,
    double? level6,
    double? level8,
    double? level12,
    double? level16,
    double? level24,
  }) {
    return ElevationTokens(
      level0: level0 ?? this.level0,
      level1: level1 ?? this.level1,
      level2: level2 ?? this.level2,
      level3: level3 ?? this.level3,
      level4: level4 ?? this.level4,
      level6: level6 ?? this.level6,
      level8: level8 ?? this.level8,
      level12: level12 ?? this.level12,
      level16: level16 ?? this.level16,
      level24: level24 ?? this.level24,
    );
  }

  @override
  ThemeExtension<ElevationTokens> lerp(
    ThemeExtension<ElevationTokens>? other,
    double t,
  ) {
    if (other is! ElevationTokens) return this;

    return ElevationTokens(
      level0: level0,
      level1: level1,
      level2: level2,
      level3: level3,
      level4: level4,
      level6: level6,
      level8: level8,
      level12: level12,
      level16: level16,
      level24: level24,
    );
  }
}
