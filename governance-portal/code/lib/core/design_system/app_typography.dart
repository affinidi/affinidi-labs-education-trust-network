import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Governance Portal Dashboard Typography System
///
/// Based on 03-design-tokens.yaml
/// Version: 2.0.0
/// Last Updated: January 15, 2026
///
/// Design Philosophy:
/// - Inter font for UI density and legibility at small sizes
/// - 14px minimum for data-dense tables
/// - 16px for comfortable reading in forms
/// - Clear hierarchy for governance workflows
class AppTypography {
  AppTypography._(); // Private constructor

  // ===========================================================================
  // FONT FAMILIES
  // ===========================================================================

  /// Primary Font Family: FigTree
  ///
  /// Optimized for UI density, highly legible at small sizes (12-14px)
  /// Fallbacks: System fonts (-apple-system, SF Pro Text, Segoe UI)
  static const String fontFamily = 'FigTree';

  /// Monospace Font Family: SF Mono / Cascadia Code
  ///
  /// Usage: Code snippets, DID values, technical identifiers
  static const String fontFamilyMonospace = 'SF Mono';

  /// Get FigTree TextTheme with fallbacks
  static TextTheme get FigTreeTextTheme => GoogleFonts.figtreeTextTheme();

  // ===========================================================================
  // FONT SIZES (8px baseline with 4px fine steps)
  // ===========================================================================

  static const double fontSizeXs = 10.0; // Micro text (use sparingly)
  static const double fontSizeSm = 12.0; // Small text, table metadata
  static const double fontSizeBase = 14.0; // Body text in tables, forms
  static const double fontSizeMd = 16.0; // Body text (comfortable reading)
  static const double fontSizeLg = 18.0; // Subheadings, emphasis
  static const double fontSizeXl = 20.0; // H3, card titles
  static const double fontSize2xl = 24.0; // H2, section headers
  static const double fontSize3xl = 28.0; // H1 (mobile/tablet)
  static const double fontSize4xl = 32.0; // H1 (desktop)
  static const double fontSize5xl = 36.0; // Large display
  static const double fontSize6xl = 48.0; // Hero display

  // ===========================================================================
  // FONT WEIGHTS
  // ===========================================================================

  static const FontWeight fontWeightLight = FontWeight.w300; // Rarely used
  static const FontWeight fontWeightRegular = FontWeight.w400; // Body default
  static const FontWeight fontWeightMedium = FontWeight.w500; // Table headers
  static const FontWeight fontWeightSemibold = FontWeight.w600; // Button text
  static const FontWeight fontWeightBold = FontWeight.w700; // Headings

  // ===========================================================================
  // LINE HEIGHTS
  // ===========================================================================

  static const double lineHeightTight = 1.2; // Headings, data tables
  static const double lineHeightSnug = 1.4; // Compact layouts
  static const double lineHeightNormal = 1.5; // Body text default
  static const double lineHeightRelaxed = 1.75; // Long-form (rare)

  // ===========================================================================
  // LETTER SPACING
  // ===========================================================================

  static const double letterSpacingTight = -0.02; // Large headings
  static const double letterSpacingNormal = 0.0; // Default
  static const double letterSpacingWide = 0.05; // All-caps labels, buttons

  // ===========================================================================
  // TEXT STYLES (Material 3 Typography)
  // ===========================================================================

  // Display Styles (Large Headings)

  /// Display Large - 48px Bold
  ///
  /// Usage: Hero display (rarely used in dashboard)
  static TextStyle get displayLarge => GoogleFonts.figtree(
        fontSize: fontSize6xl,
        fontWeight: fontWeightBold,
        letterSpacing: letterSpacingTight,
        height: lineHeightTight,
        color: AppColors.textPrimary,
      );

  /// Display Medium - 36px Bold
  ///
  /// Usage: Large display
  static TextStyle get displayMedium => GoogleFonts.figtree(
        fontSize: fontSize5xl,
        fontWeight: fontWeightBold,
        letterSpacing: letterSpacingTight,
        height: lineHeightTight,
        color: AppColors.textPrimary,
      );

  /// Display Small - 32px Bold
  ///
  /// Usage: H1 (desktop)
  static TextStyle get displaySmall => GoogleFonts.figtree(
        fontSize: fontSize4xl,
        fontWeight: fontWeightBold,
        letterSpacing: letterSpacingTight,
        height: lineHeightTight,
        color: AppColors.textPrimary,
      );

  // Headline Styles (Section Headings)

  /// Headline Large - 28px Bold
  ///
  /// Usage: H1 (mobile/tablet)
  static TextStyle get headlineLarge => GoogleFonts.figtree(
        fontSize: fontSize3xl,
        fontWeight: fontWeightBold,
        height: lineHeightTight,
        color: AppColors.textPrimary,
      );

  /// Headline Medium - 24px Bold
  ///
  /// Usage: H2, section headers
  static TextStyle get headlineMedium => GoogleFonts.figtree(
        fontSize: fontSize2xl,
        fontWeight: fontWeightBold,
        height: lineHeightTight,
        color: AppColors.textPrimary,
      );

  /// Headline Small - 20px Semibold
  ///
  /// Usage: H3, card titles
  static TextStyle get headlineSmall => GoogleFonts.figtree(
        fontSize: fontSizeXl,
        fontWeight: fontWeightSemibold,
        height: lineHeightSnug,
        color: AppColors.textPrimary,
      );

  // Title Styles (Component Titles)

  /// Title Large - 18px Medium
  ///
  /// Usage: Modal titles, subheadings
  static TextStyle get titleLarge => GoogleFonts.figtree(
        fontSize: fontSizeLg,
        fontWeight: fontWeightMedium,
        height: lineHeightSnug,
        color: AppColors.textPrimary,
      );

  /// Title Medium - 16px Semibold
  ///
  /// Usage: Card headers, emphasis
  static TextStyle get titleMedium => GoogleFonts.figtree(
        fontSize: fontSizeMd,
        fontWeight: fontWeightSemibold,
        height: lineHeightSnug,
        color: AppColors.textPrimary,
      );

  /// Title Small - 14px Medium
  ///
  /// Usage: Table headers, form labels
  static TextStyle get titleSmall => GoogleFonts.figtree(
        fontSize: fontSizeBase,
        fontWeight: fontWeightMedium,
        height: lineHeightSnug,
        color: AppColors.textPrimary,
      );

  // Body Styles (Body Text)

  /// Body Large - 16px Regular
  ///
  /// Usage: Body text (comfortable reading in forms)
  static TextStyle get bodyLarge => GoogleFonts.figtree(
        fontSize: fontSizeMd,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: AppColors.textPrimary,
      );

  /// Body Medium - 14px Regular
  ///
  /// Usage: Body text in tables, forms (minimum for data-dense)
  static TextStyle get bodyMedium => GoogleFonts.figtree(
        fontSize: fontSizeBase,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: AppColors.textPrimary,
      );

  /// Body Small - 12px Regular
  ///
  /// Usage: Small text, table metadata
  static TextStyle get bodySmall => GoogleFonts.figtree(
        fontSize: fontSizeSm,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: AppColors.textSecondary,
      );

  // Label Styles (Labels, Buttons)

  /// Label Large - 14px Semibold
  ///
  /// Usage: Button text (default size)
  static TextStyle get labelLarge => GoogleFonts.figtree(
        fontSize: fontSizeBase,
        fontWeight: fontWeightSemibold,
        letterSpacing: letterSpacingWide,
        height: lineHeightSnug,
        color: AppColors.textPrimary,
      );

  /// Label Medium - 12px Medium
  ///
  /// Usage: Form field labels, metadata labels
  static TextStyle get labelMedium => GoogleFonts.figtree(
        fontSize: fontSizeSm,
        fontWeight: fontWeightMedium,
        letterSpacing: letterSpacingWide,
        height: lineHeightSnug,
        color: AppColors.textSecondary,
      );

  /// Label Small - 10px Medium
  ///
  /// Usage: Micro labels, badges (use sparingly)
  static TextStyle get labelSmall => GoogleFonts.figtree(
        fontSize: fontSizeXs,
        fontWeight: fontWeightMedium,
        letterSpacing: letterSpacingWide,
        height: lineHeightSnug,
        color: AppColors.textSecondary,
      );

  // ===========================================================================
  // SPECIALIZED TEXT STYLES
  // ===========================================================================

  /// Monospace Text - 14px Regular
  ///
  /// Usage: Code snippets, DID values, technical identifiers
  static TextStyle get monospace => TextStyle(
        fontFamily: fontFamilyMonospace,
        fontSize: fontSizeBase,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: AppColors.textPrimary,
      );

  /// Monospace Small - 12px Regular
  ///
  /// Usage: Small code snippets, inline technical values
  static TextStyle get monospaceSmall => TextStyle(
        fontFamily: fontFamilyMonospace,
        fontSize: fontSizeSm,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: AppColors.textPrimary,
      );

  /// Link Text - 14px Regular
  ///
  /// Usage: Clickable links
  static TextStyle get link => GoogleFonts.figtree(
        fontSize: fontSizeBase,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: AppColors.linkMain,
        decoration: TextDecoration.underline,
      );

  /// Link Small - 12px Regular
  ///
  /// Usage: Small links in metadata
  static TextStyle get linkSmall => GoogleFonts.figtree(
        fontSize: fontSizeSm,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: AppColors.linkMain,
        decoration: TextDecoration.underline,
      );

  /// Button Text - 14px Semibold
  ///
  /// Usage: Button text with wide letter spacing
  static TextStyle get button => GoogleFonts.figtree(
        fontSize: fontSizeBase,
        fontWeight: fontWeightSemibold,
        letterSpacing: letterSpacingWide,
        height: lineHeightSnug,
        color: AppColors.textOnDark,
      );

  /// Table Cell - 14px Regular (tight line height)
  ///
  /// Usage: Table cell text optimized for dense rows
  static TextStyle get tableCell => GoogleFonts.figtree(
        fontSize: fontSizeBase,
        fontWeight: fontWeightRegular,
        height: lineHeightTight,
        color: AppColors.textPrimary,
      );

  /// Table Header - 14px Medium
  ///
  /// Usage: Table column headers
  static TextStyle get tableHeader => TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSizeBase,
        fontWeight: fontWeightMedium,
        height: lineHeightTight,
        color: AppColors.textPrimary,
      );

  // ===========================================================================
  // HELPER METHODS
  // ===========================================================================

  /// Create TextTheme for Material 3
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
