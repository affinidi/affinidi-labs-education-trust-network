# Components Library

**Document Version**: 2.0.0  
**Last Updated**: January 15, 2026

---

## Overview

This document provides comprehensive specifications for Governance Portal Dashboard UI components. Each component includes anatomy, states, variants, usage guidelines, accessibility requirements, and implementation examples.

**Design Context**: Professional governance interface with light content + dark navigation, cool neutral palette, desktop-first optimization.

---

## Component Index

### Actions
- [Primary Button](#primary-button)
- [Secondary Button](#secondary-button)
- [Text Button](#text-button)
- [Icon Button](#icon-button)

### Navigation
- [Dark Sidebar Navigation](#dark-sidebar-navigation)
- [Navigation Item](#navigation-item)

### Containers
- [Modal](#modal)
- [Card](#card)
- [Key Section (Rainbow Outline)](#key-section-rainbow-outline)

### Data Display
- [Table](#table)
- [Table Density Presets](#table-density-presets)

### Inputs
- [Text Input](#text-input)
- [Select/Dropdown](#selectdropdown)
- [Checkbox](#checkbox)

### Feedback
- [Alert](#alert)
- [Toast](#toast)

---

## Primary Button

### Overview

Main call-to-action button with **vibrant blue-purple gradient**. Used for primary actions like "Create Record", "Save", "Approve".

**CRITICAL**: Primary buttons use vibrant blue-purple gradient (#2563EB → #7C3AED) to stand out from dark navy navigation. NEVER use rainbow gradient.

**Design Rationale**: The vibrant gradient ensures primary CTAs are highly visible against the dark navigation (#0B1B2B) while maintaining professional aesthetics.

---

### Anatomy

```
┌─────────────────────────────────────┐
│  [Icon?]  Button Text  [Icon?]      │ ← 44px height (min)
└─────────────────────────────────────┘
   ← 28px →              ← 28px →
   (padding left)        (padding right)
```

**Parts**:
- Background: Vibrant blue-purple gradient (#2563EB → #7C3AED)
- Text: White, 16px, semibold (600)
- Padding: 14px top/bottom, 28px left/right (increased for better text spacing)
- Border radius: 8px
- Optional leading/trailing icon: 20px-24px

---

### States

| State | Background | Text | Cursor |
|-------|------------|------|--------|
| **Default** | Gradient #2563EB → #7C3AED | White | Pointer |
| **Hover** | Gradient with increased opacity/brightness | White | Pointer |
| **Pressed** | Gradient + translateY(1px) | White | Pointer |
| **Disabled** | #EEF2F7 (neutral.200) | #C2CCDA (neutral.400) | Not-allowed |
| **Focus** | Default + 2px #2563EB outline | White | Pointer |

---

### Implementation

**CSS**:
```css
.button-primary {
  /* Layout */
  min-height: 44px;
  padding: 14px 28px;
  border-radius: 8px;
  border: none;
  
  /* Background - vibrant blue-purple gradient */
  background: linear-gradient(135deg, #2563EB 0%, #7C3AED 100%);
  
  /* Text */
  font-family: Inter, sans-serif;
  font-size: 16px;
  font-weight: 600;
  color: #FFFFFF;
  letter-spacing: 0.02em;
  
  /* Interaction */
  cursor: pointer;
  transition: background 200ms ease-out, transform 100ms ease;
}

.button-primary:hover {
  filter: brightness(1.1);
}

.button-primary:active {
  transform: translateY(1px);
}

.button-primary:focus-visible {
  outline: 2px solid #2563EB;
  outline-offset: 2px;
}

.button-primary:disabled {
  background: #EEF2F7;
  color: #C2CCDA;
  cursor: not-allowed;
}
```

**Flutter** (Container Pattern):
```dart
// Import required
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';

Container(
  height: 44,
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        AppColors.accentBlue, // Vibrant Blue (design token)
        AppColors.accentPurple, // Purple (design token)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
  ),
  child: ElevatedButton(
    onPressed: () => _handleAction(),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      disabledBackgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      elevation: 0,
    ),
    child: const Text(
      'Create Record',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.32,
      ),
    ),
  ),
)
```

**Implementation Notes**:
- **ALWAYS use design tokens**: `AppColors.accentBlue` and `AppColors.accentPurple`
- Never hardcode hex values like `Color(0xFF2563EB)` - use tokens for consistency
- Wrap `Container` (with gradient) around `ElevatedButton` (transparent)
- Set button background to `Colors.transparent` to show gradient
- Increased padding (28px/14px) prevents text from appearing cut off
- Tokens defined in `lib/core/design_system/app_colors.dart`

---

### Usage Guidelines

**DO**:
- ✅ Use for primary actions ("Create", "Save", "Submit")
- ✅ One primary button per screen/modal
- ✅ Place at bottom-right of modals
- ✅ Use meaningful action verbs

**DON'T**:
- ❌ Use rainbow gradient (wrong palette)
- ❌ Multiple primary buttons competing
- ❌ Generic labels like "OK" or "Submit"
- ❌ For destructive actions (use error button)

---

### Accessibility

- Minimum 44x44px touch target ✅
- White text on gradient: >13:1 contrast (WCAG AAA ✅✅✅)
- Focus ring visible on keyboard navigation
- Add `aria-label` if text unclear

---

## Secondary Button

### Overview

Neutral button for secondary actions. No gradient, outlined style.

---

### Anatomy

```
┌─────────────────────────────────────┐
│  [Icon?]  Button Text  [Icon?]      │ ← 44px height (min)
└─────────────────────────────────────┘
   ← 24px →              ← 24px →
```

**Parts**:
- Background: Transparent
- Border: 1px solid #E3E8EF (neutral.300)
- Text: #1D2633 (neutral.700), 16px, semibold
- Padding: 12px/24px
- Border radius: 8px

---

### States

| State | Background | Border | Text |
|-------|------------|--------|------|
| **Default** | Transparent | #E3E8EF | #1D2633 |
| **Hover** | #F7F9FC (neutral.100) | #C2CCDA | #1D2633 |
| **Pressed** | #EEF2F7 (neutral.200) | #C2CCDA | #1D2633 |
| **Disabled** | Transparent | #EEF2F7 | #C2CCDA |
| **Focus** | Transparent + 2px #2563EB outline | #E3E8EF | #1D2633 |

---

### Implementation

**CSS**:
```css
.button-secondary {
  min-height: 44px;
  padding: 12px 24px;
  border-radius: 8px;
  border: 1px solid #E3E8EF;
  background: transparent;
  
  font-family: Inter, sans-serif;
  font-size: 16px;
  font-weight: 600;
  color: #1D2633;
  
  cursor: pointer;
  transition: all 200ms ease-out;
}

.button-secondary:hover {
  background: #F7F9FC;
  border-color: #C2CCDA;
}

.button-secondary:active {
  background: #EEF2F7;
}

.button-secondary:focus-visible {
  outline: 2px solid #2563EB;
  outline-offset: 2px;
}

.button-secondary:disabled {
  border-color: #EEF2F7;
  color: #C2CCDA;
  cursor: not-allowed;
}
```

---

### Usage

**DO**:
- ✅ Secondary actions ("Cancel", "Back")
- ✅ Pair with primary button
- ✅ Less emphasis than primary

**DON'T**:
- ❌ For main CTA
- ❌ Mix with multiple button types

---

## Text Button

### Overview

Low-emphasis button for tertiary actions. No background or border.

---

### States

| State | Background | Text |
|-------|------------|------|
| **Default** | Transparent | #2F6BDE (link blue) |
| **Hover** | #F7F9FC | #1E40AF |
| **Pressed** | #EEF2F7 | #1E40AF |
| **Disabled** | Transparent | #C2CCDA |

---

### Implementation

```css
.button-text {
  min-height: 40px;
  padding: 8px 16px;
  border-radius: 8px;
  border: none;
  background: transparent;
  
  font-family: Inter, sans-serif;
  font-size: 16px;
  font-weight: 600;
  color: #2F6BDE;
  
  cursor: pointer;
  transition: all 200ms ease-out;
}

.button-text:hover {
  background: #F7F9FC;
  color: #1E40AF;
}
```

---

### Usage

**DO**:
- ✅ Tertiary actions ("Learn More", "View Details")
- ✅ In-line with text
- ✅ Non-critical actions

**DON'T**:
- ❌ For primary actions
- ❌ Without clear context

---

## Icon Button

### Overview

Button with icon only, no text label. Requires accessible label.

---

### Anatomy

```
┌────────┐
│  Icon  │ ← 40x40px
└────────┘
```

**Sizes**:
- Small: 32x32px (icon 16px)
- Base: 40x40px (icon 20px)
- Large: 48x48px (icon 24px)

---

### Implementation

```dart
IconButton(
  icon: Icon(Icons.close, size: 20),
  iconSize: 20,
  color: Color(0xFF64758B), // neutral.600
  tooltip: 'Close modal', // Required for accessibility
  onPressed: () => _closeModal(),
  constraints: BoxConstraints(minWidth: 40, minHeight: 40),
)
```

---

### Usage

**DO**:
- ✅ Always add tooltip or aria-label
- ✅ Use recognizable icons
- ✅ 40x40px minimum touch target

**DON'T**:
- ❌ Without accessible label
- ❌ Ambiguous icons

---

## Dark Sidebar Navigation

### Overview

Fixed left sidebar with dark background (#0B1B2B), white text, 240px width on desktop.

---

### Anatomy

```
┌──────────────────────┐
│  Logo                │ ← 64px height
├──────────────────────┤
│  [Create Record]     │ ← 44px CTA button (gradient)
│                      │
│  Dashboard      [1]  │ ← 48px height (nav item)
│  Records        [3]  │
│  Settings            │
│                      │
│  ⋮  (spacer)         │
│                      │
│  Profile             │ ← Bottom aligned
└──────────────────────┘
    ← 240px width →

Collapsed (64px width):
┌───────┐
│  Logo │
├───────┤
│  [+]  │ ← 44px gradient icon button
│       │
│  🏠   │ ← Icon only
│  📄   │
│  ⚙️   │
│       │
│  👤   │
└───────┘
```

**Parts**:
- Background: #0B1B2B (nav.background)
- Width: 240px (desktop), 64px (collapsed), 0px (mobile)
- Padding: 16px top/bottom, 12px left/right
- Logo area: 64px height
- **Primary CTA: Fixed at top, gradient button (expanded) or icon (collapsed)**
- Nav items: 48px height each

**Design Pattern**: Primary CTA is positioned ABOVE regular navigation items to give it prominence.

---

### Implementation

**CSS**:
```css
.sidebar-nav {
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  width: 240px;
  background: #0B1B2B;
  padding: 16px 12px;
  display: flex;
  flex-direction: column;
  z-index: 1000;
}

.sidebar-logo {
  height: 64px;
  padding: 12px;
  border-bottom: 1px solid #1D3C5A;
  margin-bottom: 16px;
}

.sidebar-nav-items {
  flex: 1;
  overflow-y: auto;
}

/* Responsive */
@media (max-width: 1024px) {
  .sidebar-nav {
    width: 64px; /* Icon-only */
  }
}

@media (max-width: 768px) {
  .sidebar-nav {
    width: 0;
    transform: translateX(-100%);
  }
  
  .sidebar-nav.open {
    transform: translateX(0);
  }
}
```

---

### Navigation Item

### Anatomy

```
┌─────────────────────────────────┐
│  [Icon]  Label  [Badge]         │ ← 48px height
└─────────────────────────────────┘
   ← 16px spacing between parts
```

**Parts**:
- Icon: 20px, white
- Label: 16px, medium (500), white
- Badge: Optional count (12px, teal)
- Padding: 12px all sides
- Border radius: 8px

---

### States

| State | Background | Text | Icon |
|-------|------------|------|------|
| **Default** | Transparent | #FFFFFF | White |
| **Hover** | #142A3F (nav.hover) | #FFFFFF | White |
| **Selected** | #1D3C5A (nav.selected) | #FFFFFF | White |
| **Focus** | Transparent + 2px #2563EB outline | #FFFFFF | White |

---

### Implementation

**CSS**:
```css
.nav-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 12px;
  border-radius: 8px;
  min-height: 48px;
  
  font-family: Inter, sans-serif;
  font-size: 16px;
  font-weight: 500;
  color: #FFFFFF;
  
  cursor: pointer;
  transition: background 200ms ease-out;
  text-decoration: none;
}

.nav-item:hover {
  background: #142A3F;
}

.nav-item.active {
  background: #1D3C5A;
  font-weight: 600;
}

.nav-item-icon {
  width: 20px;
  height: 20px;
  color: #FFFFFF;
}

.nav-item-badge {
  margin-left: auto;
  background: #14B8A6;
  color: #FFFFFF;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
}
```

**Flutter**:
```dart
ListTile(
  leading: Icon(Icons.dashboard, color: Colors.white, size: 20),
  title: Text(
    'Dashboard',
    style: TextStyle(
      fontSize: 16,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      color: Colors.white,
    ),
  ),
  trailing: badge != null
      ? Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Color(0xFF14B8A6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$badge',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        )
      : null,
  selected: isSelected,
  selectedTileColor: Color(0xFF1D3C5A),
  hoverColor: Color(0xFF142A3F),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  contentPadding: EdgeInsets.all(12),
  onTap: () => _navigateTo(route),
)
```

---

### Usage

**DO**:
- ✅ White text on dark background
- ✅ Clear selected state
- ✅ Minimum 48px height items
- ✅ Icon + label for clarity

**DON'T**:
- ❌ Light text colors (use pure white)
- ❌ Too many nav items (group logically)
- ❌ Without clear active state

---

## Modal

### Overview

Centered modal overlay at 50% of dashboard content width (min 560px, max 720px).

---

### Anatomy

```
┌─────────────────────────────────────────────────────┐
│  Overlay (rgba(11, 27, 43, 0.5))                    │
│                                                      │
│     ┌─────────────────────────────────────┐         │
│     │  Modal Header          [X]          │ ← 64px  │
│     ├─────────────────────────────────────┤         │
│     │                                     │         │
│     │  Modal Body                         │         │
│     │  (scrollable if needed)             │         │
│     │                                     │         │
│     ├─────────────────────────────────────┤         │
│     │  [Cancel]     [Primary Action]      │ ← 72px  │
│     └─────────────────────────────────────┘         │
│       ← 50% content width (560-720px) →             │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Parts**:
- Overlay: Semi-transparent dark (#0B1B2B 50% opacity)
- Modal container: White, 12px border radius
- Header: 64px height, close button (icon-only)
- Body: 24px padding, scrollable
- Footer: 72px height, button actions
- Width: 50% of content area (min 560px, max 720px)

---

### Responsive Behavior

| Breakpoint | Width | Behavior |
|------------|-------|----------|
| **>1024px** | 50% content | Min 560px, max 720px |
| **768-1023px** | 60% viewport | Min 480px |
| **<768px** | 100% viewport | Full-screen, no close X (use Cancel) |

---

### Implementation

**CSS**:
```css
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(11, 27, 43, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}

.modal {
  background: #FFFFFF;
  border-radius: 12px;
  width: 50%;
  min-width: 560px;
  max-width: 720px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.modal-header {
  height: 64px;
  padding: 20px 24px;
  border-bottom: 1px solid #E3E8EF;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.modal-title {
  font-size: 20px;
  font-weight: 700;
  color: #1D2633;
}

.modal-close {
  width: 40px;
  height: 40px;
  /* Icon button styles */
}

.modal-body {
  flex: 1;
  padding: 24px;
  overflow-y: auto;
}

.modal-footer {
  height: 72px;
  padding: 16px 24px;
  border-top: 1px solid #E3E8EF;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
}

/* Responsive */
@media (max-width: 1024px) {
  .modal {
    width: 60%;
    min-width: 480px;
  }
}

@media (max-width: 768px) {
  .modal {
    width: 100%;
    min-width: unset;
    max-width: unset;
    height: 100vh;
    max-height: 100vh;
    border-radius: 0;
  }
  
  .modal-close {
    display: none; /* Use Cancel button instead */
  }
}
```

---

### Animation

```css
@keyframes modalOpen {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.modal {
  animation: modalOpen 300ms ease-out;
}
```

---

### Accessibility

**Focus Management**:
- Trap focus inside modal when open
- Focus first interactive element on open
- Return focus to trigger on close
- ESC key closes modal

**Screen Readers**:
```html
<div role="dialog" aria-modal="true" aria-labelledby="modal-title">
  <h2 id="modal-title">Create Record</h2>
  <!-- ... -->
</div>
```

---

### Usage

**DO**:
- ✅ One modal at a time
- ✅ Clear title and action buttons
- ✅ ESC to close
- ✅ Focus trap for keyboard users

**DON'T**:
- ❌ Nested modals
- ❌ Auto-open without user action
- ❌ Critical content without alternative access

---

## Key Section (Rainbow Outline)

### Overview

Spotlight container with rainbow gradient outline for critical information sections.

**CRITICAL**: Use sparingly. Rainbow is ONLY for key sections, not buttons.

---

### Anatomy

```
┌─────────────────────────────────────┐ ← Rainbow gradient outline (3px)
│  Title                              │
│                                     │
│  Content (approval status,          │
│  summary, critical info)            │
│                                     │
└─────────────────────────────────────┘
    ← 12px border radius
```

**Parts**:
- Border: 3px solid, rainbow gradient
- Padding: 16px all sides
- Border radius: 12px
- Background: White

---

### Implementation

**CSS**:
```css
.key-section {
  border-width: 3px;
  border-style: solid;
  border-image: linear-gradient(
    90deg,
    #7C3AED, #2563EB, #06B6D4, #14B8A6, #F59E0B, #F43F5E
  ) 1;
  border-radius: 12px;
  padding: 16px;
  background: #FFFFFF;
}

/* Alternative with border-image-slice */
.key-section-alt {
  position: relative;
  padding: 16px;
  background: #FFFFFF;
  border-radius: 12px;
}

.key-section-alt::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 12px;
  padding: 3px;
  background: linear-gradient(
    90deg,
    #7C3AED, #2563EB, #06B6D4, #14B8A6, #F59E0B, #F43F5E
  );
  -webkit-mask: 
    linear-gradient(#fff 0 0) content-box, 
    linear-gradient(#fff 0 0);
  mask: 
    linear-gradient(#fff 0 0) content-box, 
    linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
}
```

**Flutter**:
```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    gradient: LinearGradient(
      colors: [
        Color(0xFF7C3AED),
        Color(0xFF2563EB),
        Color(0xFF06B6D4),
        Color(0xFF14B8A6),
        Color(0xFFF59E0B),
        Color(0xFFF43F5E),
      ],
    ),
  ),
  padding: EdgeInsets.all(3), // Border width
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(9), // 12 - 3
    ),
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Approval Required',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D2633),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'This record requires approval before activation.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64758B)),
        ),
      ],
    ),
  ),
)
```

---

### Usage

**DO**:
- ✅ Approval status sections
- ✅ Critical summary panels
- ✅ Spotlight information (2-3 per page max)
- ✅ Authorization statements

**DON'T**:
- ❌ NEVER on buttons (use brand-blue gradient)
- ❌ Regular cards (use default borders)
- ❌ Overuse (loses emphasis)
- ❌ Decorative purposes

---

## Table

### Overview

Data table with sortable columns, hover states, and density presets.

---

### Anatomy

```
┌─────────────────────────────────────────────────────┐
│  Column 1 ▼  │  Column 2     │  Column 3          │ ← Header (52px)
├──────────────┼───────────────┼────────────────────┤
│  Data        │  Data         │  Data              │ ← Row (density varies)
│  Data        │  Data         │  Data              │
│  Data        │  Data         │  Data              │
└─────────────────────────────────────────────────────┘
```

**Parts**:
- Header: 52px height, bold text, sort icons
- Rows: Variable height (density preset)
- Borders: 1px solid #E3E8EF
- Padding: 12px left/right per cell

---

### Table Density Presets

**Token Reference**: `table.density.*`

| Preset | Row Height | Usage |
|--------|------------|-------|
| **Compact** | **36px** | Data-dense lists, many rows |
| **Cozy** | **44px** | Default, balanced density |
| **Comfortable** | **52px** | Fewer rows, more whitespace |

**Header Height**: Always 52px (regardless of density)

---

### States

**Row States**:
| State | Background | Border |
|-------|------------|--------|
| **Default** | #FFFFFF | #E3E8EF |
| **Hover** | #EEF2F7 (neutral.200) | #E3E8EF |
| **Selected** | #E3E8EF (neutral.300) | #C2CCDA |

---

### Implementation

**CSS**:
```css
.table {
  width: 100%;
  border-collapse: collapse;
  border: 1px solid #E3E8EF;
  border-radius: 8px;
}

.table-header {
  height: 52px;
  background: #F7F9FC;
  border-bottom: 1px solid #E3E8EF;
}

.table-header-cell {
  padding: 0 12px;
  text-align: left;
  font-size: 14px;
  font-weight: 700;
  color: #1D2633;
}

.table-row {
  height: 44px; /* Cozy preset */
  border-bottom: 1px solid #E3E8EF;
  transition: background 150ms ease;
}

.table-row:hover {
  background: #EEF2F7;
}

.table-cell {
  padding: 0 12px;
  font-size: 14px;
  color: #1D2633;
}

/* Density variants */
.table-compact .table-row { height: 36px; }
.table-cozy .table-row { height: 44px; }
.table-comfortable .table-row { height: 52px; }
```

---

### Usage

**DO**:
- ✅ Use appropriate density for data volume
- ✅ Sortable columns with clear indicators
- ✅ Hover states for row selection
- ✅ 12px horizontal padding per cell

**DON'T**:
- ❌ Rows shorter than 36px
- ❌ Too many columns (horizontal scroll OK)
- ❌ Without header row

---

## Text Input

### Overview

Standard text input field with label, placeholder, and validation states.

---

### Anatomy

```
Label *
┌─────────────────────────────────┐
│  Placeholder text              │ ← 44px height
└─────────────────────────────────┘
Helper text or error message
```

**Parts**:
- Label: 14px, semibold, above input
- Input: 44px height, 12px padding, 8px radius
- Border: 1px solid #E3E8EF
- Placeholder: #9BA8BB (neutral.500)
- Helper text: 12px, #64758B (neutral.600)

---

### States

| State | Border | Background | Text |
|-------|--------|------------|------|
| **Default** | #E3E8EF | #FFFFFF | #1D2633 |
| **Focus** | #2563EB (2px) | #FFFFFF | #1D2633 |
| **Error** | #F43F5E (2px) | #FFFFFF | #1D2633 |
| **Disabled** | #EEF2F7 | #F7F9FC | #C2CCDA |

---

### Implementation

```css
.input-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.input-label {
  font-size: 14px;
  font-weight: 600;
  color: #1D2633;
}

.input-required::after {
  content: ' *';
  color: #F43F5E;
}

.input-field {
  height: 44px;
  padding: 0 12px;
  border: 1px solid #E3E8EF;
  border-radius: 8px;
  background: #FFFFFF;
  
  font-family: Inter, sans-serif;
  font-size: 16px;
  color: #1D2633;
  
  transition: border 200ms ease;
}

.input-field::placeholder {
  color: #9BA8BB;
}

.input-field:focus {
  outline: none;
  border: 2px solid #2563EB;
  padding: 0 11px; /* Adjust for 2px border */
}

.input-field.error {
  border: 2px solid #F43F5E;
}

.input-helper {
  font-size: 12px;
  color: #64758B;
}

.input-error {
  font-size: 12px;
  color: #F43F5E;
}
```

---

### Accessibility

- Always include `<label>` with `for` attribute
- Mark required fields with asterisk
- Error messages with `aria-describedby`
- Minimum 44px height for touch targets

---

## Select/Dropdown

### Overview

Dropdown selector with options menu.

---

### States

Same as text input + open/closed state for menu.

---

### Implementation

```css
.select-field {
  /* Same as input-field */
  position: relative;
  cursor: pointer;
}

.select-arrow {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  pointer-events: none;
}

.select-menu {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  margin-top: 4px;
  background: #FFFFFF;
  border: 1px solid #E3E8EF;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  max-height: 240px;
  overflow-y: auto;
  z-index: 100;
}

.select-option {
  padding: 12px;
  cursor: pointer;
  transition: background 150ms ease;
}

.select-option:hover {
  background: #F7F9FC;
}

.select-option.selected {
  background: #E3E8EF;
  font-weight: 600;
}
```

---

## Checkbox

### Overview

Toggle checkbox with label.

---

### Anatomy

```
☑  Label text
```

**Sizes**:
- Checkbox: 20x20px
- Border radius: 4px
- Checkmark icon: 16px

---

### States

| State | Border | Background | Checkmark |
|-------|--------|------------|-----------|
| **Unchecked** | #E3E8EF | Transparent | - |
| **Checked** | #0F2741 | #0F2741 | White |
| **Indeterminate** | #0F2741 | #0F2741 | White dash |
| **Disabled** | #EEF2F7 | #F7F9FC | #C2CCDA |
| **Focus** | #2563EB (2px offset) | - | - |

---

### Implementation

```css
.checkbox-wrapper {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}

.checkbox {
  width: 20px;
  height: 20px;
  border: 2px solid #E3E8EF;
  border-radius: 4px;
  background: transparent;
  cursor: pointer;
  position: relative;
  transition: all 200ms ease;
}

.checkbox:checked {
  background: #0F2741;
  border-color: #0F2741;
}

.checkbox:checked::after {
  content: '✓';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #FFFFFF;
  font-size: 14px;
}

.checkbox:focus-visible {
  outline: 2px solid #2563EB;
  outline-offset: 2px;
}

.checkbox-label {
  font-size: 16px;
  color: #1D2633;
  cursor: pointer;
}
```

---

## Alert

### Overview

Inline feedback message for success, warning, error, or info states.

---

### Variants

| Type | Background | Border | Icon | Text |
|------|------------|--------|------|------|
| **Success** | #F0FDFA (teal.50) | #14B8A6 | check_circle | #0F766E |
| **Warning** | #FFFBEB (amber.50) | #F59E0B | warning | #B45309 |
| **Error** | #FEF2F2 (red.50) | #F43F5E | error | #BE123C |
| **Info** | #EFF6FF (blue.50) | #2F6BDE | info | #1E40AF |

---

### Implementation

```css
.alert {
  padding: 12px 16px;
  border-radius: 8px;
  border-left: 4px solid;
  display: flex;
  align-items: start;
  gap: 12px;
}

.alert-success {
  background: #F0FDFA;
  border-color: #14B8A6;
  color: #0F766E;
}

.alert-icon {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
}

.alert-message {
  font-size: 14px;
  flex: 1;
}
```

---

## Toast

### Overview

Temporary notification that appears in corner of screen.

---

### Anatomy

```
┌─────────────────────────────────┐
│  [Icon]  Message          [X]   │ ← 56px height
└─────────────────────────────────┘
    ← Max 400px width →
```

**Position**: Bottom-right, 24px from edges  
**Duration**: 4 seconds (auto-dismiss)  
**Animation**: Slide up + fade in

---

### Implementation

```css
.toast {
  position: fixed;
  bottom: 24px;
  right: 24px;
  max-width: 400px;
  padding: 16px;
  background: #FFFFFF;
  border: 1px solid #E3E8EF;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  gap: 12px;
  z-index: 3000;
  
  animation: toastSlideIn 300ms ease-out;
}

@keyframes toastSlideIn {
  from {
    opacity: 0;
    transform: translateY(16px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Variants use same colors as alerts */
.toast-success {
  border-color: #14B8A6;
}
```

---

## Card

### Overview

Simple container for grouped content.

---

### Anatomy

```
┌─────────────────────────────────┐
│  Content                        │
│                                 │
│                                 │
└─────────────────────────────────┘
```

**Parts**:
- Background: #FFFFFF
- Border: 1px solid #E3E8EF
- Border radius: 8px
- Padding: 16px
- Shadow: Minimal (0 1px 3px rgba(0,0,0,0.1))

---

### Implementation

```css
.card {
  background: #FFFFFF;
  border: 1px solid #E3E8EF;
  border-radius: 8px;
  padding: 16px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.card-header {
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid #E3E8EF;
}

.card-title {
  font-size: 18px;
  font-weight: 700;
  color: #1D2633;
}

.card-body {
  font-size: 14px;
  color: #64758B;
}
```

---

## Implementation Checklist

Before launching:

- [ ] Brand-blue gradient on primary buttons (NOT rainbow)
- [ ] Rainbow outline ONLY on key sections (2-3 per page max)
- [ ] Dark navigation (#0B1B2B) with white text
- [ ] Modal 50% width (560-720px constraints)
- [ ] Table density presets (36/44/52px)
- [ ] Teal success color (#14B8A6)
- [ ] All interactive elements ≥40px touch targets
- [ ] 2px focus rings (#2563EB) on all interactive elements
- [ ] Text inputs 44px height minimum
- [ ] Hover states on all clickable elements

---

## Resources

- **Tokens**: `03-design-tokens.yaml`
- **Style Guide**: `04-ui-style-guide.md`
- **Moodboard**: `inspiration/moodboard/`
- **Wireframes**: `inspiration/low-fi-wireframes/`

---

**Last Updated**: January 15, 2026  
**Version**: 2.0.0 (Governance Portal Dashboard)
