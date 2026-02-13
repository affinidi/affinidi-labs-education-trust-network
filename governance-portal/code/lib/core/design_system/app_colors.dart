import 'package:flutter/material.dart';

/// Governance Portal Dashboard Color System
///
/// Based on 03-design-tokens.yaml
/// Version: 2.0.0
/// Last Updated: January 15, 2026
///
/// Design Philosophy:
/// - Professional governance credibility (neutral dark blue, cool grays)
/// - Living trust network metaphor (teal for success, subtle pulse animations)
/// - Light mode content area + dark contrast navigation
/// - WCAG AA contrast minimums (4.5:1 for body text, 7:1 for AAA)
class AppColors {
  AppColors._(); // Private constructor - prevent instantiation

  // ===========================================================================
  // BRAND COLORS (Neutral Dark Blue)
  // ===========================================================================

  /// Brand Primary - Neutral Dark Blue (#0F2741)
  ///
  /// Usage: Gradient buttons (start), focus elements, branding
  static const Color brandPrimary = Color(0xFF0F2741);

  /// Brand Primary Light (#1D3C67)
  ///
  /// Usage: Gradient buttons (end), hover states
  static const Color brandPrimaryLight = Color(0xFF1D3C67);

  /// Brand Primary Dark (#081729)
  ///
  /// Usage: Pressed states (rarely used)
  static const Color brandPrimaryDark = Color(0xFF081729);

  // ===========================================================================
  // ACCENT COLORS (Vibrant Blue-Purple - Primary CTAs)
  // ===========================================================================

  /// Accent Blue (#2563EB)
  ///
  /// Usage: Primary CTA gradient start, vibrant actions
  static const Color accentBlue = Color(0xFF2563EB);

  /// Accent Purple (#7C3AED)
  ///
  /// Usage: Primary CTA gradient end, vibrant actions
  static const Color accentPurple = Color(0xFF7C3AED);

  /// Accent Pink (#FF3DCB)
  ///
  /// Usage: Decorative gradient blobs, accent elements
  static const Color accentPink = Color(0xFFFF3DCB);

  /// Accent Blue Dark (#1E40AF)
  ///
  /// Usage: Darker gradient buttons (start)
  static const Color accentBlueDark = Color(0xFF1E40AF);

  /// Accent Purple Dark (#5B21B6)
  ///
  /// Usage: Darker gradient buttons (end)
  static const Color accentPurpleDark = Color(0xFF5B21B6);

  // ===========================================================================
  // NAVIGATION COLORS (Dark Sidebar)
  // ===========================================================================

  /// Navigation Background (#0B1B2B)
  ///
  /// Usage: Dark left sidebar background
  static const Color navBackground = Color(0xFF0B1B2B);

  /// Navigation Text (#FFFFFF)
  ///
  /// Usage: Primary text on dark nav
  static const Color navText = Color(0xFFFFFFFF);

  /// Navigation Text Secondary (#A0AEC0)
  ///
  /// Usage: Secondary text, metadata, icons on dark nav
  static const Color navTextSecondary = Color(0xFFA0AEC0);

  /// Navigation Hover (#1D3C67)
  ///
  /// Usage: Hover state on nav items
  static const Color navHover = Color(0xFF1D3C67);

  /// Navigation Selected (#1D3C67)
  ///
  /// Usage: Selected/active nav item background
  static const Color navSelected = Color(0xFF1D3C67);

  // ===========================================================================
  // NEUTRAL PALETTE (Cool-leaning Grays)
  // ===========================================================================

  /// Neutral 0 - Pure White (#FFFFFF)
  static const Color neutral0 = Color(0xFFFFFFFF);

  /// Neutral 50 - Off-White (#F7F9FC)
  ///
  /// Usage: Alternative background (very light blue-gray)
  static const Color neutral50 = Color(0xFFF7F9FC);

  /// Neutral 100 - Lightest Gray (#EEF2F7)
  static const Color neutral100 = Color(0xFFEEF2F7);

  /// Neutral 200 - Light Gray (#E3E8EF)
  ///
  /// Usage: Borders, dividers
  static const Color neutral200 = Color(0xFFE3E8EF);

  /// Neutral 300 - Mid-Light Gray (#C2CCDA)
  static const Color neutral300 = Color(0xFFC2CCDA);

  /// Neutral 400 - Mid Gray (#64758B)
  ///
  /// Usage: Secondary text, metadata
  static const Color neutral400 = Color(0xFF64758B);

  /// Neutral 500 - Dark Gray (#1D2633)
  ///
  /// Usage: Primary text, headings
  static const Color neutral500 = Color(0xFF1D2633);

  // ===========================================================================
  // LINK & INFO BLUE
  // ===========================================================================

  /// Link Main (#2F6BDE)
  ///
  /// Usage: Actionable links, informational elements
  /// Maps to: ColorScheme.primary in Flutter theme
  static const Color linkMain = Color(0xFF2F6BDE);

  /// Link Hover (#1E4BB8)
  ///
  /// Usage: Link hover state
  static const Color linkHover = Color(0xFF1E4BB8);

  /// Link Visited (#5B4CCC)
  ///
  /// Usage: Visited link (optional, rarely used in dashboards)
  static const Color linkVisited = Color(0xFF5B4CCC);

  // ===========================================================================
  // FOCUS COLOR
  // ===========================================================================

  /// Focus Ring (#2563EB)
  ///
  /// Usage: Keyboard focus indicators, accessibility
  static const Color focusRing = Color(0xFF2563EB);

  // ===========================================================================
  // SEMANTIC COLORS (Feedback & Status)
  // ===========================================================================

  // Success (Teal - NOT green)
  // Rationale: Teal feels more measured/professional for governance

  /// Semantic Success Main (#14B8A6)
  ///
  /// Usage: Success feedback, authorized records, positive actions
  static const Color semanticSuccess = Color(0xFF14B8A6);

  /// Semantic Success Light (#5EEAD4)
  static const Color semanticSuccessLight = Color(0xFF5EEAD4);

  /// Semantic Success Dark (#0F766E)
  static const Color semanticSuccessDark = Color(0xFF0F766E);

  /// Semantic Success Contrast (#FFFFFF)
  ///
  /// Usage: Text on success background
  static const Color semanticSuccessContrast = Color(0xFFFFFFFF);

  // Warning (Amber)

  /// Semantic Warning Main (#F59E0B)
  ///
  /// Usage: Warning states, caution, pending actions
  static const Color semanticWarning = Color(0xFFF59E0B);

  /// Semantic Warning Light (#FCD34D)
  static const Color semanticWarningLight = Color(0xFFFCD34D);

  /// Semantic Warning Dark (#D97706)
  static const Color semanticWarningDark = Color(0xFFD97706);

  /// Semantic Warning Contrast (#000000)
  ///
  /// Usage: Text on warning background
  static const Color semanticWarningContrast = Color(0xFF000000);

  // Error (Red)

  /// Semantic Error Main (#F43F5E)
  ///
  /// Usage: Error states, destructive actions, validation failures
  static const Color semanticError = Color(0xFFF43F5E);

  /// Semantic Error Light (#FB7185)
  static const Color semanticErrorLight = Color(0xFFFB7185);

  /// Semantic Error Dark (#BE123C)
  static const Color semanticErrorDark = Color(0xFFBE123C);

  /// Semantic Error Contrast (#FFFFFF)
  ///
  /// Usage: Text on error background
  static const Color semanticErrorContrast = Color(0xFFFFFFFF);

  // Info (Blue - same as link)

  /// Semantic Info Main (#2F6BDE)
  ///
  /// Usage: Informational messages, tooltips
  static const Color semanticInfo = Color(0xFF2F6BDE);

  /// Semantic Info Light (#60A5FA)
  static const Color semanticInfoLight = Color(0xFF60A5FA);

  /// Semantic Info Dark (#1E40AF)
  static const Color semanticInfoDark = Color(0xFF1E40AF);

  /// Semantic Info Contrast (#FFFFFF)
  ///
  /// Usage: Text on info background
  static const Color semanticInfoContrast = Color(0xFFFFFFFF);

  // ===========================================================================
  // RAINBOW GRADIENT (Key Sections Only - NOT for buttons)
  // ===========================================================================
  // Rationale: Living network metaphor - trust is interconnected and vibrant
  // Constraint: Only use for network "hubs" (most important/connected records)

  /// Rainbow Purple (#7C3AED)
  static const Color rainbowPurple = Color(0xFF7C3AED);

  /// Rainbow Blue (#2563EB)
  static const Color rainbowBlue = Color(0xFF2563EB);

  /// Rainbow Cyan (#06B6D4)
  static const Color rainbowCyan = Color(0xFF06B6D4);

  /// Rainbow Teal (#14B8A6)
  static const Color rainbowTeal = Color(0xFF14B8A6);

  /// Rainbow Amber (#F59E0B)
  static const Color rainbowAmber = Color(0xFFF59E0B);

  /// Rainbow Rose (#F43F5E)
  static const Color rainbowRose = Color(0xFFF43F5E);

  /// Rainbow Gradient Colors (for use in LinearGradient)
  static const List<Color> rainbowGradient = [
    rainbowPurple,
    rainbowBlue,
    rainbowCyan,
    rainbowTeal,
    rainbowAmber,
    rainbowRose,
  ];

  // ===========================================================================
  // SURFACE COLORS (Light Mode - Default)
  // ===========================================================================

  /// Surface Background (#FFFFFF)
  ///
  /// Usage: Main content background
  static const Color surfaceBackground = Color(0xFFFFFFFF);

  /// Surface Background Alt (#F7F9FC)
  ///
  /// Usage: Alternative background (neutral-50)
  static const Color surfaceBackgroundAlt = Color(0xFFF7F9FC);

  /// Surface Card (#FFFFFF)
  ///
  /// Usage: Card background
  static const Color surfaceCard = Color(0xFFFFFFFF);

  /// Surface Card Alt (#F7F9FC)
  ///
  /// Usage: Alternative card background
  static const Color surfaceCardAlt = Color(0xFFF7F9FC);

  /// Surface Hover (#EEF2F7)
  ///
  /// Usage: Hover state for table rows
  static const Color surfaceHover = Color(0xFFEEF2F7);

  /// Surface Selected (#E3E8EF)
  ///
  /// Usage: Selected state for rows
  static const Color surfaceSelected = Color(0xFFE3E8EF);

  /// Surface Disabled (#EEF2F7)
  ///
  /// Usage: Disabled element background
  static const Color surfaceDisabled = Color(0xFFEEF2F7);

  // ===========================================================================
  // TEXT COLORS (On Light Surfaces)
  // ===========================================================================

  /// Text Primary (#1D2633)
  ///
  /// Usage: Primary text, headings (neutral-500)
  /// Contrast: 13.5:1 on white (WCAG AAA)
  static const Color textPrimary = Color(0xFF1D2633);

  /// Text Secondary (#64758B)
  ///
  /// Usage: Secondary text, metadata (neutral-400)
  /// Contrast: 5.8:1 on white (WCAG AA)
  static const Color textSecondary = Color(0xFF64758B);

  /// Text Tertiary (#C2CCDA)
  ///
  /// Usage: Tertiary text, placeholders (neutral-300)
  static const Color textTertiary = Color(0xFFC2CCDA);

  /// Text Disabled (#C2CCDA)
  ///
  /// Usage: Disabled text
  static const Color textDisabled = Color(0xFFC2CCDA);

  /// Text On Dark (#FFFFFF)
  ///
  /// Usage: Text on dark backgrounds (nav)
  static const Color textOnDark = Color(0xFFFFFFFF);

  /// Text On Dark Secondary (#A0AEC0)
  ///
  /// Usage: Secondary text on dark
  static const Color textOnDarkSecondary = Color(0xFFA0AEC0);

  /// Text Link (#2F6BDE)
  ///
  /// Usage: Link text (same as linkMain)
  static const Color textLink = Color(0xFF2F6BDE);

  // ===========================================================================
  // BORDER COLORS
  // ===========================================================================

  /// Border Default (#E3E8EF)
  ///
  /// Usage: Default borders (neutral-200)
  static const Color borderDefault = Color(0xFFE3E8EF);

  /// Border Strong (#C2CCDA)
  ///
  /// Usage: Strong borders (neutral-300)
  static const Color borderStrong = Color(0xFFC2CCDA);

  /// Border Subtle (#EEF2F7)
  ///
  /// Usage: Subtle borders (neutral-100)
  static const Color borderSubtle = Color(0xFFEEF2F7);

  /// Border Focus (#2563EB)
  ///
  /// Usage: Focus state border
  static const Color borderFocus = Color(0xFF2563EB);

  /// Border Error (#F43F5E)
  ///
  /// Usage: Error state border
  static const Color borderError = Color(0xFFF43F5E);

  // ===========================================================================
  // OVERLAY COLORS (Modals, Backdrops)
  // ===========================================================================

  /// Overlay Backdrop (rgba(11, 27, 43, 0.6))
  ///
  /// Usage: Modal backdrop (dark nav color)
  static const Color overlayBackdrop = Color(0x990B1B2B);

  /// Overlay White 10% (rgba(255, 255, 255, 0.1))
  static const Color overlayWhite10 = Color(0x1AFFFFFF);

  /// Overlay White 20% (rgba(255, 255, 255, 0.2))
  static const Color overlayWhite20 = Color(0x33FFFFFF);

  /// Overlay Disabled (rgba(194, 204, 218, 0.4))
  static const Color overlayDisabled = Color(0x66C2CCDA);
}
