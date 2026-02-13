import 'package:flutter/material.dart';

/// Governance Portal Dashboard Shadows & Elevation System
///
/// Based on 03-design-tokens.yaml
/// Version: 2.0.0
/// Last Updated: January 15, 2026
///
/// Design Philosophy:
/// - Light mode shadows (subtle, minimal)
/// - Professional governance tools avoid dramatic elevation
/// - Shadows use neutral dark gray (rgba(29, 38, 51, 0.05-0.20))
class AppShadows {
  AppShadows._(); // Private constructor

  // ===========================================================================
  // SHADOW COLOR BASE
  // ===========================================================================

  /// Shadow color base (neutral-500: #1D2633)
  ///
  /// All shadows use this color at varying opacities
  static const Color shadowColorBase = Color(0xFF1D2633);

  // ===========================================================================
  // LIGHT MODE SHADOWS (Material Design)
  // ===========================================================================

  /// No shadow
  ///
  /// Usage: Flat elements, no elevation
  static const List<BoxShadow> shadowNone = [];

  /// Shadow Small (elevation 1)
  ///
  /// Usage: Subtle card elevation
  /// Offset: 0px 1px, Blur: 2px, Opacity: 5%
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x0D1D2633), // rgba(29, 38, 51, 0.05)
      offset: Offset(0, 1),
      blurRadius: 2.0,
      spreadRadius: 0,
    ),
  ];

  /// Shadow Medium (elevation 2)
  ///
  /// Usage: Card default elevation, raised elements
  /// Offset: 0px 2px, Blur: 4px, Opacity: 8%
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x141D2633), // rgba(29, 38, 51, 0.08)
      offset: Offset(0, 2),
      blurRadius: 4.0,
      spreadRadius: 0,
    ),
  ];

  /// Shadow Large (elevation 4)
  ///
  /// Usage: Raised elements, dropdowns
  /// Offset: 0px 4px, Blur: 8px, Opacity: 12%
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x1F1D2633), // rgba(29, 38, 51, 0.12)
      offset: Offset(0, 4),
      blurRadius: 8.0,
      spreadRadius: 0,
    ),
  ];

  /// Shadow Extra Large (elevation 8)
  ///
  /// Usage: Modals, dialogs
  /// Offset: 0px 8px, Blur: 16px, Opacity: 16%
  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x291D2633), // rgba(29, 38, 51, 0.16)
      offset: Offset(0, 8),
      blurRadius: 16.0,
      spreadRadius: 0,
    ),
  ];

  /// Shadow 2XL (elevation 12)
  ///
  /// Usage: High elevation modals, overlays
  /// Offset: 0px 16px, Blur: 32px, Opacity: 20%
  static const List<BoxShadow> shadow2xl = [
    BoxShadow(
      color: Color(0x331D2633), // rgba(29, 38, 51, 0.20)
      offset: Offset(0, 16),
      blurRadius: 32.0,
      spreadRadius: 0,
    ),
  ];

  // ===========================================================================
  // MATERIAL ELEVATION LEVELS
  // ===========================================================================

  /// Elevation 0 - Flat, no shadow
  static const double elevation0 = 0.0;

  /// Elevation 1 - Subtle card
  ///
  /// Usage: Resting cards, subtle separation
  static const double elevation1 = 1.0;

  /// Elevation 2 - Raised card
  ///
  /// Usage: Default card elevation
  static const double elevation2 = 2.0;

  /// Elevation 4 - Dropdown
  ///
  /// Usage: Dropdowns, menus
  static const double elevation4 = 4.0;

  /// Elevation 8 - Modal backdrop
  ///
  /// Usage: Modal backdrop layer
  static const double elevation8 = 8.0;

  /// Elevation 12 - Modal/Dialog
  ///
  /// Usage: Modals, dialogs, highest elevation
  static const double elevation12 = 12.0;

  // ===========================================================================
  // OPACITY LEVELS (for custom shadows)
  // ===========================================================================

  static const double opacity0 = 0.0;
  static const double opacity10 = 0.1;
  static const double opacity20 = 0.2;
  static const double opacity30 = 0.3;
  static const double opacity40 = 0.4;
  static const double opacity50 = 0.5;
  static const double opacity60 = 0.6;
  static const double opacity70 = 0.7;
  static const double opacity80 = 0.8;
  static const double opacity90 = 0.9;
  static const double opacity100 = 1.0;

  // ===========================================================================
  // HELPER METHODS
  // ===========================================================================

  /// Get BoxShadow by elevation level
  ///
  /// Maps Material elevation to appropriate shadow
  static List<BoxShadow> getShadowByElevation(double elevation) {
    if (elevation == 0) return shadowNone;
    if (elevation <= 1) return shadowSm;
    if (elevation <= 2) return shadowMd;
    if (elevation <= 4) return shadowLg;
    if (elevation <= 8) return shadowXl;
    return shadow2xl;
  }

  /// Create custom BoxShadow with opacity
  ///
  /// Usage: When you need a custom shadow that's not in the predefined set
  static BoxShadow customShadow({
    required double offsetY,
    required double blurRadius,
    double opacity = 0.08,
    double offsetX = 0,
    double spreadRadius = 0,
  }) {
    return BoxShadow(
      color: shadowColorBase.withOpacity(opacity),
      offset: Offset(offsetX, offsetY),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );
  }
}
