# Debug Features

This directory contains debugging and development tools that are **NOT exposed in the production UI**.

## Theme Preview Screen

**Route**: `/debug/theme-preview`

A comprehensive design system preview screen that displays:

### Color System
- **ColorScheme**: Primary, Secondary, Tertiary, Error, Surface variants with on* colors
- **ColorTokens**: Design token swatches (Primary 500, Secondary 500, Verified, Pending, Failed states)

### Typography System
- All 12 Material TextTheme styles (Display, Headline, Title, Body, Label variants)
- Uses Figtree font family from TypographyTokens
- Shows actual rendered text samples

### Button States
- **Elevated Buttons**: Default, Hover/Focus, Disabled states
- **Text Buttons**: Default, Hover/Focus, Disabled states  
- **Outlined Buttons**: Default, Hover/Focus, Disabled states
- Demonstrates token-based spacing (lg horizontal, sm vertical) and radii (md)

### Component Themes
- **Cards**: Surface containers with elevation and rounded corners
- **Input Fields**: Label, Helper, Error, and Disabled states
- Shows InputDecorationTheme with proper typography mapping

### Token Examples
- **Spacing**: 8px grid system (spacing1 through spacing5)
- **Radii**: Border radius tokens (sm 4px, md 8px, lg 12px, xl 16px)
- **Elevation**: Material elevation levels (0, 1, 2, 3, 4, 6, 8, 12)

### Accessibility Note
Displays WCAG 2.1 compliance banner:
- All interactive elements meet 44x44px minimum touch target
- Text contrast ratios meet AA standards (4.5:1 normal, 3:1 large)

## How to Access

### During Development
Navigate directly to the route in your browser:
```
http://localhost:4000/debug/theme-preview
```

### From Code
Use `context.go()` or `context.push()`:
```dart
// Navigate to theme preview
context.go('/debug/theme-preview');

// Or push as overlay
context.push('/debug/theme-preview');
```

### For Testing
Useful for:
- Visual regression testing
- Design token validation
- Accessibility audits
- Component theme verification
- Before/after comparisons during refactoring

## Implementation Details

**File**: `lib/features/debug/presentation/screens/theme_preview_screen.dart`

**Dependencies**:
- All 5 design token extensions (ColorTokens, TypographyTokens, SpacingTokens, RadiiTokens, ElevationTokens)
- Material 3 ColorScheme
- Material TextTheme

**Layout**:
- Uses SpacingTokens for all padding/margins (no magic numbers)
- Responsive with SingleChildScrollView
- Organized into collapsible sections

## Production Build

To completely remove debug routes in production:

1. **Option A**: Use environment flags in `app_router.dart`:
```dart
routes: [
  // Production routes
  GoRoute(...),
  
  // Debug routes (only in debug mode)
  if (kDebugMode) ...[
    GoRoute(
      path: '/debug/theme-preview',
      builder: (context, state) => const ThemePreviewScreen(),
    ),
  ],
],
```

2. **Option B**: Use separate router configurations:
```dart
final debugRoutes = kDebugMode ? [
  GoRoute(path: '/debug/theme-preview', ...),
] : [];
```

## Future Debug Tools

Consider adding:
- Network inspector
- State debugger (Riverpod inspector)
- Performance profiler
- Accessibility checker
- Responsive breakpoint visualizer
