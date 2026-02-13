import 'package:flutter/material.dart';

import 'app_color_scheme.dart';
import 'app_custom_colors.dart';
import 'chat_input_decoration.dart';
import 'destructive_elevated_button_style.dart';
import 'qr_scanner_theme.dart';
import 'rounded_input_decoration.dart';

// ----- Shared shape tokens / helpers -----
class AppShapes {
  // Your token: 8.0 corner radius
  static const Radius buttonCorner = Radius.circular(30);

  // Build the OutlinedBorder once and reuse it
  static const OutlinedBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(buttonCorner),
  );

  // (Optional) helper if you want to vary radius later:
  static OutlinedBorder rounded(double r) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(r));
}

class AppTheme {
  static final lightColorScheme = AppColorScheme.light;
  static final darkColorScheme = AppColorScheme.dark;
  static final _customColors = const AppCustomColors();

  static final light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Figtree',
    colorScheme: AppColorScheme.light,
    // surface colors already inform defaults; optionally set scaffold background:
    // scaffoldBackgroundColor: AppColorScheme.light.surface,
    scaffoldBackgroundColor: Colors.white,

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll<OutlinedBorder>(
          AppShapes.buttonShape,
        ),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(52)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade700;
          }
          return lightColorScheme.primary;
        }),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll<OutlinedBorder>(
          AppShapes.buttonShape,
        ),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(52)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade700;
          }
          return lightColorScheme.primary;
        }),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
      ),
    ),
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll<OutlinedBorder>(AppShapes.buttonShape),
      ),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll<OutlinedBorder>(AppShapes.buttonShape),
      ),
    ),

    // Input decoration theme for consistent text field styling
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade700.withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4F39F6), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: lightColorScheme.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: lightColorScheme.error, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // extensions: <ThemeExtension<dynamic>>[
    //   _customColors,
    //   QRScannerTheme(colorScheme: lightColorScheme),
    //   ChatInputDecoration(
    //     InputDecoration(
    //       hintMaxLines: 1,
    //       hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
    //       enabledBorder: OutlineInputBorder(
    //         borderSide: BorderSide(
    //           color: lightColorScheme.onSurface.withValues(alpha: 0.48),
    //           width: 0.5,
    //         ),
    //         borderRadius: BorderRadius.circular(32.0),
    //       ),
    //       focusedBorder: OutlineInputBorder(
    //         borderSide: BorderSide(color: lightColorScheme.primary, width: 1.0),
    //         borderRadius: BorderRadius.circular(32.0),
    //       ),
    //       disabledBorder: OutlineInputBorder(
    //         borderSide: BorderSide(
    //           color: lightColorScheme.onSurface.withValues(alpha: 0.48),
    //           width: 0.5,
    //         ),
    //         borderRadius: BorderRadius.circular(32.0),
    //       ),
    //       border: OutlineInputBorder(
    //         borderSide: BorderSide(
    //           color: lightColorScheme.onSurface.withValues(alpha: 0.48),
    //           width: 0.5,
    //         ),
    //         borderRadius: BorderRadius.circular(32.0),
    //       ),
    //       contentPadding: const EdgeInsets.symmetric(
    //         horizontal: 12,
    //         vertical: 0,
    //       ),
    //     ),
    //   ),
    //   RoundedInputDecoration(
    //     InputDecoration(
    //       border: _roundedInputDecorationBorder,
    //       focusedBorder: _roundedInputDecorationBorder,
    //       enabledBorder: _roundedInputDecorationBorder,
    //       errorBorder: _roundedInputDecorationBorder,
    //       disabledBorder: _roundedInputDecorationBorder,
    //       focusedErrorBorder: _roundedInputDecorationBorder,
    //       hintStyle: TextStyle(color: lightColorScheme.onSurfaceVariant),
    //     ),
    //   ),
    //   DestructiveElevatedButtonStyle(
    //     ButtonStyle(
    //       backgroundColor: WidgetStateProperty.resolveWith(
    //         (states) => states.contains(WidgetState.disabled)
    //             ? lightColorScheme.onSurface.withValues(alpha: 0.20)
    //             : lightColorScheme.errorContainer,
    //       ),
    //       foregroundColor: WidgetStateProperty.resolveWith(
    //         (states) => states.contains(WidgetState.disabled)
    //             ? lightColorScheme.onSurface.withValues(alpha: 0.60)
    //             : lightColorScheme.onErrorContainer,
    //       ),
    //       textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16)),
    //       padding: WidgetStateProperty.all(
    //         const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    //       ),
    //     ),
    //   ),
    // ],
    // textTheme: const TextTheme(
    //   bodyLarge: TextStyle(fontSize: 16),
    //   bodyMedium: TextStyle(fontSize: 14),
    //   bodySmall: TextStyle(fontSize: 10),
    //   headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //   headlineSmall: TextStyle(fontSize: 12),
    // ),
    // appBarTheme: const AppBarTheme(titleTextStyle: TextStyle(fontSize: 16)),
    // navigationBarTheme: NavigationBarThemeData(
    //   labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
    //     return TextStyle(
    //       color: (states.contains(WidgetState.selected))
    //           ? lightColorScheme.secondaryContainer
    //           : lightColorScheme.onSurface.withValues(alpha: 1 - 0.38),
    //       fontSize: 12,
    //     );
    //   }),
    //   indicatorColor: lightColorScheme.primary,
    //   backgroundColor: lightColorScheme.surface,
    // ),
    // iconTheme: IconThemeData(color: lightColorScheme.onSurfaceVariant),
    // inputDecorationTheme: InputDecorationTheme(
    //   filled: false,
    //   fillColor: Colors.transparent,
    //   border: InputBorder.none,
    //   focusedBorder: InputBorder.none,
    //   hintStyle: TextStyle(
    //     color: lightColorScheme.onSurfaceVariant.withAlpha(120),
    //     fontSize: 14,
    //   ),
    //   errorStyle: TextStyle(
    //     color: lightColorScheme.error,
    //     fontSize: 14,
    //     fontWeight: FontWeight.w600,
    //   ),
    //   errorMaxLines: 3,
    // ),
    // switchTheme: SwitchThemeData(
    //   thumbColor: WidgetStateProperty.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return lightColorScheme.primary;
    //     }
    //     return lightColorScheme.onSurfaceVariant;
    //   }),
    //   trackColor: WidgetStateProperty.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return lightColorScheme.primaryContainer;
    //     }
    //     return lightColorScheme.surfaceContainerHighest;
    //   }),
    // ),
    // listTileTheme: ListTileThemeData(
    //   selectedTileColor: lightColorScheme.primary,
    //   selectedColor: lightColorScheme.onPrimary,
    //   iconColor: lightColorScheme.primary,
    //   textColor: lightColorScheme.onSurface,
    //   subtitleTextStyle: const TextStyle(fontSize: 12),
    //   leadingAndTrailingTextStyle: const TextStyle(
    //     fontSize: 16,
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
    // datePickerTheme: DatePickerThemeData(
    //   backgroundColor: _customColors.grey900,
    //   headerBackgroundColor: lightColorScheme.primary.withValues(alpha: 0.90),
    //   headerForegroundColor: lightColorScheme.onPrimary,
    //   dayForegroundColor: WidgetStateProperty.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return lightColorScheme.onPrimary;
    //     }
    //     if (states.contains(WidgetState.disabled)) {
    //       return lightColorScheme.onSurface.withValues(alpha: 0.3);
    //     }
    //     return lightColorScheme.onSurface;
    //   }),
    //   cancelButtonStyle: ButtonStyle(
    //     textStyle: WidgetStateProperty.all(
    //       const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //     ),
    //   ),
    //   confirmButtonStyle: ButtonStyle(
    //     textStyle: WidgetStateProperty.all(
    //       const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //     ),
    //   ),
    // ),
    // timePickerTheme: TimePickerThemeData(
    //   backgroundColor: _customColors.grey900,
    //   dialBackgroundColor: Colors.grey[800],
    //   hourMinuteTextColor: lightColorScheme.onPrimary,
    //   hourMinuteColor: lightColorScheme.primary,
    //   dayPeriodTextColor: lightColorScheme.onPrimary,
    //   dayPeriodColor: lightColorScheme.primary,
    //   dayPeriodShape: const StadiumBorder(),
    //   helpTextStyle: TextStyle(
    //     color: lightColorScheme.onPrimary,
    //     fontWeight: FontWeight.bold,
    //     fontSize: 16,
    //   ),
    //   cancelButtonStyle: ButtonStyle(
    //     textStyle: WidgetStateProperty.all(
    //       const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //     ),
    //   ),
    //   confirmButtonStyle: ButtonStyle(
    //     textStyle: WidgetStateProperty.all(
    //       const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //     ),
    //   ),
    // ),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ButtonStyle(
    //     backgroundColor: WidgetStateProperty.resolveWith(
    //       (states) => states.contains(WidgetState.disabled)
    //           ? lightColorScheme.onSurface.withValues(alpha: 0.20)
    //           : lightColorScheme.primary,
    //     ),
    //     foregroundColor: WidgetStateProperty.resolveWith(
    //       (states) => states.contains(WidgetState.disabled)
    //           ? lightColorScheme.onSurface.withValues(alpha: 0.60)
    //           : lightColorScheme.onPrimary,
    //     ),
    //     textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16)),
    //     padding: WidgetStateProperty.all(
    //       const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    //     ),
    //     minimumSize: const WidgetStatePropertyAll(Size(100, 40)),
    //   ),
    // ),
    // tabBarTheme: TabBarThemeData(
    //   labelColor: lightColorScheme.onSurface,
    //   dividerColor: Colors.transparent,
    // ),
    // disabledColor: lightColorScheme.onSurface.withValues(alpha: 1 - 0.38),
    // chipTheme: ChipThemeData(
    //   backgroundColor: _customColors.success,
    //   labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
    //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //   brightness: Brightness.dark,
    //   side: BorderSide.none,
    // ),
    // textButtonTheme: TextButtonThemeData(
    //   style: TextButton.styleFrom(
    //     foregroundColor: lightColorScheme.primary,
    //     textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //   ),
    // ),
    // dividerTheme: DividerThemeData(
    //   color: _customColors.whiteOverlay30,
    //   thickness: 1,
    //   space: 0,
    //   indent: 0,
    //   endIndent: 0,
    // ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    fontFamily: 'Figtree',
    colorScheme: darkColorScheme,
    // surface colors already inform defaults; optionally set scaffold background:
    scaffoldBackgroundColor: AppColorScheme.dark.surface,
    // extensions: <ThemeExtension<dynamic>>[
    //   _customColors,
    //   QRScannerTheme(colorScheme: darkColorScheme),
    //   ChatInputDecoration(
    //     InputDecoration(
    //       hintMaxLines: 1,
    //       hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
    //       enabledBorder: OutlineInputBorder(
    //         borderSide: BorderSide(
    //           color: darkColorScheme.onSurface.withValues(alpha: 0.48),
    //           width: 0.5,
    //         ),
    //         borderRadius: BorderRadius.circular(32.0),
    //       ),
    //       focusedBorder: OutlineInputBorder(
    //         borderSide: BorderSide(color: darkColorScheme.primary, width: 1.0),
    //         borderRadius: BorderRadius.circular(32.0),
    //       ),
    //       disabledBorder: OutlineInputBorder(
    //         borderSide: BorderSide(
    //           color: darkColorScheme.onSurface.withValues(alpha: 0.48),
    //           width: 0.5,
    //         ),
    //         borderRadius: BorderRadius.circular(32.0),
    //       ),
    //       border: OutlineInputBorder(
    //         borderSide: BorderSide(
    //           color: darkColorScheme.onSurface.withValues(alpha: 0.48),
    //           width: 0.5,
    //         ),
    //         borderRadius: BorderRadius.circular(32.0),
    //       ),
    //       contentPadding: const EdgeInsets.symmetric(
    //         horizontal: 12,
    //         vertical: 0,
    //       ),
    //     ),
    //   ),
    //   RoundedInputDecoration(
    //     InputDecoration(
    //       border: _roundedInputDecorationBorder,
    //       focusedBorder: _roundedInputDecorationBorder,
    //       enabledBorder: _roundedInputDecorationBorder,
    //       errorBorder: _roundedInputDecorationBorder,
    //       disabledBorder: _roundedInputDecorationBorder,
    //       focusedErrorBorder: _roundedInputDecorationBorder,
    //       hintStyle: TextStyle(color: darkColorScheme.onSurfaceVariant),
    //     ),
    //   ),
    //   DestructiveElevatedButtonStyle(
    //     ButtonStyle(
    //       backgroundColor: WidgetStateProperty.resolveWith(
    //         (states) => states.contains(WidgetState.disabled)
    //             ? darkColorScheme.onSurface.withValues(alpha: 0.20)
    //             : darkColorScheme.errorContainer,
    //       ),
    //       foregroundColor: WidgetStateProperty.resolveWith(
    //         (states) => states.contains(WidgetState.disabled)
    //             ? darkColorScheme.onSurface.withValues(alpha: 0.60)
    //             : darkColorScheme.onErrorContainer,
    //       ),
    //       textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16)),
    //       padding: WidgetStateProperty.all(
    //         const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    //       ),
    //     ),
    //   ),
    // ],
    // textTheme: const TextTheme(
    //   bodyLarge: TextStyle(fontSize: 16),
    //   bodyMedium: TextStyle(fontSize: 14),
    //   bodySmall: TextStyle(fontSize: 10),
    //   headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //   headlineSmall: TextStyle(fontSize: 12),
    // ),
    // appBarTheme: const AppBarTheme(titleTextStyle: TextStyle(fontSize: 16)),
    // navigationBarTheme: NavigationBarThemeData(
    //   labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
    //     return TextStyle(
    //       color: (states.contains(WidgetState.selected))
    //           ? darkColorScheme.secondaryContainer
    //           : darkColorScheme.onSurface.withValues(alpha: 1 - 0.38),
    //       fontSize: 12,
    //     );
    //   }),
    //   indicatorColor: darkColorScheme.primary,
    //   backgroundColor: darkColorScheme.surface,
    // ),
    // iconTheme: IconThemeData(color: darkColorScheme.onSurfaceVariant),
    // inputDecorationTheme: InputDecorationTheme(
    //   filled: false,
    //   fillColor: Colors.transparent,
    //   border: InputBorder.none,
    //   focusedBorder: InputBorder.none,
    //   hintStyle: TextStyle(
    //     color: darkColorScheme.onSurfaceVariant.withAlpha(120),
    //     fontSize: 14,
    //   ),
    //   errorStyle: TextStyle(
    //     color: darkColorScheme.error,
    //     fontSize: 14,
    //     fontWeight: FontWeight.w600,
    //   ),
    //   errorMaxLines: 3,
    // ),
    // switchTheme: SwitchThemeData(
    //   thumbColor: WidgetStateProperty.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return darkColorScheme.primary;
    //     }
    //     return darkColorScheme.onSurfaceVariant;
    //   }),
    //   trackColor: WidgetStateProperty.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return darkColorScheme.primaryContainer;
    //     }
    //     return darkColorScheme.surfaceContainerHighest;
    //   }),
    // ),
    // listTileTheme: ListTileThemeData(
    //   selectedTileColor: darkColorScheme.primary,
    //   selectedColor: darkColorScheme.onPrimary,
    //   iconColor: darkColorScheme.primary,
    //   textColor: darkColorScheme.onSurface,
    //   subtitleTextStyle: const TextStyle(fontSize: 12),
    //   leadingAndTrailingTextStyle: const TextStyle(
    //     fontSize: 16,
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
    // datePickerTheme: DatePickerThemeData(
    //   backgroundColor: _customColors.grey900,
    //   headerBackgroundColor: darkColorScheme.primary.withValues(alpha: 0.90),
    //   headerForegroundColor: darkColorScheme.onPrimary,
    //   dayForegroundColor: WidgetStateProperty.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return darkColorScheme.onPrimary;
    //     }
    //     if (states.contains(WidgetState.disabled)) {
    //       return darkColorScheme.onSurface.withValues(alpha: 0.3);
    //     }
    //     return darkColorScheme.onSurface;
    //   }),
    //   cancelButtonStyle: ButtonStyle(
    //     textStyle: WidgetStateProperty.all(
    //       const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //     ),
    //   ),
    //   confirmButtonStyle: ButtonStyle(
    //     textStyle: WidgetStateProperty.all(
    //       const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //     ),
    //   ),
    // ),
    // timePickerTheme: TimePickerThemeData(
    //   backgroundColor: _customColors.grey900,
    //   dialBackgroundColor: Colors.grey[800],
    //   hourMinuteTextColor: darkColorScheme.onPrimary,
    //   hourMinuteColor: darkColorScheme.primary,
    //   dayPeriodTextColor: darkColorScheme.onPrimary,
    //   dayPeriodColor: darkColorScheme.primary,
    //   dayPeriodShape: const StadiumBorder(),
    //   helpTextStyle: TextStyle(
    //     color: darkColorScheme.onPrimary,
    //     fontWeight: FontWeight.bold,
    //     fontSize: 16,
    //   ),
    //   cancelButtonStyle: ButtonStyle(
    //     textStyle: WidgetStateProperty.all(
    //       const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //     ),
    //   ),
    //   confirmButtonStyle: ButtonStyle(
    //     textStyle: WidgetStateProperty.all(
    //       const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //     ),
    //   ),
    // ),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ButtonStyle(
    //     backgroundColor: WidgetStateProperty.resolveWith(
    //       (states) => states.contains(WidgetState.disabled)
    //           ? darkColorScheme.onSurface.withValues(alpha: 0.20)
    //           : darkColorScheme.primary,
    //     ),
    //     foregroundColor: WidgetStateProperty.resolveWith(
    //       (states) => states.contains(WidgetState.disabled)
    //           ? darkColorScheme.onSurface.withValues(alpha: 0.60)
    //           : darkColorScheme.onPrimary,
    //     ),
    //     textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16)),
    //     padding: WidgetStateProperty.all(
    //       const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    //     ),
    //     minimumSize: const WidgetStatePropertyAll(Size(100, 40)),
    //   ),
    // ),
    // tabBarTheme: TabBarThemeData(
    //   labelColor: darkColorScheme.onSurface,
    //   dividerColor: Colors.transparent,
    // ),
    // disabledColor: darkColorScheme.onSurface.withValues(alpha: 1 - 0.38),
    // chipTheme: ChipThemeData(
    //   backgroundColor: _customColors.success,
    //   labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
    //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //   brightness: Brightness.dark,
    //   side: BorderSide.none,
    // ),
    // textButtonTheme: TextButtonThemeData(
    //   style: TextButton.styleFrom(
    //     foregroundColor: darkColorScheme.primary,
    //     textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //   ),
    // ),
    // dividerTheme: DividerThemeData(
    //   color: _customColors.whiteOverlay30,
    //   thickness: 1,
    //   space: 0,
    //   indent: 0,
    //   endIndent: 0,
    // ),
  );
}
