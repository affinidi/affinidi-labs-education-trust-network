# NovaCorp Verifier Portal - Design System Guide

**Version**: 2.0.0  
**Last Updated**: 2026-01-07

This guide explains how to consume design tokens, follow component theme conventions, and write consistent UI code in the NovaCorp Verifier Portal.

---

## Table of Contents

1. [Overview](#overview)
2. [Consuming Design Tokens](#consuming-design-tokens)
3. [Component Theme Conventions](#component-theme-conventions)
4. [Do's and Don'ts](#dos-and-donts)
5. [Common Patterns](#common-patterns)
6. [Resources](#resources)

---

## Overview

The NovaCorp design system uses **Material 3** with custom design tokens accessible via **ThemeExtensions**. All design values are centralized in:

- **Design Tokens**: [`design-language/03-design-tokens.yaml`](../../design-language/03-design-tokens.yaml)
- **Theme Implementation**: [`lib/core/design_system/themes/app_theme.dart`](lib/core/design_system/themes/app_theme.dart)
- **Token Classes**: [`lib/core/design_system/tokens/`](lib/core/design_system/tokens/)

**Golden Rule**: Never hard-code colors, spacing, typography, or other design values. Always reference tokens.

---

## Consuming Design Tokens

### Accessing Tokens via ThemeExtensions

Design tokens are exposed through Flutter's `ThemeExtension` system:

```dart
import 'package:flutter/material.dart';
import 'package:nova_corp_verifier/core/design_system/tokens/color_tokens.dart';
import 'package:nova_corp_verifier/core/design_system/tokens/typography_tokens.dart';
import 'package:nova_corp_verifier/core/design_system/tokens/spacing_tokens.dart';
import 'package:nova_corp_verifier/core/design_system/tokens/radii_tokens.dart';
import 'package:nova_corp_verifier/core/design_system/tokens/elevation_tokens.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access tokens via Theme.of(context)
    final colors = Theme.of(context).extension<ColorTokens>()!;
    final typography = Theme.of(context).extension<TypographyTokens>()!;
    final spacing = Theme.of(context).extension<SpacingTokens>()!;
    final radii = Theme.of(context).extension<RadiiTokens>()!;
    final elevation = Theme.of(context).extension<ElevationTokens>()!;
    
    return Container(
      padding: EdgeInsets.all(spacing.spacing3), // 24px
      decoration: BoxDecoration(
        color: colors.primary500,
        borderRadius: radii.borderMd, // 8px
      ),
      child: Text(
        'Hello World',
        style: typography.bodyLarge,
      ),
    );
  }
}
```

### Material Theme Properties vs. Token Extensions

Use **Material theme properties** for common UI elements, and **token extensions** for custom designs:

```dart
// ✅ GOOD: Use Material theme for standard components
Text(
  'Title',
  style: Theme.of(context).textTheme.titleLarge,
);

Container(
  color: Theme.of(context).colorScheme.primary,
);

// ✅ ALSO GOOD: Use tokens for custom/precise control
final colors = Theme.of(context).extension<ColorTokens>()!;
Container(
  color: colors.verifiedMain, // Semantic verification color
);

final typography = Theme.of(context).extension<TypographyTokens>()!;
Text(
  'Desktop Heading',
  style: typography.h1Desktop, // Responsive typography
);
```

---

## Component Theme Conventions

### Buttons

All buttons use token-based spacing, radii, and colors:

```dart
// ✅ GOOD: Use Material buttons (automatically styled)
ElevatedButton(
  onPressed: () {},
  child: Text('Submit'),
);

TextButton(
  onPressed: () {},
  child: Text('Cancel'),
);

OutlinedButton(
  onPressed: () {},
  child: Text('Learn More'),
);
```

**Button Theme Properties** (defined in `app_theme.dart`):
- **Padding**: Horizontal = `spacing4` (32px), Vertical = `spacing1` (8px)
- **Shape**: `RadiiTokens.md` (8px border radius)
- **Min Size**: 64x40 (meets WCAG 44x44 minimum)
- **States**: Focus/hover/pressed use token-based opacity overlays (8%, 12%, 24%)

### Cards

Cards use surface containers with proper elevation:

```dart
// ✅ GOOD: Use Material Card (automatically styled)
Card(
  child: Padding(
    padding: EdgeInsets.all(
      Theme.of(context).extension<SpacingTokens>()!.spacing3,
    ),
    child: Column(
      children: [
        Text('Card Title', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: spacing.spacing2),
        Text('Card content...'),
      ],
    ),
  ),
);
```

**Card Theme Properties**:
- **Background**: `colorScheme.surfaceContainerHighest`
- **Shape**: `RadiiTokens.md` (8px)
- **Elevation**: `ElevationTokens.level2`
- **Margin**: `spacing2` (16px)

### Input Fields

Input fields use typography tokens for labels, helpers, and errors:

```dart
// ✅ GOOD: Use TextField (automatically styled)
TextField(
  decoration: InputDecoration(
    labelText: 'Email Address',
    helperText: 'We'll never share your email',
    prefixIcon: Icon(Icons.email),
  ),
);

// ✅ GOOD: Error state
TextField(
  decoration: InputDecoration(
    labelText: 'Password',
    errorText: 'Password must be at least 8 characters',
  ),
);
```

**Input Theme Properties**:
- **Label**: `typography.bodyMedium`
- **Helper/Error**: `typography.bodySmall`
- **Border Radius**: `RadiiTokens.md` (8px)
- **Focused Border**: `colorScheme.primary` with 2px width
- **Error Border**: `colorScheme.error`
- **Padding**: `spacing2` (16px)

### AppBar

AppBar uses surface colors and title typography:

```dart
// ✅ GOOD: Use AppBar (automatically styled)
AppBar(
  title: Text('Page Title'),
  centerTitle: true,
  actions: [
    IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {},
    ),
  ],
);
```

**AppBar Theme Properties**:
- **Background**: `colorScheme.surface`
- **Foreground**: `colorScheme.onSurface`
- **Title Style**: `typography.h4` (mapped to `textTheme.titleLarge`)
- **Elevation**: `ElevationTokens.level0` (flat)

---

## Do's and Don'ts

### ✅ DO: Use Theme Properties

```dart
// ✅ Colors from ColorScheme
Container(
  color: Theme.of(context).colorScheme.primary,
);

// ✅ Typography from TextTheme
Text(
  'Hello',
  style: Theme.of(context).textTheme.bodyLarge,
);

// ✅ Icon size from IconTheme
Icon(
  Icons.check,
  size: Theme.of(context).iconTheme.size, // 24.0
);
```

### ❌ DON'T: Hard-Code Values

```dart
// ❌ Hard-coded color
Container(
  color: Color(0xFF9C27B0), // BAD!
);

// ❌ Hard-coded spacing
Padding(
  padding: EdgeInsets.all(24), // BAD!
);

// ❌ Hard-coded typography
Text(
  'Hello',
  style: TextStyle(
    fontSize: 16, // BAD!
    fontWeight: FontWeight.w400,
  ),
);
```

### ✅ DO: Use Token Extensions for Custom Needs

```dart
// ✅ Semantic verification colors
final colors = Theme.of(context).extension<ColorTokens>()!;
Container(
  color: colors.verifiedMain, // Green for verified state
);

// ✅ Responsive typography
final typography = Theme.of(context).extension<TypographyTokens>()!;
Text(
  'Desktop Title',
  style: typography.h1Desktop, // 48px on desktop
);

// ✅ 8px grid spacing
final spacing = Theme.of(context).extension<SpacingTokens>()!;
SizedBox(height: spacing.spacing3); // 24px
```

### ❌ DON'T: Use Material Colors Directly

```dart
// ❌ Using Colors.purple directly
Container(
  color: Colors.purple, // BAD! Use colorScheme.primary
);

// ❌ Using Colors.grey for text
Text(
  'Subtitle',
  style: TextStyle(color: Colors.grey), // BAD! Use onSurfaceVariant
);
```

### ✅ DO: Use Proper Contrast Colors

```dart
// ✅ Automatic contrast with ColorScheme
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Button Text',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimary, // White on purple
    ),
  ),
);

// ✅ Surface variants with proper on* colors
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Content',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface, // Proper contrast
    ),
  ),
);
```

### ❌ DON'T: Ignore WCAG Contrast Requirements

```dart
// ❌ Poor contrast (fails WCAG AA)
Container(
  color: Colors.grey[300],
  child: Text(
    'Hard to read',
    style: TextStyle(color: Colors.grey[400]), // BAD! Low contrast
  ),
);
```

---

## Common Patterns

### Pattern 1: Responsive Layout with Spacing Tokens

```dart
class ResponsiveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<SpacingTokens>()!;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(spacing.spacing3), // 24px
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: spacing.spacing2), // 16px
            Text('Description', style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: spacing.spacing3), // 24px
            ElevatedButton(
              onPressed: () {},
              child: Text('Action'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Pattern 2: Status Badge with Semantic Colors

```dart
class StatusBadge extends StatelessWidget {
  final String status; // 'verified', 'pending', 'failed'
  
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ColorTokens>()!;
    final spacing = Theme.of(context).extension<SpacingTokens>()!;
    final radii = Theme.of(context).extension<RadiiTokens>()!;
    
    final badgeColor = switch (status) {
      'verified' => colors.verifiedMain,
      'pending' => colors.pendingMain,
      'failed' => colors.failedMain,
      _ => Theme.of(context).colorScheme.surface,
    };
    
    final textColor = switch (status) {
      'verified' => colors.verifiedContrast,
      'pending' => colors.pendingContrast,
      'failed' => colors.failedContrast,
      _ => Theme.of(context).colorScheme.onSurface,
    };
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.spacing2, // 16px
        vertical: spacing.spacing1 / 2, // 4px
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: radii.borderFull, // Pill shape
      ),
      child: Text(
        status.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
```

### Pattern 3: Custom Container with Elevation

```dart
class ElevatedContainer extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<SpacingTokens>()!;
    final radii = Theme.of(context).extension<RadiiTokens>()!;
    final elevation = Theme.of(context).extension<ElevationTokens>()!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Material(
      elevation: elevation.level4, // 4dp elevation
      borderRadius: radii.borderLg, // 12px
      color: colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: EdgeInsets.all(spacing.spacing3),
        child: child,
      ),
    );
  }
}
```

### Pattern 4: Accessible Touch Targets

```dart
// ✅ GOOD: Meets 44x44 minimum (WCAG 2.1)
class AccessibleIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 44, // Minimum touch target
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, size: 24),
        ),
      ),
    );
  }
}

// ❌ BAD: Too small (fails WCAG)
IconButton(
  iconSize: 16, // BAD! Below 24px minimum
  constraints: BoxConstraints(minWidth: 32, minHeight: 32), // BAD! Below 44x44
  onPressed: () {},
  icon: Icon(Icons.close),
);
```

---

## Resources

### Key Files

| File | Purpose |
|------|---------|
| [`app_theme.dart`](lib/core/design_system/themes/app_theme.dart) | Theme configuration with Material 3 ColorScheme and component themes |
| [`color_tokens.dart`](lib/core/design_system/tokens/color_tokens.dart) | Color system (primary, secondary, semantic, surface colors) |
| [`typography_tokens.dart`](lib/core/design_system/tokens/typography_tokens.dart) | Typography scale (Figtree font, sizes, weights, styles) |
| [`spacing_tokens.dart`](lib/core/design_system/tokens/spacing_tokens.dart) | 8px grid spacing system (spacing0 through spacing16) |
| [`radii_tokens.dart`](lib/core/design_system/tokens/radii_tokens.dart) | Border radius values (sm 4px, md 8px, lg 12px, xl 16px) |
| [`elevation_tokens.dart`](lib/core/design_system/tokens/elevation_tokens.dart) | Material elevation levels (0-24) |

### Design System Preview

Navigate to `/debug/theme-preview` to see all tokens and component themes in action:

**URL**: http://localhost:4000/debug/theme-preview

**Features**:
- ColorScheme and ColorTokens swatches
- Typography samples for all TextTheme styles
- Button states (default, hover, focus, disabled)
- Card and input field examples
- Spacing, radii, and elevation visualizations
- WCAG accessibility compliance notes

**Documentation**: [`lib/features/debug/README.md`](lib/features/debug/README.md)

### External References

- **Material 3 Design**: https://m3.material.io/
- **WCAG 2.1 Guidelines**: https://www.w3.org/WAI/WCAG21/quickref/
- **Flutter ThemeExtension**: https://api.flutter.dev/flutter/material/ThemeExtension-class.html
- **NovaCorp Brand Guidelines**: [`design-language/02-art-direction.md`](../../design-language/02-art-direction.md)

---

## Quick Reference

### Spacing Scale (8px Grid)

```dart
spacing0  = 0px    // No spacing
spacing1  = 8px    // Micro spacing
spacing2  = 16px   // Small spacing (most common)
spacing3  = 24px   // Medium spacing
spacing4  = 32px   // Large spacing
spacing5  = 40px   // XL spacing
spacing6  = 48px   // 2XL spacing
spacing8  = 64px   // 3XL spacing
spacing10 = 80px   // 4XL spacing
spacing12 = 96px   // 5XL spacing
spacing16 = 128px  // 6XL spacing
```

### Border Radius

```dart
none = 0px      // Sharp corners
sm   = 4px      // Subtle rounding
md   = 8px      // Default (buttons, cards, inputs)
lg   = 12px     // Large containers
xl   = 16px     // Prominent rounding
2xl  = 24px     // Very rounded
3xl  = 30px     // Pills
full = 9999px   // Perfect circles
```

### Elevation Levels

```dart
level0  = 0dp   // Flat (AppBar)
level1  = 1dp   // Raised
level2  = 2dp   // Cards, Buttons
level3  = 3dp   // Elevated
level4  = 4dp   // High
level6  = 6dp   // SnackBar
level8  = 8dp   // Navigation
level12 = 12dp  // FAB
level16 = 16dp  // Modal
level24 = 24dp  // Dialog
```

### ColorScheme Quick Access

```dart
// Primary
colorScheme.primary              // Purple #9C27B0
colorScheme.onPrimary            // White on purple
colorScheme.primaryContainer     // Light purple container
colorScheme.onPrimaryContainer   // Dark purple text

// Secondary
colorScheme.secondary            // Cyan #00BCD4
colorScheme.onSecondary          // Black on cyan
colorScheme.secondaryContainer   // Light cyan container
colorScheme.onSecondaryContainer // Dark cyan text

// Surface
colorScheme.surface              // Base surface
colorScheme.onSurface            // Text on surface
colorScheme.surfaceContainerHighest // Elevated surface

// Error
colorScheme.error                // Red for errors
colorScheme.onError              // White on red
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2026-01-07 | Complete design system with Material 3, tokens, and component themes |
| 1.0.0 | 2025-12-15 | Initial implementation |

---

**Questions?** Check the [design system preview screen](/debug/theme-preview) or review [`app_theme.dart`](lib/core/design_system/themes/app_theme.dart) for implementation details.
