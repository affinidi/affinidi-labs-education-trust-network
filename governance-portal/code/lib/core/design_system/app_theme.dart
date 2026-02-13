import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';
import 'app_shadows.dart';

/// Governance Portal Dashboard Theme Configuration
///
/// Based on 03-design-tokens.yaml and 07-flutter-theme.md
/// Version: 2.0.0
/// Last Updated: January 15, 2026
///
/// This configures Flutter's Material 3 ThemeData to use design tokens
/// from the Governance Portal design system.
///
/// Design Philosophy:
/// - Professional governance credibility (neutral dark blue, cool grays)
/// - Light mode content area + dark contrast navigation
/// - Desktop-first data-dense workflows
/// - Living trust network metaphor
class AppTheme {
  AppTheme._(); // Private constructor

  // ===========================================================================
  // LIGHT THEME (Default)
  // ===========================================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // -----------------------------------------------------------------------
      // COLOR SCHEME
      // -----------------------------------------------------------------------
      colorScheme: ColorScheme.light(
        // Primary color (Link Blue - actionable elements)
        primary: AppColors.linkMain,
        onPrimary: AppColors.neutral0,

        // Secondary color (Teal - success/authorized)
        secondary: AppColors.semanticSuccess,
        onSecondary: AppColors.semanticSuccessContrast,

        // Tertiary color (Brand Blue - branding, focus)
        tertiary: AppColors.brandPrimary,
        onTertiary: AppColors.neutral0,

        // Error color
        error: AppColors.semanticError,
        onError: AppColors.semanticErrorContrast,

        // Surface colors (light backgrounds)
        surface: AppColors.surfaceBackground,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceBackgroundAlt,

        // Outline colors (borders)
        outline: AppColors.borderDefault,
        outlineVariant: AppColors.borderSubtle,

        // Shadow color
        shadow: AppShadows.shadowColorBase,
      ),

      // -----------------------------------------------------------------------
      // TRANSITIONS
      // -----------------------------------------------------------------------
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),

      // -----------------------------------------------------------------------
      // TYPOGRAPHY
      // -----------------------------------------------------------------------
      textTheme: AppTypography.textTheme,

      // Use Figtree font via Google Fonts
      fontFamily: GoogleFonts.figtree().fontFamily,

      // -----------------------------------------------------------------------
      // APP BAR THEME
      // -----------------------------------------------------------------------
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: AppShadows.elevation0,
        scrolledUnderElevation: AppShadows.elevation1,
        backgroundColor: AppColors.surfaceBackground,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        toolbarHeight: AppSpacing.appBarHeight,
      ),

      // -----------------------------------------------------------------------
      // CARD THEME
      // -----------------------------------------------------------------------
      cardTheme: CardThemeData(
        elevation: AppShadows.elevation1,
        shadowColor: AppShadows.shadowColorBase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        color: AppColors.surfaceCard,
        margin: EdgeInsets.zero,
      ),

      // -----------------------------------------------------------------------
      // INPUT DECORATION THEME (Text Fields)
      // -----------------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: AppColors.surfaceBackground,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPaddingHorizontal,
          vertical: AppSpacing.inputPaddingVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.borderDefault,
            width: AppSpacing.borderThin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.borderDefault,
            width: AppSpacing.borderThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.borderFocus,
            width: AppSpacing.borderMedium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.borderError,
            width: AppSpacing.borderThin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.borderError,
            width: AppSpacing.borderMedium,
          ),
        ),
        labelStyle: AppTypography.labelMedium,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.semanticError,
        ),
      ),

      // -----------------------------------------------------------------------
      // ELEVATED BUTTON THEME (Primary Actions)
      // -----------------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandPrimary,
          foregroundColor: AppColors.neutral0,
          disabledBackgroundColor: AppColors.surfaceDisabled,
          disabledForegroundColor: AppColors.textDisabled,
          elevation: AppShadows.elevation0,
          shadowColor: AppShadows.shadowColorBase,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          padding: const EdgeInsets.all(AppSpacing.spacing4),
          // padding: EdgeInsets.symmetric(
          //   horizontal: AppSpacing.buttonPaddingHorizontal,
          //   vertical: AppSpacing.buttonPaddingVertical,
          // ),
          minimumSize: Size(
            AppSpacing.touchTargetMinimum,
            AppSpacing.touchTargetMinimum,
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // -----------------------------------------------------------------------
      // TEXT BUTTON THEME (Secondary Actions)
      // -----------------------------------------------------------------------
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.linkMain,
          disabledForegroundColor: AppColors.textDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          padding: const EdgeInsets.all(AppSpacing.spacing4),
          // padding: EdgeInsets.symmetric(
          //   horizontal: AppSpacing.buttonPaddingHorizontal,
          //   vertical: AppSpacing.buttonPaddingVertical,
          // ),
          minimumSize: Size(
            AppSpacing.touchTargetMinimum,
            AppSpacing.touchTargetMinimum,
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // -----------------------------------------------------------------------
      // OUTLINED BUTTON THEME (Tertiary Actions)
      // -----------------------------------------------------------------------
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandPrimary,
          disabledForegroundColor: AppColors.textDisabled,
          side: BorderSide(
            color: AppColors.borderDefault,
            width: AppSpacing.borderThin,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          padding: const EdgeInsets.all(AppSpacing.spacing4),
          // padding: EdgeInsets.symmetric(
          //   horizontal: AppSpacing.buttonPaddingHorizontal,
          //   vertical: AppSpacing.buttonPaddingVertical,
          // ),
          minimumSize: Size(
            AppSpacing.touchTargetMinimum,
            AppSpacing.touchTargetMinimum,
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // -----------------------------------------------------------------------
      // ICON BUTTON THEME
      // -----------------------------------------------------------------------
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          disabledForegroundColor: AppColors.textDisabled,
          minimumSize: Size(
            AppSpacing.touchTargetMinimum,
            AppSpacing.touchTargetMinimum,
          ),
          iconSize: AppSpacing.iconSm,
        ),
      ),

      // -----------------------------------------------------------------------
      // DIALOG THEME (Modals)
      // -----------------------------------------------------------------------
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceBackground,
        elevation: AppShadows.elevation12,
        shadowColor: AppShadows.shadowColorBase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),

      // -----------------------------------------------------------------------
      // BOTTOM SHEET THEME
      // -----------------------------------------------------------------------
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceBackground,
        elevation: AppShadows.elevation8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
      ),

      // -----------------------------------------------------------------------
      // DIVIDER THEME
      // -----------------------------------------------------------------------
      dividerTheme: DividerThemeData(
        color: AppColors.borderDefault,
        thickness: AppSpacing.borderThin,
        space: AppSpacing.spacing2,
      ),

      // -----------------------------------------------------------------------
      // CHIP THEME
      // -----------------------------------------------------------------------
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceBackgroundAlt,
        disabledColor: AppColors.surfaceDisabled,
        selectedColor: AppColors.linkMain,
        secondarySelectedColor: AppColors.semanticSuccess,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing1_5,
          vertical: AppSpacing.spacing0_5,
        ),
        labelStyle: AppTypography.labelMedium,
        secondaryLabelStyle: AppTypography.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        elevation: AppShadows.elevation0,
      ),

      // -----------------------------------------------------------------------
      // TOOLTIP THEME
      // -----------------------------------------------------------------------
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.navBackground,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        textStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.textOnDark,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing1_5,
          vertical: AppSpacing.spacing1,
        ),
        waitDuration: Duration(milliseconds: 500),
      ),

      // -----------------------------------------------------------------------
      // SNACK BAR THEME
      // -----------------------------------------------------------------------
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.navBackground,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textOnDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppShadows.elevation8,
      ),

      // -----------------------------------------------------------------------
      // DATA TABLE THEME
      // -----------------------------------------------------------------------
      dataTableTheme: DataTableThemeData(
        headingTextStyle: AppTypography.tableHeader,
        dataTextStyle: AppTypography.tableCell,
        columnSpacing: AppSpacing.tableCellPaddingHorizontal * 2,
        horizontalMargin: AppSpacing.tableCellPaddingHorizontal,
        dividerThickness: AppSpacing.borderThin,
        headingRowColor:
            WidgetStateProperty.all(AppColors.surfaceBackgroundAlt),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.surfaceSelected;
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.surfaceHover;
          }
          return AppColors.surfaceBackground;
        }),
      ),

      // -----------------------------------------------------------------------
      // LIST TILE THEME
      // -----------------------------------------------------------------------
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2,
          vertical: AppSpacing.spacing1,
        ),
        minLeadingWidth: AppSpacing.iconMd,
        titleTextStyle: AppTypography.bodyMedium,
        subtitleTextStyle: AppTypography.bodySmall,
      ),

      // -----------------------------------------------------------------------
      // SWITCH THEME
      // -----------------------------------------------------------------------
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.semanticSuccess;
          }
          return AppColors.neutral300;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.semanticSuccessLight;
          }
          return AppColors.neutral200;
        }),
      ),

      // -----------------------------------------------------------------------
      // CHECKBOX THEME
      // -----------------------------------------------------------------------
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.linkMain;
          }
          return AppColors.surfaceBackground;
        }),
        checkColor: WidgetStateProperty.all(AppColors.neutral0),
        side: BorderSide(
          color: AppColors.borderDefault,
          width: AppSpacing.borderThin,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),

      // -----------------------------------------------------------------------
      // RADIO THEME
      // -----------------------------------------------------------------------
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.linkMain;
          }
          return AppColors.borderDefault;
        }),
      ),

      // -----------------------------------------------------------------------
      // PROGRESS INDICATOR THEME
      // -----------------------------------------------------------------------
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.linkMain,
        circularTrackColor: AppColors.neutral200,
        linearTrackColor: AppColors.neutral200,
      ),

      // -----------------------------------------------------------------------
      // SCAFFOLD BACKGROUND COLOR
      // -----------------------------------------------------------------------
      scaffoldBackgroundColor: AppColors.surfaceBackground,

      // -----------------------------------------------------------------------
      // FOCUS COLOR
      // -----------------------------------------------------------------------
      focusColor: AppColors.focusRing.withOpacity(0.2),
      hoverColor: AppColors.surfaceHover,
      highlightColor: AppColors.surfaceSelected,
    );
  }

  // ===========================================================================
  // GRADIENT HELPERS
  // ===========================================================================

  /// Primary Button Gradient (Brand Blue)
  ///
  /// Usage: For primary action buttons
  static LinearGradient get primaryButtonGradient => LinearGradient(
        colors: [
          AppColors.brandPrimary,
          AppColors.brandPrimaryLight,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Rainbow Outline Gradient (Key Sections Only)
  ///
  /// Usage: For highlighting network "hubs" (important/connected records)
  /// NOT for buttons (too playful for governance context)
  static LinearGradient get rainbowOutlineGradient => LinearGradient(
        colors: AppColors.rainbowGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
