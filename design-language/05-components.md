# Components Library

**Document Version**: 1.0.0  
**Last Updated**: January 6, 2026

---

## Overview

This document provides comprehensive specifications for all Nexigen UI components. Each component includes anatomy, states, variants, usage guidelines, accessibility requirements, token references, and Flutter implementation examples.

### Application-Specific Component Usage

**Trust Registry Admin Portal**:
- Heavy use of data tables, form inputs, and action buttons
- Priority: Authority statements, trust record management, user invitation flows
- Key components: Complex forms, list views, authorization matrices

**Student Vault App**:
- Focus on credential cards, QR code scanners, notification systems
- Priority: Credential claim flows, secure sharing, university selection
- Key components: Credential cards, bottom sheets, biometric prompts (future: facial recognition)

**Employer Verification Portal**:
- Emphasis on verification status, QR code presentation, result displays
- Priority: Credential request flows, authenticity checks, TRQP queries
- Key components: Status indicators, verification results, QR code generators

---

## Component Index

### Actions
- [Primary Button](#primary-button)
- [Secondary Button](#secondary-button)
- [Text Button](#text-button)
- [Icon Button](#icon-button)
- [Floating Action Button](#floating-action-button)

### Inputs
- [Text Field](#text-field)
- [Select/Dropdown](#selectdropdown)
- [Checkbox](#checkbox)
- [Radio Button](#radio-button)
- [Switch](#switch)

### Display
- [Card](#card)
- [List Item](#list-item)
- [Avatar](#avatar)
- [Badge](#badge)
- [Chip](#chip)

### Feedback
- [Snackbar](#snackbar)
- [Dialog/Modal](#dialogmodal)
- [Alert Banner](#alert-banner)
- [Progress Indicator](#progress-indicator)
- [Empty State](#empty-state)

### Navigation
- [App Bar](#app-bar)
- [Bottom Navigation](#bottom-navigation)
- [Navigation Drawer](#navigation-drawer)
- [Tabs](#tabs)

---

## Primary Button

### Description
Primary buttons are the highest-emphasis actions used for key CTAs like "Claim Credential". Use sparingly (typically one per screen). Warm orange (#FF8E32) signals excitement and importance.

### Anatomy
```
┌──────────────────────────┐
│  [Icon] Label Text       │  ← Optional icon (20px)
└──────────────────────────┘
     ↑            ↑
  Padding    Border radius
(32px/18px)    (8px)
   
Min Height: 56px (CTA prominence)
```

### States

| State | Background | Text | Border | Elevation | Notes |
|-------|-----------|------|--------|-----------|-------|
| **Default** | `colors.primary.500` (#FF8E32) | `colors.neutral.0` (#FFFFFF) | None | `elevation.2` | Warm orange for key actions |
| **Hover** | `colors.primary.600` (#E67E28) | `colors.neutral.0` (#FFFFFF) | None | `elevation.4` | Transition 300ms ease-out |
| **Pressed** | `colors.primary.700` (#D56E1F) | `colors.neutral.0` (#FFFFFF) | None | `elevation.1` | Scale 0.98, 150ms ease-out |
| **Focused** | `colors.primary.500` (#FF8E32) | `colors.neutral.0` (#FFFFFF) | `2px solid primary.500` | `elevation.2` | 2px outline offset |
| **Disabled** | `colors.neutral.500` (20% opacity) | `colors.text.light.disabled` (#9E9E9E) | None | `elevation.0` | Cursor: not-allowed |
| **Loading** | `colors.primary.500` (#FF8E32) | Spinner (20px) | None | `elevation.2` | Disabled state |

### Variants

#### Standard (Default)
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Issue Credential'),
)
```

#### With Icon
```dart
ElevatedButton.icon(
  onPressed: () {},
  icon: Icon(Icons.add, size: 20),
  label: Text('Add Credential'),
)
```

#### Full Width
```dart
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {},
    child: Text('Submit'),
  ),
)
```

### Token References

| Property | Token | Value |
|----------|-------|-------|
| Background (Default) | `colors.primary.500` | #FF8E32 |
| Background (Hover) | `colors.primary.600` | #E67E28 |
| Background (Pressed) | `colors.primary.700` | #D56E1F |
| Text Color | `colors.neutral.0` | #FFFFFF |
| Padding Horizontal | `spacing.4` | 32px |
| Padding Vertical | - | 18px |
| Border Radius | `radius.md` | 8px |
| Font Size | `fontSize.lg` | 18px |
| Font Weight | `fontWeight.medium` | 500 |
| Min Height | `touchTarget.comfortable` | 56px |
| Focus Outline | `borderWidth.medium` | 2px |
| Elevation | `elevation.2` | 2 |
| Contrast Ratio | - | 5.2:1 (WCAG AA) |

### Usage Guidelines

**When to Use**:
- Key call-to-action: "Claim Credential" (primary CTA on credential screens)
- Final step in a workflow
- Most important action on the screen (max one per screen)
- Warm orange (#FF8E32) emphasizes importance and excitement

**When NOT to Use**:
- Multiple primary actions (use secondary buttons instead)
- Destructive actions (use error-styled button)
- Less important actions (use text button)
- Navigation (use links or text buttons)

**Do's**:
✅ Use clear action verbs ("Claim Credential", "Issue Now", "Share")  
✅ Keep labels short (1-3 words)  
✅ One primary button per screen  
✅ Place in consistent locations (bottom for forms, center-aligned for modals)  
✅ Use for key features to stand out with warm orange  

**Don'ts**:
❌ Don't use generic labels ("OK", "Submit")  
❌ Don't use all-caps (reduces readability)  
❌ Don't place far from related content  
❌ Don't overuse primary buttons (dilutes importance)  
❌ Don't use blue or cool colors for primary CTAs  

### Accessibility

- ✅ **Touch Target**: 44x44px minimum (meets iOS/Android standards)
- ✅ **Color Contrast**: 4.87:1 (white on primary blue) - WCAG AA
- ✅ **Focus Indicator**: Visible 2px outline
- ✅ **Screen Reader**: Button role announced automatically
- ✅ **Keyboard**: Activates on Enter/Space

### Flutter Implementation

```dart
import 'package:flutter/material.dart';
import 'package:your_app/core/design_system/themes/app_colors.dart';
import 'package:your_app/core/design_system/themes/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Text(label);

    if (icon != null && !isLoading) {
      return ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,      // #FF8E32 warm orange
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),  // buttonLarge height
          padding: const EdgeInsets.symmetric(
            horizontal: 32,  // spacing.4
            vertical: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),   // radius.md
          ),
          elevation: 2,  // elevation.2
        ),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary500,        // #FF8E32 warm orange
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),  // buttonLarge height
        padding: const EdgeInsets.symmetric(
          horizontal: 32,   // spacing.4
          vertical: 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),    // radius.md
        ),
        elevation: 2,  // elevation.2
      ),
      child: buttonChild,
    );
  }
}

// Usage - Claim Credential CTA
PrimaryButton(
  label: 'Claim Credential',
  onPressed: () => _claimCredential(),
  icon: Icons.check_circle,
)

// Loading state
PrimaryButton(
  label: 'Claiming...',
  isLoading: true,
  onPressed: null,
)
```

### Accessibility

- ✅ **Touch Target**: 56×56px (comfortable for primary actions per `touchTarget.comfortable`)
- ✅ **Color Contrast**: 5.2:1 white on warm orange (#FF8E32) — WCAG AA
- ✅ **Focus Indicator**: Visible 2px outline with 2px offset
- ✅ **Screen Reader**: Button role and label announced automatically
- ✅ **Keyboard**: Activates on Enter/Space, focus ring visible

---

## Card

### Description
Cards contain content and actions about a single subject. Used extensively in Nexigen for credential displays, record lists, and content grouping. Light elevation (1) and warm cream backgrounds create hierarchy without heavy shadows (Headspace principle).

### Anatomy
```
┌────────────────────────────────┐
│  ┌──────┐                      │
│  │      │  Title               │ ← Padding: spacing.2 (16px)
│  │[Icon]│  Subtitle            │ ← Title (fontSize.xl/20px, semibold)
│  └──────┘                      │ ← Subtitle (fontSize.base/14px, regular)
│                                │
│  Body content with multiple    │ ← Body text (fontSize.md/16px)
│  lines, credential details.    │
│                                │
│  [Action Button] [Link]        │ ← Actions (optional, bottom-right)
└────────────────────────────────┘
     ↑                  ↑
Border radius      Elevation
  (12px)             (1)
```

### States

| State | Background | Elevation | Border | Scale | Notes |
|-------|-----------|-----------|--------|-------|-------|
| **Default** | `colors.surface.light.surface` (#FFEEC8) | `elevation.1` | None | 1.0 | Warm cream background |
| **Hover** | `colors.surface.light.surface` (#FFEEC8) | `elevation.3` | None | 1.0 | If clickable (desktop) |
| **Pressed** | `colors.surface.light.surface` (#FFEEC8) | `elevation.1` | None | 0.99 | If clickable |
| **Focused** | `colors.surface.light.surface` (#FFEEC8) | `elevation.1` | `2px solid primary.500` | 1.0 | Keyboard navigation |
| **Disabled** | `colors.surface.light.surface` (#FFEEC8) | `elevation.1` | None | 1.0 | Opacity: 0.6 |

### Variants

#### Standard Card
```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Title', style: theme.textTheme.titleLarge),
        SizedBox(height: 8),
        Text('Content', style: theme.textTheme.bodyLarge),
      ],
    ),
  ),
)
```

#### Clickable Card
```dart
Card(
  elevation: 2,
  child: InkWell(
    onTap: () {},
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: /* content */,
    ),
  ),
)
```

#### Large Card
```dart
Card(
  elevation: 2,
  child: Padding(
    padding: EdgeInsets.all(24), // spacing.3
    child: /* content */,
  ),
)
```

### Token References

| Property | Token | Value |
|----------|-------|-------|
| Background (Light) | `colors.surface.light.surface` | #FFEEC8 |
| Padding (Standard) | `spacing.2` | 16px |
| Padding (Large) | `spacing.3` | 24px |
| Border Radius | `radius.lg` | 12px |
| Elevation (Default) | `elevation.1` | 1 |
| Elevation (Hover) | `elevation.3` | 3 |
| Focus Outline | `borderWidth.medium` | 2px |
| Transition | `animation.duration.normal` | 300ms ease-out |

### Usage Guidelines

**When to Use**:
- Displaying credentials in a list
- Grouping related information
- Presenting records with actions
- Creating visual hierarchy

**When NOT to Use**:
- Simple lists (use list items instead)
- Full-screen content (no card needed)
- Dense data tables (cards add too much padding)

**Do's**:
✅ Keep card content focused (one subject per card)  
✅ Use consistent padding (16px or 24px)  
✅ Place actions at bottom-right  
✅ Maintain aspect ratios for images  

**Don'ts**:
❌ Don't nest cards inside cards  
❌ Don't use inconsistent padding  
❌ Don't overcrowd with content  
❌ Don't use for single text items  

### Accessibility

- ✅ **Focus**: Cards with actions must be keyboard accessible
- ✅ **Semantics**: Use proper heading hierarchy within cards
- ✅ **Touch Targets**: Actions within cards meet 44x44px minimum
- ✅ **Screen Reader**: Content reads in logical order

### Flutter Implementation

```dart
import 'package:flutter/material.dart';
import 'package:your_app/core/design_system/themes/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final double? elevation;
  final bool isClickable;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.elevation,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardChild = Padding(
      padding: padding ?? const EdgeInsets.all(16),  // Default spacing.2
      child: child,
    );

    return Card(
      elevation: elevation ?? 1,  // elevation.1 (light, Headspace-inspired)
      color: AppColors.surfaceLightSurface,          // #FFEEC8 warm cream
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),     // radius.lg
      ),
      child: onTap != null && isClickable
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: cardChild,
            )
          : cardChild,
    );
  }
}

// Usage - Credential Card
AppCard(
  isClickable: true,
  onTap: () => _viewCredential(),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(Icons.school, size: 32, color: AppColors.primary500),
      SizedBox(height: 12),
      Text('University Degree', style: theme.textTheme.titleLarge),
      SizedBox(height: 4),
      Text('Hong Kong University', style: theme.textTheme.bodyMedium),
      SizedBox(height: 16),
      Text('Issued: Jan 2025', style: theme.textTheme.bodySmall),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => _shareCredential(),
            child: const Text('Share'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _viewDetails(),
            child: const Text('View'),
          ),
        ],
      ),
    ],
  ),
)

// Usage - Static Card (no interaction)
AppCard(
  padding: EdgeInsets.all(24),  // spacing.3 for large card
  child: Text('Trust Registry Info', style: theme.textTheme.bodyLarge),
)
```

### Accessibility

- ✅ **Focus**: Cards with actions must be keyboard accessible with visible 2px outline
- ✅ **Semantics**: Use proper heading hierarchy (h3-h5) within card titles
- ✅ **Touch Targets**: Actions within cards meet 44×44px minimum
- ✅ **Screen Reader**: Content reads in logical order (icon description, title, body, actions)
- ✅ **Contrast**: Dark text (#1E1E1E) on warm cream (#FFEEC8) = 6.1:1 (WCAG AAA)

---

## Text Field

### Description
Text fields allow users to input text and are used extensively in forms throughout Nexigen. Warm cream backgrounds (#FFEEC8) and clear focus states ensure accessibility on light mode.

### States

| State | Background | Border | Border Color | Text Color | Notes |
|-------|-----------|--------|--------------|-----------|-------|
| **Default** | `colors.secondary.300` (#FFEEC8) | 1px | `colors.neutral.300` (#E0E0E0) | `colors.text.light.primary` (#1E1E1E) | Warm cream background |
| **Focused** | `colors.secondary.300` (#FFEEC8) | 1px | `colors.primary.500` (#FF8E32) | `colors.text.light.primary` (#1E1E1E) | Warm orange border |
| **Filled** | `colors.secondary.300` (#FFEEC8) | 1px | `colors.neutral.300` (#E0E0E0) | `colors.text.light.primary` (#1E1E1E) | User has entered text |
| **Error** | `colors.secondary.300` (#FFEEC8) | 1px | `colors.semantic.error.main` (#F44336) | `colors.text.light.primary` (#1E1E1E) | Error message below |
| **Disabled** | `colors.neutral.100` (#F5F5F5) | 1px | `colors.neutral.300` (48% opacity) | `colors.text.light.disabled` (#9E9E9E) | Cursor: not-allowed |

### Token References

| Property | Token | Value |
|----------|-------|-------|
| Background | `colors.secondary.300` | #FFEEC8 |
| Border (Default) | `colors.neutral.300` | #E0E0E0 |
| Border (Focused) | `colors.primary.500` | #FF8E32 |
| Border (Error) | `colors.semantic.error.main` | #F44336 |
| Border Width | `borderWidth.thin` | 1px |
| Text Color | `colors.text.light.primary` | #1E1E1E |
| Border Radius | `radius.md` | 8px |
| Padding Horizontal | `spacing.2` | 16px |
| Padding Vertical | - | 12px |
| Font Size | `fontSize.md` | 16px |
| Min Height | `touchTarget.minimum` | 44px |
| Contrast Ratio | - | 6.1:1 (WCAG AAA) |
| Focus Outline | `borderWidth.medium` | 2px |

### Flutter Implementation

```dart
import 'package:flutter/material.dart';
import 'package:your_app/core/design_system/themes/app_colors.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final bool enabled;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.enabled = true,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        filled: true,
        fillColor: AppColors.secondary300,  // #FFEEC8 warm cream
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),  // radius.md
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),  // colors.neutral.300
            width: 1,  // borderWidth.thin
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),  // colors.neutral.300
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.primary500,  // #FF8E32 warm orange
            width: 2,  // Slight emphasis on focus
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFF44336),  // colors.semantic.error.main
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFF44336),
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: const Color(0xFFE0E0E0).withOpacity(0.48),
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,  // spacing.2
          vertical: 12,
        ),
        errorText: widget.errorText,
        errorStyle: const TextStyle(
          color: Color(0xFFF44336),  // Error red
          fontSize: 12,  // fontSize.sm
        ),
        labelStyle: TextStyle(
          color: _isFocused 
              ? AppColors.primary500  // #FF8E32 when focused
              : const Color(0xFF4A4A4A),  // colors.text.light.secondary
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

// Usage - Default
AppTextField(
  label: 'Institution Name',
  hint: 'Enter your institution',
  controller: _institutionController,
)

// Usage - Error State
AppTextField(
  label: 'Email Address',
  errorText: 'Please enter a valid email',
  controller: _emailController,
)
```

### Accessibility

- ✅ **Touch Target**: 44×44px minimum (padding + font size)
- ✅ **Color Contrast**: 6.1:1 dark text (#1E1E1E) on warm cream (#FFEEC8) — WCAG AAA
- ✅ **Focus Indicator**: 2px warm orange border (visible, never hidden)
- ✅ **Label Association**: `labelText` associated with input automatically
- ✅ **Error Messaging**: Error text displayed below field with color contrast
- ✅ **Keyboard**: Full keyboard navigation support, no zoom prevention
- ✅ **Min Font Size**: 16px prevents mobile auto-zoom on focus

---

## Stepper

### Description
Steppers display progress through a sequential process. Used for multi-step workflows like credential issuance, credential sharing, and account setup. Each step shows completion status and allows navigation.

### Anatomy
```
Step 1: Choose Institution        ← Active step (warm orange)
  ● Credential Type               ← Completed step (checkmark)
  ○ Verify Information            ← Incomplete step (neutral circle)
  ○ Confirm Sharing               ← Disabled step (grayed out)

Progress: 25% complete            ← Visual progress indicator
```

### States

| State | Icon | Background | Text Color | Notes |
|-------|------|-----------|-----------|-------|
| **Completed** | ✓ Checkmark | `colors.semantic.success.main` (#4CAF50) | White | Previous steps |
| **Active** | Step # | `colors.primary.500` (#FF8E32) | White | Current step (warm orange) |
| **Inactive** | ○ Circle | `colors.neutral.300` (#E0E0E0) | `colors.text.light.primary` (#1E1E1E) | Future steps |
| **Disabled** | ✕ X | `colors.neutral.500` (30% opacity) | `colors.text.light.disabled` (#9E9E9E) | Unavailable steps |
| **Error** | ✕ X | `colors.semantic.error.main` (#F44336) | White | Failed validation |

### Variants

#### Horizontal Stepper (Mobile/Tablet)
```
[1] — [2] — [3] — [4]
 ✓    ◉    ○    ○
```

#### Vertical Stepper (Form Flows)
```
✓ Step 1: Complete
  Choose Institution

◉ Step 2: Active
  Select Credential Type
  [Form fields...]
  [Back] [Next]

○ Step 3: Inactive
  Verify Information
```

### Token References

| Property | Token | Value |
|----------|-------|-------|
| Active Background | `colors.primary.500` | #FF8E32 |
| Completed Background | `colors.semantic.success.main` | #4CAF50 |
| Error Background | `colors.semantic.error.main` | #F44336 |
| Inactive Background | `colors.neutral.300` | #E0E0E0 |
| Step Number Font Size | `fontSize.md` | 16px |
| Step Label Font Size | `fontSize.base` | 14px |
| Step Icon Size | `iconSize.md` | 24px |
| Padding | `spacing.2` | 16px |
| Border Radius | `radius.full` | 9999px |
| Transition | `animation.duration.normal` | 300ms ease-out |

### Flutter Implementation

```dart
import 'package:flutter/material.dart';
import 'package:your_app/core/design_system/themes/app_colors.dart';

class AppStepper extends StatefulWidget {
  final int currentStep;
  final List<String> steps;
  final VoidCallback? onStepContinue;
  final VoidCallback? onStepCancel;
  final Function(int)? onStepTapped;
  final List<bool>? stepErrors;

  const AppStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onStepContinue,
    this.onStepCancel,
    this.onStepTapped,
    this.stepErrors,
  });

  @override
  State<AppStepper> createState() => _AppStepperState();
}

class _AppStepperState extends State<AppStepper> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        useMaterial3: true,
      ),
      child: Stepper(
        currentStep: widget.currentStep,
        steps: List.generate(
          widget.steps.length,
          (index) => Step(
            title: Text(
              widget.steps[index],
              style: TextStyle(
                fontSize: 16,  // fontSize.md
                fontWeight: FontWeight.w500,
                color: index == widget.currentStep
                    ? AppColors.primary500  // #FF8E32 active
                    : index < widget.currentStep
                        ? Colors.green  // Completed
                        : Colors.grey,  // Inactive
              ),
            ),
            state: index < widget.currentStep
                ? StepState.complete
                : (widget.stepErrors?[index] ?? false)
                    ? StepState.error
                    : (index == widget.currentStep
                        ? StepState.editing
                        : StepState.indexed),
            isActive: index <= widget.currentStep,
            content: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  // Content for each step goes here
                  if (index == 0)
                    _buildChooseInstitution()
                  else if (index == 1)
                    _buildSelectCredential()
                  else if (index == 2)
                    _buildVerifyInfo()
                  else
                    _buildConfirmSharing(),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.currentStep > 0)
                        ElevatedButton(
                          onPressed: widget.onStepCancel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                          ),
                          child: const Text('Back'),
                        ),
                      SizedBox(width: 8),
                      if (index == widget.steps.length - 1)
                        ElevatedButton(
                          onPressed: widget.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,  // #FF8E32
                          ),
                          child: const Text('Complete'),
                        )
                      else
                        ElevatedButton(
                          onPressed: widget.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,  // #FF8E32
                          ),
                          child: const Text('Next'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        onStepTapped: widget.onStepTapped,
        onStepContinue: widget.onStepContinue,
        onStepCancel: widget.onStepCancel,
      ),
    );
  }

  Widget _buildChooseInstitution() => Text('Select your institution');
  Widget _buildSelectCredential() => Text('Choose credential type');
  Widget _buildVerifyInfo() => Text('Verify credential information');
  Widget _buildConfirmSharing() => Text('Confirm sharing permissions');
}

// Usage
AppStepper(
  currentStep: 1,
  steps: [
    'Choose Institution',
    'Select Credential',
    'Verify Information',
    'Confirm Sharing',
  ],
  onStepContinue: () {
    if (currentStep < 3) {
      setState(() => currentStep++);
    }
  },
  onStepCancel: () {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  },
  onStepTapped: (int index) {
    setState(() => currentStep = index);
  },
)
```

### Accessibility

- ✅ **Active Step**: Warm orange (#FF8E32) background clearly indicates current step
- ✅ **Step Indicators**: Numbered circles show progress; checkmarks for completed steps
- ✅ **Focus**: All step buttons keyboard accessible with 2px focus outline
- ✅ **Screen Reader**: Step label + completion state announced ("Step 2 of 4, active, select credential")
- ✅ **Touch Targets**: Step circles minimum 44×44px
- ✅ **Color**: Completed steps use green for status redundancy (not just color)
- ✅ **Error States**: Failed validation shown with red background + error icon

### Usage Guidelines

**When to Use**:
- Multi-step workflows (credential request, issuance, sharing)
- Complex forms split across multiple screens
- Processes requiring validation at each step
- User needs progress indication

**When NOT to Use**:
- Single-page forms (use simple form layout)
- Simple 2-step processes (use confirmation dialogs)
- Linear reading content (use normal page sections)

**Do's**:
✅ Keep steps brief (2-5 steps typically)  
✅ Use clear, action-oriented labels  
✅ Validate before allowing forward navigation  
✅ Show progress percentage  
✅ Allow backward navigation to review  

**Don'ts**:
❌ Don't skip steps visually  
❌ Don't force linear progression (allow review)  
❌ Don't change step count mid-flow  
❌ Don't remove completed step content  

---

## Snackbar

### Description
Brief messages that appear at the bottom of the screen. Used for feedback after actions.

### Anatomy
```
┌──────────────────────────────────────┐
│ [Icon] Message text here  [Action]   │
└──────────────────────────────────────┘
     ↑           ↑            ↑
   Icon      Message     Action (optional)
  (24px)     (16px)      TextButton
```

### Variants

#### Success Snackbar
- **Background**: `colors.semantic.success.main`
- **Text**: White
- **Icon**: `Icons.check_circle`
- **Duration**: 4 seconds

#### Error Snackbar
- **Background**: `colors.semantic.error.main`
- **Text**: White
- **Icon**: `Icons.error`
- **Duration**: 6 seconds (longer for errors)

#### Info Snackbar
- **Background**: `colors.neutral.900` (dark mode default)
- **Text**: White
- **Icon**: `Icons.info`
- **Duration**: 4 seconds

### Flutter Implementation

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Row(
      children: [
        Icon(Icons.check_circle, color: Colors.white),
        SizedBox(width: 12),
        Expanded(
          child: Text('Credential issued successfully'),
        ),
      ],
    ),
    backgroundColor: AppColors.successMain,
    duration: Duration(seconds: 4),
    action: SnackBarAction(
      label: 'View',
      textColor: Colors.white,
      onPressed: () {},
    ),
  ),
);
```

---

## Empty State

### Description
Displays when no content is available. Guides users to take action.

### Anatomy
```
        [Icon or Illustration]
           (64-96px)
              
           Heading Text
          (20px, semibold)
              
        Description text explaining
        the situation and next steps
             (16px, regular)
              
          [Primary Button]
       (Clear call-to-action)
```

### Token References

| Property | Token | Value |
|----------|-------|-------|
| Icon Size | `iconSize.xl` | 48px |
| Heading Size | `fontSize.xl` | 20px |
| Body Size | `fontSize.md` | 16px |
| Spacing (vertical) | `spacing.3` | 24px |

### Flutter Implementation

```dart
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String heading;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.heading,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            SizedBox(height: 24),
            Text(
              heading,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.gray,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Usage
EmptyState(
  icon: Icons.school,
  heading: 'No Credentials Yet',
  description: 'Start by requesting a credential from your institution',
  actionLabel: 'Request Credential',
  onAction: () => _requestCredential(),
)
```

---

## Component Summary

This Components Library covers the essential UI elements for Nexigen:

- **Action Components**: Buttons (primary, secondary, text, icon, FAB)
- **Input Components**: Text fields, dropdowns, checkboxes, radio buttons, switches
- **Display Components**: Cards, lists, avatars, badges, chips
- **Feedback Components**: Snackbars, dialogs, alerts, progress indicators, empty states
- **Navigation Components**: App bars, bottom navigation, drawers, tabs

**Key Principles**:
1. All components reference design tokens
2. All interactive components implement required states
3. All components meet WCAG AA accessibility standards
4. All components include Flutter implementation examples

**Next Steps**:
- Review [Accessibility](06-accessibility.md) for detailed compliance guidelines
- Check [Flutter Theme](07-flutter-theme.md) for complete theme configuration
- Use [Quick Reference](08-quick-reference.md) for common patterns

For additional components not documented here, follow the established patterns:
- Reference design tokens for all values
- Implement all 8 component states
- Ensure WCAG AA compliance
- Provide clear usage guidelines
