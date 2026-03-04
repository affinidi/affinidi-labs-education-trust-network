# Flutter Theme Configuration

**Document Version**: 1.0.0  
**Last Updated**: January 6, 2026

---

## Overview

This document provides the complete Flutter ThemeData configuration for Nexigen, mapping all design tokens from `03-design-tokens.yaml` to Flutter's Material 3 system (`ColorScheme`, `TextTheme`, component themes). Focus on **light mode** with warm orange (#FF8E32) primary and warm cream (#FFEEC8) secondary, per Headspace + Revolut design principles.

**Token-to-Flutter Mapping**:
- `colors.primary.500` (#FF8E32) → `ColorScheme.primary` — Warm orange for key CTAs like "Claim Credential"
- `colors.secondary.300` (#FFEEC8) → `ColorScheme.surface` — Warm cream for cards and backgrounds
- `colors.text.light.primary` (#1E1E1E) → `ColorScheme.onSurface` — Dark text on light surfaces
- `colors.surface.light.background` (#FFFDF7) → App background — Warm off-white

**Example: Claim Credential Screen**
```dart
// "Claim Credential" CTA button uses:
ElevatedButton(
  onPressed: () => _claimCredential(),
  child: const Text('Claim Credential'),
  // backgroundColor: colors.primary.500 (#FF8E32) via ColorScheme.primary
  // padding: spacing.4/18px (buttonLarge) via theme
  // height: 56px (touchTarget.comfortable) via minimumSize
  // font: fontSize.lg (18px), fontWeight.medium via TextTheme
)
```

---

## Complete Theme Implementation

### File Structure

```
lib/core/design_system/
├── themes/
│   ├── app_theme.dart           # Main theme configuration
│   ├── app_colors.dart           # Color constants
│   ├── app_spacing.dart          # Spacing constants
│   ├── app_radius.dart           # Border radius constants
│   ├── app_text_styles.dart      # Typography constants
│   └── app_custom_colors.dart    # Extended color palette
```

---

## 1. App Colors (app_colors.dart)

```dart
import 'package:flutter/material.dart';

/// Design token: colors.primary.*
class AppColors {
  AppColors._(); // Private constructor - prevent instantiation

  // Primary Colors (Warm Orange - Approachable, Energetic, Educational)
  static const Color primary50 = Color(0xFFFFF6E1);
  static const Color primary100 = Color(0xFFFFEEC8);
  static const Color primary200 = Color(0xFFFFCF9F);
  static const Color primary300 = Color(0xFFFFB166);
  static const Color primary400 = Color(0xFFFFAA4A);
  static const Color primary500 = Color(0xFFFF8E32); // Main brand (warm orange) - "Claim Credential" CTA
  static const Color primary600 = Color(0xFFE67E28); // Hover state
  static const Color primary700 = Color(0xFFD56E1F); // Pressed state
  static const Color primary800 = Color(0xFFBD5E15);
  static const Color primary900 = Color(0xFFA04E0C);

  // Secondary Colors (Warm Cream - Supporting, Informative, Friendly)
  static const Color secondary50 = Color(0xFFFFFDF7);
  static const Color secondary100 = Color(0xFFFFFFBF7);
  static const Color secondary200 = Color(0xFFFFF6E1);
  static const Color secondary300 = Color(0xFFFFEEC8); // Warm cream - card backgrounds (Home screen)
  static const Color secondary400 = Color(0xFFFFE8B3);
  static const Color secondary500 = Color(0xFFFFDC99); // Secondary brand (warm cream)
  static const Color secondary600 = Color(0xFFF2D9A6);
  static const Color secondary700 = Color(0xFFE5C98F);
  static const Color secondary800 = Color(0xFFD8BA7A);
  static const Color secondary900 = Color(0xFFCBAA66);

  // Neutral Colors (Grays)
  static const Color neutral0 = Color(0xFFFFFFFF);    // White
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF636363);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121); // Dark gray
  static const Color neutral950 = Color(0xFF0A0A0A);
  static const Color neutral1000 = Color(0xFF000000); // Black
  
  // Text Colors (Light Mode - Primary)
  static const Color textLightPrimary = Color(0xFF1E1E1E);     // colors.text.light.primary (dark near-black)
  static const Color textLightSecondary = Color(0xFF4A4A4A);   // colors.text.light.secondary
  static const Color textLightDisabled = Color(0xFF9E9E9E);    // colors.text.light.disabled
  
  // Surface Colors (Light Mode - Primary)
  static const Color surfaceLightBackground = Color(0xFFFFFDF7); // colors.surface.light.background
  static const Color surfaceLightSurface = Color(0xFFFFEEC8);     // colors.surface.light.surface (secondary.300)

  // Semantic Colors
  static const Color successLight = Color(0xFF81C784);
  static const Color successMain = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF388E3C);

  static const Color warningLight = Color(0xFFFFD54F);
  static const Color warningMain = Color(0xFFD99A06);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color errorLight = Color(0xFFE57373);
  static const Color errorMain = Color(0xFFF44336);
  static const Color errorDark = Color(0xFFD32F2F);

  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoMain = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF1976D2);

  // Extended Colors
  static const Color cyan = Color(0xFF00BCD4);
  static const Color purple = Color(0xFF9C27B0);
  static const Color rose = Color(0xFFD31F82);
  static const Color violet = Color(0xFFB81FD3);
  static const Color brown = Color(0xFF795548);
  static const Color orange = Color(0xFFFF9800);
}
```

---

## 2. App Spacing (app_spacing.dart)

```dart
/// Design token: spacing.*
class AppSpacing {
  AppSpacing._();

  static const double spacing0 = 0;
  static const double spacing1 = 8.0;   // Micro spacing
  static const double spacing2 = 16.0;  // Standard padding (most common)
  static const double spacing3 = 24.0;  // Medium spacing
  static const double spacing4 = 32.0;  // Large spacing
  static const double spacing5 = 40.0;
  static const double spacing6 = 48.0;
  static const double spacing8 = 64.0;
  static const double spacing10 = 80.0;
  static const double spacing12 = 96.0;
  static const double spacing16 = 128.0;
}
```

---

## 3. App Radius (app_radius.dart)

```dart
/// Design token: radius.*
class AppRadius {
  AppRadius._();

  static const double none = 0;
  static const double sm = 4.0;
  static const double md = 8.0;    // Default for most elements
  static const double lg = 12.0;   // Cards, large containers
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const double xxxl = 30.0; // Pills, rounded inputs
  static const double full = 9999.0; // Perfect circles

  // Convenience BorderRadius objects
  static BorderRadius borderSm = BorderRadius.circular(sm);
  static BorderRadius borderMd = BorderRadius.circular(md);
  static BorderRadius borderLg = BorderRadius.circular(lg);
  static BorderRadius borderXl = BorderRadius.circular(xl);
  static BorderRadius borderXxl = BorderRadius.circular(xxl);
  static BorderRadius borderXxxl = BorderRadius.circular(xxxl);
  static BorderRadius borderFull = BorderRadius.circular(full);
}
```

---

## 4. App Theme (app_theme.dart)

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_radius.dart';

class AppTheme {
  AppTheme._();

  // ===========================================================================
  // LIGHT THEME (Default - Warm Orange/Cream Palette)
  // ===========================================================================
  
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      // Primary: warm orange for key CTAs (Claim Credential, etc.)
      primary: AppColors.primary500,              // #FF8E32
      primaryContainer: AppColors.primary100,    // #FFEEC8
      onPrimary: AppColors.neutral0,              // #FFFFFF white text
      onPrimaryContainer: AppColors.primary700,  // #D56E1F
      
      // Secondary: warm cream for supporting elements
      secondary: AppColors.secondary300,          // #FFEEC8 warm cream
      secondaryContainer: AppColors.secondary100,
      onSecondary: AppColors.neutral1000,         // Dark text
      onSecondaryContainer: AppColors.secondary700,
      
      // Surface: light mode warm cream background (Home screen cards)
      surface: AppColors.secondary300,            // #FFEEC8 warm cream (card background)
      surfaceContainerHighest: AppColors.neutral0,
      onSurface: AppColors.textLightPrimary,      // #1E1E1E dark text
      onSurfaceVariant: AppColors.textLightSecondary,  // #4A4A4A mid-gray
      
      // Semantic colors
      error: AppColors.errorMain,                 // #F44336
      errorContainer: AppColors.errorLight,      // #E57373
      onError: AppColors.neutral0,
      onErrorContainer: AppColors.errorDark,
      
      // Background: warm off-white
      background: Color(0xFFFFFDF7),             // colors.surface.light.background
      onBackground: AppColors.textLightPrimary,  // #1E1E1E
      
      // Outline: borders
      outline: AppColors.neutral300,              // #E0E0E0
      outlineVariant: AppColors.neutral200,
      
      // Other
      shadow: AppColors.neutral900,
      scrim: AppColors.neutral1000.withOpacity(0.5),
      inverseSurface: AppColors.neutral900,
      onInverseSurface: AppColors.neutral0,
      inversePrimary: AppColors.primary300,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      
      // Typography
      fontFamily: 'IBM Plex Sans',
      textTheme: _textTheme,
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFFFFDF7),       // Warm off-white background
        foregroundColor: AppColors.textLightPrimary,  // Dark text
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontFamily: 'IBM Plex Sans',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1E1E1E),
        ),
      ),
      
      // Card (warm cream, light elevation)
      cardTheme: CardTheme(
        elevation: 1,                              // elevation.1 (Headspace-inspired)
        color: AppColors.secondary300,             // #FFEEC8 warm cream
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderLg,       // 12px (radius.lg)
        ),
      ),
      
      // Elevated Button (warm orange "Claim Credential" CTA, 56px height)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,          // #FF8E32 warm orange
          foregroundColor: AppColors.neutral0,            // #FFFFFF white text
          disabledBackgroundColor: AppColors.neutral500.withOpacity(0.2),
          disabledForegroundColor: AppColors.textLightDisabled,  // #9E9E9E
          elevation: 2,                                    // elevation.2
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing4,              // 32px (spacing.4)
            vertical: 18,                                  // CTA vertical emphasis
          ),
          minimumSize: const Size(64, 56),                // touchTarget.comfortable
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderMd,             // 8px (radius.md)
          ),
          textStyle: const TextStyle(
            fontSize: 18,                                  // fontSize.lg
            fontWeight: FontWeight.w500,                  // fontWeight.medium
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Input Decoration (warm cream #FFEEC8, warm orange #FF8E32 focus)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondary300,                // #FFEEC8 warm cream
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2,                // 16px (spacing.2)
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,               // 8px (radius.md)
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),                     // colors.neutral.300
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(
            color: AppColors.primary500,                  // #FF8E32 warm orange focus
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(
            color: AppColors.errorMain,                   // #F44336
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(
            color: AppColors.errorMain,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(
            color: Color(0xFFE0E0E0).withOpacity(0.48),
            width: 1,
          ),
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFF4A4A4A),                       // colors.text.light.secondary
        ),
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFF4A4A4A),
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          color: AppColors.errorLight,
        ),
      ),
      
      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.primary500,          // Warm orange icons
          minimumSize: const Size(48, 48),                // Touch target
        ),
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutral900,
        contentTextStyle: const TextStyle(color: AppColors.neutral0),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderMd,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor: Color(0xFFFFFDF7),       // Warm off-white
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderLg,
        ),
      ),
    );
  }

  // ===========================================================================
  // DARK THEME (Alternative - Minimal shadows, warm accent)
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2, // 16px
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderMd, // 8px
          borderSide: const BorderSide(color: AppColors.neutral700, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.neutral700, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.primary500, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.errorMain, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.errorMain, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(
            color: AppColors.neutral800.withOpacity(0.5),
            width: 1,
          ),
        ),
        labelStyle: const TextStyle(fontSize: 16, color: AppColors.neutral700),
        hintStyle: const TextStyle(fontSize: 16, color: AppColors.neutral700),
        errorStyle: const TextStyle(fontSize: 12, color: AppColors.errorLight),
      ),
      
      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.neutral0,
          minimumSize: const Size(48, 48), // Touch target
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.neutral1000,
        selectedItemColor: AppColors.primary500,
        unselectedItemColor: AppColors.neutral700,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutral900,
        contentTextStyle: const TextStyle(color: AppColors.neutral0),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderMd,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.neutral900,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderLg, // 12px
        ),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.neutral700.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.neutral900,
        selectedColor: AppColors.primary500,
        disabledColor: AppColors.neutral800,
        labelStyle: const TextStyle(fontSize: 14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderFull,
        ),
      ),
    );
  }

  // ===========================================================================
  // TEXT THEME (Typography mapping from 03-design-tokens.yaml)
  // ===========================================================================
  
  static const TextTheme _textTheme = TextTheme(
    // Display (Hero text - fontSize.6xl)
    displayLarge: TextStyle(
      fontSize: 48,                              // fontSize.6xl
      fontWeight: FontWeight.w700,               // fontWeight.bold
      height: 1.2,                               // lineHeight.tight
      letterSpacing: -0.96,
    ),
    
    // H1 (displayMedium: fontSize.5xl)
    displayMedium: TextStyle(
      fontSize: 36,                              // fontSize.5xl
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.72,
    ),
    displaySmall: TextStyle(
      fontSize: 28,                              // fontSize.3xl
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.56,
    ),
    
    // H2 (headlineLarge: fontSize.2xl)
    headlineLarge: TextStyle(
      fontSize: 24,                              // fontSize.2xl
      fontWeight: FontWeight.w700,               // fontWeight.bold
      height: 1.2,
    ),
    
    // H3 (headlineMedium: fontSize.xl)
    headlineMedium: TextStyle(
      fontSize: 20,                              // fontSize.xl (card titles)
      fontWeight: FontWeight.w600,               // fontWeight.semibold
      height: 1.5,                               // lineHeight.normal
    ),
    
    // Subheading (titleLarge: fontSize.lg)
    titleLarge: TextStyle(
      fontSize: 18,                              // fontSize.lg
      fontWeight: FontWeight.w600,               // fontWeight.semibold
      height: 1.5,
    ),
    titleMedium: TextStyle(
      fontSize: 16,                              // fontSize.md
      fontWeight: FontWeight.w500,               // fontWeight.medium
      height: 1.5,
    ),
    titleSmall: TextStyle(
      fontSize: 14,                              // fontSize.base
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    
    // Body Large (Primary body text - fontSize.md)
    bodyLarge: TextStyle(
      fontSize: 16,                              // fontSize.md (minimum readability)
      fontWeight: FontWeight.w400,               // fontWeight.regular
      height: 1.5,                               // lineHeight.normal
    ),
    
    // Body Medium (Secondary body text - fontSize.base)
    bodyMedium: TextStyle(
      fontSize: 14,                              // fontSize.base
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    
    // Small text/Captions (fontSize.sm)
    bodySmall: TextStyle(
      fontSize: 12,                              // fontSize.sm
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    
    // Labels (interactive elements - fontSize.base to sm)
    labelLarge: TextStyle(
      fontSize: 14,                              // fontSize.base
      fontWeight: FontWeight.w500,               // fontWeight.medium
      letterSpacing: 0.7,                        // letterSpacing.wide
    ),
    labelMedium: TextStyle(
      fontSize: 12,                              // fontSize.sm
      fontWeight: FontWeight.w500,
      letterSpacing: 0.6,
    ),
    labelSmall: TextStyle(
      fontSize: 10,                              // fontSize.xs
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );
}
```

---

## 5. Usage in Main App

```dart
import 'package:flutter/material.dart';
import 'core/design_system/themes/app_theme.dart';

void main() {
  runApp(const NexigenApp());
}

class NexigenApp extends StatelessWidget {
  const NexigenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexigen',
      
      // Apply themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark mode
      
      // Accessibility
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Ensure text scale factor is reasonable
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.5),
          ),
          child: child!,
        );
      },
      
      home: const HomePage(),
    );
  }
}
```

---

## 6. Accessing Theme Values

```dart
// In any widget build method

// Get the theme
final theme = Theme.of(context);

// Use color scheme
Container(
  color: theme.colorScheme.primary,
  child: Text(
    'Hello',
    style: theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onPrimary,
    ),
  ),
)

// Or use direct color constants
Container(
  color: AppColors.primary500,
  padding: EdgeInsets.all(AppSpacing.spacing2),
  decoration: BoxDecoration(
    borderRadius: AppRadius.borderMd,
  ),
)
```

---

## 7. Custom Colors Extension

For semantic colors not in ColorScheme:

```dart
// app_custom_colors.dart
import 'package:flutter/material.dart';

@immutable
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  const AppCustomColors({
    this.success = AppColors.successMain,
    this.warning = AppColors.warningMain,
    this.info = AppColors.infoMain,
  });

  final Color success;
  final Color warning;
  final Color info;

  @override
  AppCustomColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return AppCustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  AppCustomColors lerp(AppCustomColors? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

// Add to theme
extensions: <ThemeExtension<dynamic>>[
  const AppCustomColors(),
],

// Usage
final customColors = Theme.of(context).extension<AppCustomColors>()!;
Icon(Icons.check, color: customColors.success);
```

---

## Summary

This Flutter theme configuration provides:

- ✅ Complete Material 3 ThemeData for light and dark modes
- ✅ All design tokens mapped to Flutter constants
- ✅ Comprehensive component theming (buttons, inputs, cards, etc.)
- ✅ Typography system with proper hierarchy
- ✅ Accessibility-compliant touch targets and contrast ratios
- ✅ Custom color extensions for semantic colors

**Next Steps**:
1. Copy theme files to your project's `lib/core/design_system/themes/` directory
2. Import IBM Plex Sans font family (add to `pubspec.yaml`)
3. Apply theme in `MaterialApp`
4. Use `Theme.of(context)` or direct constants to access values

**Never hardcode values** - always reference theme or token constants.
