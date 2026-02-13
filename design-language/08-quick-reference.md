# Quick Reference

**Document Version**: 1.0.0  
**Last Updated**: January 7, 2026

---

## Overview

This cheat sheet provides fast access to key design tokens, typography scale, spacing, components, and priority user flows for Student Vault App.

For detailed specifications, see: [02-Art Direction](02-art-direction.md) | [04-UI Style Guide](04-ui-style-guide.md) | [05-Components](05-components.md) | [07-Flutter Theme](07-flutter-theme.md)

---

## Color System Quick Reference

### Token Roles (Light Mode - Default)

| Token | Hex | Role | Use Case |
|-------|-----|------|----------|
| `primary.500` | #FF8E32 | **Primary action** | "Claim Credential", main CTAs, app highlights |
| `onPrimary` | #FFFFFF | On primary surfaces | Text/icons on warm orange buttons |
| `secondary.500` | #FFDC99 | **Secondary surface** | Card backgrounds, secondary actions |
| `onSurface` | #1E1E1E | **Primary text** | Body text on all backgrounds |
| `onSurfaceVariant` | #4A4A4A | **Secondary text** | Hints, secondary labels, metadata |
| `error.main` | #F44336 | **Error/destructive** | Delete, invalid states, alerts |
| `outline` | #E0E0E0 | **Borders** | Input borders, dividers, low-emphasis UI |

## Token Quick Reference

### Most Common Spacing Values

| Token | Value | Common Uses |
|-------|-------|-------------|
| `spacing.1` | 8px | Icon-text gap, tight spacing |
| `spacing.2` | 16px | **Card padding, form field spacing** ⭐ |
| `spacing.3` | 24px | Section spacing, large card padding |
| `spacing.4` | 32px | Major section spacing |
| `spacing.6` | 48px | Page section spacing |

---

### Most Common Colors

| Token | Hex | Use Case |
|-------|-----|----------|
| `colors.primary.500` | #FF8E32 | **"Claim Credential", primary CTAs** ⭐ |
| `colors.primary.600` | #E67E28 | Button hover state |
| `colors.secondary.500` | #FFDC99 | Card backgrounds, secondary UI |
| `colors.secondary.100` | #FFEEC8 | Light secondary surface |
| `colors.semantic.success.main` | #4CAF50 | Success states ✅ |
| `colors.semantic.error.main` | #F44336 | Errors, destructive ❌ |
| `colors.semantic.warning.main` | #D99A06 | Warnings ⚠️ |
| `colors.neutral.0` | #FFFFFF | Text on dark backgrounds |
| `colors.neutral.1000` | #000000 | Dark backgrounds |
| `colors.neutral.700` | #636363 | Secondary text |

---

### Spacing Base + Common Sizes

8px grid system: `spacing.1 = 8px`, `spacing.2 = 16px`, `spacing.3 = 24px`, etc.

| Purpose | Token | Value |
|---------|-------|-------|
| Icon + text gap | `spacing.1` | 8px |
| **Card padding, form gaps** | **`spacing.2`** | **16px** ⭐ |
| Section padding | `spacing.3` | 24px |
| Major spacing | `spacing.4` | 32px |
| Page section spacing | `spacing.6` | 48px |

---

### Most Common Border Radii

| Token | Value | Common Uses |
|-------|-------|-------------|
| `radius.md` | 8px | **Buttons, input fields** ⭐ |
| `radius.lg` | 12px | **Cards, modals** ⭐ |
| `radius.xxxl` | 30px | Rounded input fields (chat style) |
| `radius.full` | 9999px | Circular buttons, badges, avatars |

---

### Typography Hierarchy

| Use Case | Size | Weight | Token |
|----------|------|--------|-------|
| Display/Hero | 48px | 700 | `fontSize.6xl` (rare) |
| Page Title (H1) | 28–36px | 700 | `fontSize.3xl–5xl` |
| Section Heading (H2) | 24px | 700 | `fontSize.2xl` |
| Card Title (H3) | 20px | 600 | `fontSize.xl` |
| **Body Text (Default)** | **16px** | **400** | **`fontSize.md`** ⭐ |
| Secondary Text | 14px | 400 | `fontSize.base` |
| Small/Caption | 12px | 400 | `fontSize.sm` |
| Tiny/Label | 10px | 500 | `fontSize.xs` |

**Rule**: Never use smaller than 16px for body content (readability).

---

## Priority User Flows

### "Claim Credential" Flow

**Path**: Home → Notification/Request → Claim Screen → Confirm → Success

**Key Components**:
- **Large, prominent warm orange (#FF8E32) button** for "Claim Credential" CTA
- Card-based credential preview (secondary.500 background)
- Clear confirmation dialog before final action
- Success snackbar with checkmark icon

### "Home" Screen Layout

**Key Sections**:
- Header with greeting + user avatar
- Credential cards grid (warm cream backgrounds, 16px padding)
- "Claim Credential" floating/prominent CTA
- Empty state guidance if no credentials yet

**Spacing**: `spacing.2` (16px) between cards; `spacing.3` (24px) between sections.

---

## Common Component Patterns

### 1. Primary CTA Button

```dart
ElevatedButton(
  onPressed: () => _doAction(),
  child: Text('Claim Credential'), // Primary action
)

// With icon
ElevatedButton.icon(
  icon: Icon(Icons.check, size: 20),
  label: Text('Claim Now'),
  onPressed: () => _doAction(),
)

// Loading state
ElevatedButton(
  onPressed: isLoading ? null : () => _doAction(),
  child: isLoading
    ? SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
    : Text('Submit'),
)
```

---

### 2. Standard Card

```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12), // radius.lg
  ),
  child: Padding(
    padding: EdgeInsets.all(16), // spacing.2
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Credential Title', style: theme.textTheme.headlineMedium),
        SizedBox(height: 8), // spacing.1
        Text('University • Issued Jan 7, 2026', style: theme.textTheme.bodySmall),
      ],
    ),
  ),
)
```

---

### 3. Form Field

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email Address', // Required for accessibility
    hintText: 'Enter your email',
    errorText: hasError ? 'Please enter a valid email' : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // radius.md
    ),
  ),
)
```

---

### 4. Success Snackbar

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Row(
      children: [
        Icon(Icons.check_circle, color: Colors.white),
        SizedBox(width: 12),
        Expanded(child: Text('Credential issued successfully')),
      ],
    ),
    backgroundColor: AppColors.successMain,
    duration: Duration(seconds: 4),
  ),
);
```

---

### 5. Empty State

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.school,
        size: 64, // iconSize.xl
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      SizedBox(height: 24), // spacing.3
      Text(
        'No Credentials Yet',
        style: theme.textTheme.titleLarge,
      ),
      SizedBox(height: 16), // spacing.2
      Text(
        'Start by requesting a credential',
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.gray),
      ),
      SizedBox(height: 24),
      ElevatedButton(
        onPressed: () => _requestCredential(),
        child: Text('Request Credential'),
      ),
    ],
  ),
)
```

---

### 6. Confirmation Dialog

```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Claim this Credential?'),
    content: Text('You\'ll be able to use it for verification and sharing.'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          _claimCredential();
        },
        // Uses primary color by default (warm orange)
        child: Text('Claim'),
      ),
    ],
  ),
);
```

---

### 7. List Item with Action

```dart
ListTile(
  leading: CircleAvatar(
    backgroundColor: AppColors.primary500,
    child: Icon(Icons.school, color: Colors.white),
  ),
  title: Text('University Degree', style: theme.textTheme.titleMedium),
  subtitle: Text('Hong Kong University', style: theme.textTheme.bodySmall),
  trailing: Icon(Icons.chevron_right),
  onTap: () => _viewDetails(),
)
```

---

## Decision Trees

### Which Button Type Should I Use?

```
Is this the PRIMARY action on the screen?
├─ YES → Use ElevatedButton (filled, prominent)
│
└─ NO → Is this a DESTRUCTIVE action?
    ├─ YES → Use ElevatedButton with errorContainer color
    │
    └─ NO → Is this a SECONDARY action?
        ├─ YES → Use TextButton or OutlinedButton
        │
        └─ NO → Use IconButton (if icon-only)
```

**Examples**:
- **Primary**: "Issue Credential" → ElevatedButton
- **Secondary**: "View Details" → TextButton
- **Destructive**: "Delete Record" → ElevatedButton (red)
- **Icon-only**: Settings icon → IconButton

---

### Which Color Should I Use?

```
What is the purpose?
├─ PRIMARY ACTION → colors.primary.500
├─ SECONDARY ACTION → colors.secondary.500
├─ SUCCESS/ACTIVE → colors.success.main
├─ ERROR/DESTRUCTIVE → colors.error.main
├─ WARNING/CAUTION → colors.warning.main
├─ INFORMATIONAL → colors.info.main
└─ NEUTRAL/BACKGROUND → colors.neutral.*
```

---

### Which Text Size Should I Use?

```
What is the content type?
├─ PAGE TITLE → 28-36px (fontSize.3xl-5xl)
├─ SECTION HEADING → 24px (fontSize.2xl)
├─ CARD TITLE → 20px (fontSize.xl)
├─ BODY TEXT → 16px (fontSize.md) ⭐ DEFAULT
├─ SECONDARY TEXT → 14px (fontSize.base)
└─ CAPTION/LABEL → 12px (fontSize.sm)
```

---

### Which Spacing Should I Use?

```
What are you spacing?
├─ ICON + TEXT → 8px (spacing.1)
├─ FORM FIELDS (vertical) → 16px (spacing.2)
├─ CARD PADDING → 16px or 24px (spacing.2 or spacing.3)
├─ BETWEEN SECTIONS → 32px (spacing.4)
└─ PAGE SECTIONS → 48-64px (spacing.6-8)
```

---

## Accessibility Checklist

Use this for every new component:

### Visual
- [ ] Color contrast meets 4.5:1 (text) or 3:1 (UI)
- [ ] Focus indicators visible (2px, high contrast)
- [ ] Text minimum 16px for body content
- [ ] Touch targets minimum 44x44px

### Keyboard
- [ ] All interactive elements keyboard accessible
- [ ] Tab order is logical
- [ ] No keyboard traps
- [ ] Focus visible on all elements

### Screen Reader
- [ ] All images have alt text (or marked decorative)
- [ ] All icon-only buttons have labels
- [ ] Form fields have labels (not just placeholders)
- [ ] Headings use proper hierarchy
- [ ] Error messages are announced

---

## Code Snippets

### Accessing Theme Colors

```dart
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;

// Use theme colors
Container(
  color: colorScheme.primary,
  child: Text(
    'Hello',
    style: theme.textTheme.bodyLarge?.copyWith(
      color: colorScheme.onPrimary,
    ),
  ),
)
```

---

### Responsive Layout

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 640) {
      // Mobile layout
      return Column(children: [...]);
    } else if (constraints.maxWidth < 1024) {
      // Tablet layout
      return Row(children: [...]);
    } else {
      // Desktop layout
      return Row(children: [...]);
    }
  },
)
```

---

### Loading State Pattern (HookConsumerWidget)

```dart
class MyScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoadingNotifier = useCTNotifier(false);
    final isLoading = useValueListenable(isLoadingNotifier);

    Future<void> submitForm() async {
      isLoadingNotifier.value = true;
      try {
        await ref.read(useCaseProvider).call();
      } catch (e) {
        // Handle error
      } finally {
        isLoadingNotifier.value = false;
      }
    }

    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: isLoading ? null : submitForm,
            child: isLoading
              ? CircularProgressIndicator()
              : Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

---

### Error Handling Pattern

```dart
try {
  final result = await useCase.call(params);
  // Success
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Success!'),
      backgroundColor: AppColors.successMain,
    ),
  );
} on ValidationException catch (e) {
  // Validation error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(e.message),
      backgroundColor: AppColors.warningMain,
    ),
  );
} catch (e) {
  // General error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('An error occurred. Please try again.'),
      backgroundColor: AppColors.errorMain,
    ),
  );
}
```

---

## Common Mistakes to Avoid

### ❌ Don't Hardcode Values

```dart
// ❌ BAD
Container(
  padding: EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    color: Color(0xFF0368C0),
    borderRadius: BorderRadius.circular(8.0),
  ),
)

// ✅ GOOD
Container(
  padding: EdgeInsets.all(AppSpacing.spacing2),
  decoration: BoxDecoration(
    color: AppColors.primary500,
    borderRadius: AppRadius.borderMd,
  ),
)
```

---

### ❌ Don't Skip Focus Indicators

```dart
// ❌ BAD
OutlinedButton(
  style: OutlinedButton.styleFrom(
    side: BorderSide.none, // Removes focus indicator!
  ),
  child: Text('Button'),
)

// ✅ GOOD
OutlinedButton(
  // Material 3 handles focus automatically
  child: Text('Button'),
)
```

---

### ❌ Don't Use GestureDetector for Buttons

```dart
// ❌ BAD - Not keyboard accessible
GestureDetector(
  onTap: () => _doSomething(),
  child: Text('Click me'),
)

// ✅ GOOD - Keyboard accessible
TextButton(
  onPressed: () => _doSomething(),
  child: Text('Click me'),
)
```

---

### ❌ Don't Use Placeholder as Label

```dart
// ❌ BAD - Placeholder disappears when typing
TextField(
  decoration: InputDecoration(
    hintText: 'Email address', // Not a label!
  ),
)

// ✅ GOOD - Label persists
TextField(
  decoration: InputDecoration(
    labelText: 'Email Address', // ✅ Required
    hintText: 'Enter your email', // Optional hint
  ),
)
```

---

## Performance Tips

### 1. Use const Constructors

```dart
// Prevents unnecessary rebuilds
const Text('Hello')
const SizedBox(height: 16)
const EdgeInsets.all(16)
```

---

### 2. Extract Large Widgets

```dart
// Instead of building large widget trees inline
class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return /* large widget tree */;
  }
}

// Use in main build
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      _HeaderSection(), // Extracted
      _ContentSection(),
    ],
  );
}
```

---

### 3. Use ListView.builder for Long Lists

```dart
// ❌ BAD for long lists
ListView(
  children: items.map((item) => ListTile(...)).toList(),
)

// ✅ GOOD - Only builds visible items
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(...);
  },
)
```

---

## Summary

This quick reference provides:
- ✅ Most commonly used token values
- ✅ Common component code patterns
- ✅ Decision trees for component selection
- ✅ Accessibility checklist
- ✅ Code snippets for frequent tasks
- ✅ Common mistakes to avoid

**Bookmark this page** for quick access during development.

**For detailed specifications**, refer to:
- [Design Tokens](03-design-tokens.yaml) - All token values
- [UI Style Guide](04-ui-style-guide.md) - Complete visual standards
- [Components](05-components.md) - Comprehensive component library
- [Accessibility](06-accessibility.md) - WCAG compliance guidelines
- [Flutter Theme](07-flutter-theme.md) - Complete theme implementation
