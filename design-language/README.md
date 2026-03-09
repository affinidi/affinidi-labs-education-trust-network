# Student Vault App Design System

> **⚠️ PROTOTYPE/REFERENCE IMPLEMENTATION**  
> This design system is part of a prototype/demo project developed for demonstration and educational purposes only. It is **not a production-ready product** from Affinidi.

**Version**: 1.0.0  
**Last Updated**: January 7, 2026  
**Status**: Reference Implementation

---

## Overview

The **Student Vault App Design System** is the single source of truth for the Student Vault mobile app UI. This system ensures consistency, accessibility, and efficiency in building the credential wallet experience.

### Platform Context

Credulon operates a trust registry system enabling collaboration with National Education Governors (Ministries) across multiple jurisdictions. The platform maintains public lists of trusted universities authorized to issue degree certificates, demonstrating end-to-end verifiable credential flows.

**Target Jurisdictions**: Hong Kong, Macau, Singapore

**Key Stakeholders**:

- **Students**: Credential holders receiving, storing, and sharing university credentials
- **Universities**: Authorized credential issuers
- **Employers**: Credential verifiers

### Purpose

This design system serves to:

- **Ensure visual consistency** across Student Vault mobile app
- **Accelerate development** by providing reusable components and patterns
- **Maintain accessibility** standards (WCAG 2.1 AA minimum)
- **Enable scalability** through tokenized design values
- **Guide consistent implementation** with clear design tokens and patterns

---

## Document Structure

### Design Documentation (Recommended Reading Order)

1. **[Design Philosophy](01-design-philosophy.md)** - Principles, purpose, and objectives
2. **[Art Direction](02-art-direction.md)** - Visual style, mood, and tone
3. **[Design Tokens](03-design-tokens.yaml)** - Foundational values (colors, spacing, typography)
4. **[UI Style Guide](04-ui-style-guide.md)** - Color, typography, spacing, and motion
5. **[Components](05-components.md)** - Comprehensive component library
6. **[Accessibility](06-accessibility.md)** - WCAG compliance and inclusive design
7. **[Flutter Theme](07-flutter-theme.md)** - Complete ThemeData implementation
8. **[Quick Reference](08-quick-reference.md)** - Common patterns and decision trees

### Inspiration & Reference

- **[High‑Fi Wireframes](inspiration/high-fi-wireframes/)** - Primary source of truth for UI layouts
- **[Moodboard](inspiration/moodboard/)** - Design inspiration (Headspace colors, Revolut organisation)
- **[Version History](version-history.md)** - Change log and migration guides

---

## Quick Start

### For Developers

1. **Start with tokens**: [Design Tokens](03-design-tokens.yaml) are the foundation
2. **Understand direction**: [Art Direction](02-art-direction.md) explains why (Headspace warmth + Revolut clarity)
3. **Reference guides**: [UI Style Guide](04-ui-style-guide.md) and [Components](05-components.md)
4. **Implement theme**: [Flutter Theme](07-flutter-theme.md) configuration
5. **Quick lookup**: [Quick Reference](08-quick-reference.md) for common patterns

### Priority User Flows

These flows should be pixel-perfect per the high-fi wireframes:

- **"Claim Credential"** – Primary student action (warm orange #FF8E32 CTA)
- **"Home"** – Dashboard showing stored credentials (warm cream #FFDC99 card backgrounds)

---

## Design System Principles

### 1. Token-First Development

Every design value must reference a token from `03-design-tokens.yaml`. No hardcoded colors, spacing, or typography values in implementation.

### 2. Accessibility by Default

All components must meet WCAG 2.1 Level AA standards. This is non-negotiable.

### 3. Component Reusability

Build once, use everywhere. Components follow Flutter & Material Design 3 patterns.

### 4. HookWidget Pattern

Always use `HookConsumerWidget` or `HookWidget` (never `StatefulWidget`). State via `useCTNotifier` from core hooks.

### 5. Material Design 3 Foundation

Built on Material Design 3 with warm, approachable Credulon branding.

---

## Color Philosophy

Student Vault uses a **warm, approachable, and energetic** color palette inspired by **Headspace warmth**:

- **Primary Orange** (#FF8E32): Warm, energetic, high-priority actions ("Claim Credential")
- **Secondary Cream** (#FFDC99): Calm, friendly, secondary surfaces (card backgrounds)
- **Neutral Grays**: Clear text hierarchy and borders
- **Semantic Colors**: Success (green), warning (amber), error (red)
- **Light Theme**: Default for clarity and educational context

---

## Typography Philosophy

- **Font Family**: IBM Plex Sans (primary), system fonts as fallback
- **Readable**: Minimum 16px for body text (WCAG compliance)
- **Clear Hierarchy**: 6 heading levels + body sizes
- **8px Baseline Grid**: All type sizes align to 8px increments

---

## Spacing Philosophy

- **8px Grid System**: All spacing values are multiples of 8px
- **Consistent Rhythm**: Predictable spacing creates visual harmony
- **Responsive**: Spacing adapts gracefully across breakpoints

---

## Feature Prominence

Following Headspace/Revolut inspiration: **Key features should stand out with visual weight.**

- **"Claim Credential" CTA**: Prominent warm orange button (primary action)
- **Credential Cards**: Warm cream backgrounds with clear typography hierarchy
- **Empty States**: Friendly guidance, not discouraging

---

## Component Implementation Requirements

Every interactive component must implement:

- ✅ Default (resting state)
- ✅ Hover (mouse over)
- ✅ Active/Pressed (during interaction)
- ✅ Focused (keyboard navigation with visible focus ring)
- ✅ Disabled (non-interactive, reduced opacity)
- ✅ Loading (async operation in progress)
- ✅ Error (validation failed)

---

## Accessibility Commitment

Credulon is committed to inclusive design:

- **WCAG 2.1 Level AA** minimum (AAA where possible)
- **Color Contrast**: 4.5:1 for normal text, 3:1 for large text
- **Keyboard Navigation**: Full keyboard support, visible focus indicators
- **Screen Reader Support**: Semantic HTML, ARIA labels
- **Touch Targets**: Minimum 44x44px for mobile
- **Responsive**: Support 200% zoom without loss of functionality

---

## Usage Guidelines

### Importing the Theme

```dart
import 'package:your_app/core/design_system/themes/app_theme.dart';

void main() {
  runApp(
    MaterialApp(
      theme: AppTheme.lightTheme, // Bright, clear theme
      home: MyApp(),
    ),
  );
}
```

### Using Design Tokens

```dart
// ✅ CORRECT - Reference tokens
Container(
  padding: EdgeInsets.all(AppSpacing.spacing2), // 16px
  decoration: BoxDecoration(
    color: AppColors.primary500,
    borderRadius: BorderRadius.circular(AppRadius.md), // 8px
  ),
)

// ❌ WRONG - Hardcoded values
Container(
  padding: EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    color: Color(0xFFFF8E32),
    borderRadius: BorderRadius.circular(8.0),
  ),
)
```

### Using Theme Colors

```dart
// Access theme colors
final theme = Theme.of(context);
Text(
  'Hello',
  style: theme.textTheme.bodyLarge?.copyWith(
    color: theme.colorScheme.primary,
  ),
)
```

---

## Technology Stack

- **Framework**: Flutter 3.5.0+
- **Language**: Dart 3.5.0+
- **Design**: Material Design 3
- **State Management**: Riverpod
- **Hooks**: flutter_hooks
- **Icons**: Material Icons

---

## Contributing

When updating this design system:

- **Small, atomic commits**: One concept/token per commit
- **Diff-only PR reviews**: Show exactly what changed (use unified diff)
- **Test against high-fi wireframes**: Verify layouts match `inspiration/high-fi-wireframes/`
- **Update version history**: Reflect all changes in `version-history.md`

### Version Conventions

- **Major** (1.0.0 → 2.0.0): Breaking changes requiring migration
- **Minor** (1.0.0 → 1.1.0): New components or tokens, backward compatible
- **Patch** (1.0.0 → 1.0.1): Bug fixes, clarifications

---

## Support

For questions or issues:

- Review the [Quick Reference](08-quick-reference.md) for common patterns
- Check [Components](05-components.md) for implementation examples
- Refer to [Accessibility](06-accessibility.md) for compliance guidance
- Review high-fi wireframes in `inspiration/high-fi-wireframes/` for layout reference

---

## License

This design system is part of the Credulon project. See LICENSE file for details.
