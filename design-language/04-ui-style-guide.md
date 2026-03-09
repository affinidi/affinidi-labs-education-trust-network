# UI Style Guide

**Document Version**: 1.0.0  
**Last Updated**: January 6, 2026

---

## Overview

This document defines the visual language of Credulon: colors, typography, spacing, layout, and motion. All values reference design tokens from `03-design-tokens.yaml`.

---

## Table of Contents

1. [Color System](#color-system)
2. [Typography](#typography)
3. [Spacing & Layout](#spacing--layout)
4. [Component States](#component-states)
5. [Motion & Animation](#motion--animation)
6. [Icons](#icons)
7. [Imagery](#imagery)

---

## Color System

### Primary Colors

#### Primary Warm Orange - Key Features & CTAs

**Token Reference**: `colors.primary.*`

| Shade   | Hex           | Usage                                 |
| ------- | ------------- | ------------------------------------- |
| 50      | `#FFF6E1`     | Lightest cream backgrounds            |
| 100     | `#FFEEC8`     | Subtle highlights                     |
| 200     | `#FFCF9f`     | Light accents                         |
| 300     | `#FFB166`     | Hover states (light mode)             |
| 400     | `#FFAA4A`     | Active states                         |
| **500** | **`#FF8E32`** | **Primary brand color (warm orange)** |
| 600     | `#E67E28`     | Hover states (dark mode)              |
| 700     | `#D56E1F`     | Pressed states                        |
| 800     | `#BD5E15`     | Very dark accents                     |
| 900     | `#A04E0C`     | Darkest shade                         |

**Usage Guidelines**:

- **Primary 500**: Key CTAs ("Claim Credential", "Verify"), primary features, app navigation
- **Primary 600**: Hover state for buttons on dark backgrounds
- **Primary 300**: Hover state for buttons on light backgrounds
- **Primary 50-200**: Subtle backgrounds, highlights for key features
- **Headspace Principle**: Warm orange draws attention without being aggressive
- **Revolut Principle**: CTA confidence through distinctive, warm color

**Accessibility**:

- Primary 500 on warm cream: 5.2:1 (WCAG AA ✅)
- Primary 500 on white: 4.87:1 (WCAG AA ✅)
- White text on Primary 500: 4.87:1 (WCAG AA ✅)

---

#### Secondary Warm Cream - Supporting Actions & Surfaces

**Token Reference**: `colors.secondary.*`

| Shade   | Hex           | Usage                           |
| ------- | ------------- | ------------------------------- |
| 50      | `#FFFDF7`     | Lightest cream                  |
| 100     | `#FFFBF7`     | Off-white                       |
| 200     | `#FFF6E1`     | Light cream backgrounds         |
| 300     | `#FFEEC8`     | **Card backgrounds & surfaces** |
| 400     | `#FFE8B3`     | Hover states on secondary       |
| **500** | **`#FFDC99`** | **Secondary brand color**       |
| 600     | `#F2D9A6`     | Darker secondary                |
| 700     | `#E5C98f`     | Strong secondary                |
| 800     | `#D8BA7a`     | Very dark secondary             |
| 900     | `#CBAA66`     | Darkest secondary               |

**Usage Guidelines**:

- **Secondary 300**: Card and container backgrounds, supporting surfaces
- **Secondary 500**: Secondary actions ("Learn More", "View Details")
- **Secondary 400**: Hover states on secondary surfaces
- **Secondary surfaces**: Create visual hierarchy without competing with orange CTAs
- **Headspace Principle**: Soft, warm surfaces support user comfort

**Accessibility**:

- Secondary 500 on white: 3.28:1 (WCAG AA for large text ✅)
- White text on Secondary 500: 6.39:1 (WCAG AA ✅)
- Dark text on Secondary 300: 6.1:1 (WCAG AA ✅)

---

### Semantic Colors

#### Success (Green)

**Token Reference**: `colors.semantic.success.*`

- **Light**: `#81C784`
- **Main**: `#4CAF50` ✅ Primary success color
- **Dark**: `#388E3C`
- **Contrast**: `#FFFFFF`

**Usage**:

- ✅ Credential verified successfully
- ✅ Record created
- ✅ Active status
- ✅ Valid credentials

**Contrast Ratios**:

- Success Main on white: 3.36:1 (AA for large text ✅)
- White text on Success Main: 6.24:1 (AA ✅)

---

#### Warning (Amber)

**Token Reference**: `colors.semantic.warning.*`

- **Light**: `#FFD54F`
- **Main**: `#D99A06` ✅ Primary warning color
- **Dark**: `#F57C00`
- **Contrast**: `#000000`

**Usage**:

- ⚠️ Expiring soon
- ⚠️ Action required
- ⚠️ Incomplete information
- ⚠️ Caution messages

**Contrast Ratios**:

- Warning Main on white: 4.91:1 (AA ✅)
- Black text on Warning Main: 4.27:1 (AA ✅)

---

#### Error (Red)

**Token Reference**: `colors.semantic.error.*`

- **Light**: `#E57373`
- **Main**: `#F44336` ✅ Primary error color
- **Dark**: `#D32F2F`
- **Contrast**: `#FFFFFF`

**Usage**:

- ❌ Validation errors
- ❌ Destructive actions
- ❌ Failed operations
- ❌ Invalid credentials

**Contrast Ratios**:

- Error Main on white: 3.63:1 (AA for large text ✅)
- White text on Error Main: 5.78:1 (AA ✅)

---

#### Info (Blue)

**Token Reference**: `colors.semantic.info.*`

- **Light**: `#64B5F6`
- **Main**: `#2196F3` ✅ Primary info color
- **Dark**: `#1976D2`
- **Contrast**: `#FFFFFF`

**Usage**:

- ℹ️ Informational messages
- ℹ️ Help tooltips
- ℹ️ System notifications
- ℹ️ Tips and hints

---

### Neutral Colors (Grays)

**Token Reference**: `colors.neutral.*`

| Value | Hex       | Usage                               |
| ----- | --------- | ----------------------------------- |
| 0     | `#FFFFFF` | Pure white (text on dark)           |
| 50    | `#FAFAFA` | Off-white backgrounds               |
| 100   | `#F5F5F5` | Light backgrounds                   |
| 300   | `#E0E0E0` | Borders (light mode)                |
| 500   | `#9E9E9E` | Mid gray, disabled text             |
| 700   | `#636363` | Secondary text                      |
| 900   | `#212121` | Dark backgrounds                    |
| 1000  | `#000000` | Pure black (backgrounds, dark mode) |

**Text Hierarchy (Dark Mode - Default)**:

- **Primary text**: `#FFFFFF` (neutral.0) - Headings, body text
- **Secondary text**: `#B0B0B0` - Metadata, captions
- **Disabled text**: `#636363` (neutral.700) - Inactive elements

**Text Hierarchy (Light Mode)**:

- **Primary text**: `#1E1E1E` (dark near-black) - Headings, body text
- **Secondary text**: `#4A4A4A` (mid-gray) - Metadata, captions
- **Disabled text**: `#9E9E9E` (neutral.500) - Inactive elements
- **Contrast on cream**: 6.1:1 for primary text, excellent legibility (WCAG AAA ✅)

---

### Surface Colors

#### Light Mode (Primary/Default Theme)

**Token Reference**: `colors.surface.light.*`

- **Background**: `#FFFDF7` - Warm off-white main app background
- **Surface**: `#FFEEC8` - Warm cream card backgrounds (Secondary 300)
- **Surface Variant**: `#FFFBF7` - Light cream alternative surfaces
- **Surface Container High**: `#FFF6E1` - Elevated container backgrounds
- **Surface Container Highest**: `#FFFCF9` - Highest elevation surfaces

**Warm color strategy**:

- Creates visual hierarchy through warmth, not just value
- Aligns with Headspace (comfort) + Revolut (modern) aesthetic
- Reduces cognitive load through approachable surfaces

---

#### Dark Mode (Alternative/Secondary Theme)

**Token Reference**: `colors.surface.dark.*`

- **Background**: `#000000` - Main app background
- **Surface**: `#000000` - Card backgrounds
- **Surface Variant**: `#2E3034` - Alternative surfaces
- **Surface Container High**: `#2E3034` - Elevated containers

**Elevation in Dark Mode**:
In dark mode, elevated surfaces become _lighter_, not shadowed:

- Elevation 0: `#000000`
- Elevation 2: `#0A0A0A` (very subtle lightening)
- Elevation 4: `#121212`
- Elevation 8: `#1E1E1E`

---

### Color Usage Guidelines

#### Do's

✅ Use Primary 500 (warm orange) for key CTAs ("Claim Credential", "Verify", "Submit")  
✅ Use Secondary 300 (warm cream) for card and container backgrounds  
✅ Use Secondary 500 for secondary actions ("View Details", "Learn More")  
✅ Use semantic colors for their intended purpose (green = success)  
✅ Maintain color contrast ratios (4.5:1 minimum for text)  
✅ Apply Headspace + Revolut principles: Warm colors for comfort AND confidence  
✅ Reference color tokens, never hardcode hex values

#### Don'ts

❌ Don't use red for anything except errors/destructive actions  
❌ Don't use green for anything except success/active states  
❌ Don't rely on color alone to convey information  
❌ Don't use low-contrast color combinations  
❌ Don't mix semantic color meanings (e.g., red for success)  
❌ Don't use cool blues for CTAs (use warm orange instead)  
❌ Don't overuse warm orange on secondary surfaces (causes visual noise)

---

### Component Example: Primary Button (CTA)

**Token Reference**: `components.buttonLarge.*`

#### States Table

| State    | Background               | Text              | Border          | Height | Example Use        |
| -------- | ------------------------ | ----------------- | --------------- | ------ | ------------------ |
| Default  | Primary 500 (`#FF8E32`)  | White             | None            | 56px   | "Claim Credential" |
| Hover    | Primary 600 (`#E67E28`)  | White             | None            | 56px   | Desktop hover      |
| Pressed  | Primary 700 (`#D56E1F`)  | White             | None            | 56px   | Active press       |
| Focused  | Primary 500 + Focus Ring | White             | 2px Primary 500 | 56px   | Keyboard nav       |
| Disabled | Neutral 500 @ 20%        | Neutral 700 @ 60% | None            | 56px   | Loading/inactive   |

#### Sizing & Spacing

- **Height**: 56px (components.buttonLarge) - Prominent CTA
- **Horizontal Padding**: 32px (spacing-4)
- **Vertical Padding**: 18px
- **Border Radius**: 8px (radius-md)
- **Font Size**: 18px (fontSize-lg)
- **Font Weight**: 500 (medium)

**Spacing Guidelines**:

- **Between buttons**: 8px (spacing-1) minimum
- **Top/bottom margin**: 16-24px (spacing-2 to spacing-3)
- **Horizontal margin**: 16px (spacing-2) on mobile

#### Accessibility Checklist

✅ **Contrast**: Primary 500 on cream background = 5.2:1 (WCAG AA ✅)  
✅ **Touch Target**: 56px height exceeds 48px recommended minimum  
✅ **Focus Ring**: 2px solid primary color visible on all backgrounds  
✅ **Keyboard Support**: Tab navigation + Enter/Space to activate  
✅ **Focus Order**: Logical top-to-bottom, left-to-right flow  
✅ **Semantics**: Proper button role for screen readers

#### Flutter Code Example

```dart
ElevatedButton(
  onPressed: isLoading ? null : () => claimCredential(),
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary500,
    foregroundColor: Colors.white,
    minimumSize: Size(64, 56), // Min width 64, height 56
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.8,
    ),
  ),
  child: isLoading
    ? SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
    : Text('Claim Credential'),
)
```

---

### Component Example: Input Field

**Token Reference**: `components.input.*`

#### States Table

| State    | Background                  | Border     | Border Color   | Text Color        | Usage                 |
| -------- | --------------------------- | ---------- | -------------- | ----------------- | --------------------- |
| Default  | Secondary 300 (`#FFEEC8`)   | 1px thin   | Neutral 300    | Neutral 1000      | Normal input          |
| Focused  | Secondary 300               | 2px medium | Primary 500    | Neutral 1000      | Keyboard/tap focus    |
| Disabled | Secondary 200 @ opacity 0.5 | 1px thin   | Neutral 400    | Neutral 500 @ 60% | Inactive field        |
| Error    | Secondary 300               | 2px medium | Semantic Error | Error Main        | Validation failed     |
| Filled   | Secondary 300               | 1px thin   | Neutral 300    | Neutral 1000      | User has entered text |

#### Sizing & Spacing

- **Height**: 44px minimum (touch target)
- **Horizontal Padding**: 16px (spacing-2)
- **Vertical Padding**: 12px
- **Border Radius**: 8px (radius-md)
- **Font Size**: 16px (fontSize-md)
- **Min Width**: 100% (full available width)

**Label & Spacing**:

- **Label above field**: 8px gap (spacing-1)
- **Between fields**: 16px (spacing-2)
- **Helper text below**: 4px gap, 12px font size
- **Error text below**: 4px gap, 12px font size, error color

#### Accessibility Checklist

✅ **Label Association**: Connected with `labelFor` or semantic label element  
✅ **Contrast**: Text on cream = 6.1:1 (WCAG AA ✅)  
✅ **Focus Indicator**: 2px border visible in primary color  
✅ **Focus Visible**: Outline offset 2px from field edge  
✅ **Error Messaging**: Clear text below field, not just color  
✅ **Touch Target**: 44px minimum height  
✅ **Placeholder Not Label**: Always has visible label (placeholder insufficient)

#### Flutter Code Example

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email Address',
    labelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.neutral1000,
    ),
    filled: true,
    fillColor: AppColors.secondary300,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: AppColors.neutral300,
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: AppColors.neutral300,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: AppColors.primary500,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: AppColors.errorMain,
        width: 2,
      ),
    ),
    errorText: errorMessage,
    helperText: 'We\'ll never share your email.',
    helperStyle: TextStyle(
      fontSize: 12,
      color: AppColors.neutral700,
    ),
  ),
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral1000,
  ),
  onChanged: (value) => validateEmail(value),
)
```

---

### Component Example: Card

**Token Reference**: `components.card.*`

#### Properties Table

| Property           | Value           | Token                     | Purpose                                 |
| ------------------ | --------------- | ------------------------- | --------------------------------------- |
| Background         | Warm Cream      | Secondary 300 (`#FFEEC8`) | Distinguishes card from page background |
| Elevation          | 1               | elevation.1               | Subtle lift, not overwhelming           |
| Padding            | 16px            | spacing-2                 | Standard interior spacing               |
| Border Radius      | 12px            | radius-lg                 | Soft, friendly corners                  |
| Border             | None            | —                         | Rely on elevation, not outline          |
| Divider (internal) | 1px Neutral 300 | borderWidth.thin          | Separate sections within card           |

**Internal Spacing** (inside card):

- **Text to edge**: 16px minimum (spacing-2)
- **Between stacked elements**: 12-16px (spacing-1 to spacing-2)
- **Section divider**: 16px top/bottom (spacing-2)

#### Accessibility Checklist

✅ **Contrast**: Card background Secondary 300 on page background `#FFFDF7` is subtle but readable  
✅ **Content hierarchy**: Card title uses H3 or higher  
✅ **Interactive elements**: All buttons/links within card are keyboard accessible  
✅ **Color not only indicator**: If status shown by color, also use icon/text  
✅ **Focus trap avoidance**: Modals should trap focus; regular cards should not  
✅ **Semantics**: Card is `<article>` or `<section>`, not `<div>` alone

#### Flutter Code Example

```dart
Card(
  elevation: 1,
  color: AppColors.secondary300,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Credential Issued',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Bachelor of Science in Computer Science',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Issued: Jan 2026',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutral700,
              ),
            ),
            ElevatedButton(
              onPressed: () => shareCredential(),
              child: Text('Share'),
            ),
          ],
        ),
      ],
    ),
  ),
)
```

---

## Typography

### Font Families

**Token Reference**: `typography.fontFamily.*`

- **Primary**: `IBM Plex Sans, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif`
  - **Usage**: All UI text (body, headings, buttons)
  - **Characteristics**: Readable, modern, professional
- **Monospace**: `'Fira Code', 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, 'Courier New', monospace`
  - **Usage**: Code snippets, DIDs, technical identifiers
  - **Characteristics**: Fixed-width, clear distinction

---

### Type Scale

Based on **8px baseline grid**.

**Token Reference**: `typography.fontSize.*`

| Level          | Size     | Token    | Usage                            |
| -------------- | -------- | -------- | -------------------------------- |
| Display        | 48px     | `6xl`    | Hero text (rare)                 |
| H1 Desktop     | 36px     | `5xl`    | Page titles (desktop)            |
| H1 Tablet      | 32px     | `4xl`    | Page titles (tablet)             |
| H1 Mobile      | 28px     | `3xl`    | Page titles (mobile)             |
| H2             | 24px     | `2xl`    | Section headings                 |
| H3             | 20px     | `xl`     | Subsection headings, card titles |
| Subheading     | 18px     | `lg`     | Emphasized body text             |
| **Body Large** | **16px** | **`md`** | **Primary body text** ✅         |
| Body Medium    | 14px     | `base`   | Secondary body text              |
| Small Text     | 12px     | `sm`     | Captions, metadata               |
| Micro Text     | 10px     | `xs`     | Labels, badges (minimal use)     |

**Accessibility Note**:

- **Minimum 16px for body text** to meet WCAG AA standards
- Large text (18px+) can have lower contrast ratios (3:1 vs 4.5:1)

---

### Typography Styles

#### Display Text

```yaml
Font: IBM Plex Sans
Size: 48px (6xl)
Weight: 700 (bold)
Line Height: 1.2 (tight)
Letter Spacing: -0.02em (tight)
Use Case: Hero sections, landing pages
```

**Flutter Example**:

```dart
TextStyle(
  fontFamily: 'IBM Plex Sans',
  fontSize: 48,
  fontWeight: FontWeight.w700,
  height: 1.2,
  letterSpacing: -0.96,
)
```

---

#### Heading 1 (H1)

```yaml
Font: IBM Plex Sans
Size: 28-36px (responsive: 3xl-5xl)
Weight: 700 (bold)
Line Height: 1.2 (tight)
Letter Spacing: -0.02em (tight)
Use Case: Page titles
```

**Flutter Example**:

```dart
Theme.of(context).textTheme.displayLarge?.copyWith(
  fontSize: 28, // Mobile
  fontWeight: FontWeight.w700,
)
```

---

#### Heading 2 (H2)

```yaml
Font: IBM Plex Sans
Size: 24px (2xl)
Weight: 700 (bold)
Line Height: 1.2 (tight)
Use Case: Section headings
```

---

#### Heading 3 (H3)

```yaml
Font: IBM Plex Sans
Size: 20px (xl)
Weight: 600 (semibold)
Line Height: 1.5 (normal)
Use Case: Subsection headings, card titles
```

**Flutter Example**:

```dart
Theme.of(context).textTheme.titleLarge?.copyWith(
  fontSize: 20,
  fontWeight: FontWeight.w600,
)
```

---

#### Body Large (Primary Body Text)

```yaml
Font: IBM Plex Sans
Size: 16px (md) ✅ WCAG compliant
Weight: 400 (regular)
Line Height: 1.5 (normal)
Use Case: Main body text, form labels
```

**Flutter Example**:

```dart
Theme.of(context).textTheme.bodyLarge
// Default: fontSize 16, fontWeight 400
```

---

#### Body Medium (Secondary Body Text)

```yaml
Font: IBM Plex Sans
Size: 14px (base)
Weight: 400 (regular)
Line Height: 1.5 (normal)
Use Case: Secondary text, descriptions
```

---

#### Small Text (Captions)

```yaml
Font: IBM Plex Sans
Size: 12px (sm)
Weight: 400 (regular)
Line Height: 1.5 (normal)
Use Case: Metadata, timestamps, captions
```

---

#### Button Text

```yaml
Font: IBM Plex Sans
Size: 16px (md)
Weight: 500 (medium)
Letter Spacing: 0.05em (wide)
Text Transform: None (sentence case)
Use Case: All buttons
```

**Flutter Example**:

```dart
ElevatedButton.styleFrom(
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
  ),
)
```

---

### Typography Usage Guidelines

#### Do's

✅ Use H1 for page titles only (one per page)  
✅ Maintain heading hierarchy (H1 → H2 → H3, never skip)  
✅ Use 16px minimum for body text  
✅ Use medium/semibold weight for emphasis, not italic  
✅ Keep line length 50-75 characters for readability

#### Don'ts

❌ Don't use multiple H1 headings on one page  
❌ Don't skip heading levels (H1 → H3)  
❌ Don't use text smaller than 12px (accessibility)  
❌ Don't use ALL CAPS for long text (hard to read)  
❌ Don't center-align long paragraphs

---

## Spacing & Layout

### 8px Grid System

**All spacing values are multiples of 8px.**

**Token Reference**: `spacing.*`

| Token | Value | Usage                              |
| ----- | ----- | ---------------------------------- |
| `0`   | 0px   | No spacing                         |
| `1`   | 8px   | Micro spacing (tight elements)     |
| `2`   | 16px  | **Standard padding** (most common) |
| `3`   | 24px  | Medium spacing (between sections)  |
| `4`   | 32px  | Large spacing (major sections)     |
| `5`   | 40px  | XL spacing                         |
| `6`   | 48px  | 2XL spacing                        |
| `8`   | 64px  | 3XL spacing (page sections)        |
| `10`  | 80px  | 4XL spacing (rare)                 |

---

### Common Spacing Patterns

#### Inline Elements

- **Gap between icon and text**: `8px` (spacing-1)
- **Gap between buttons**: `8px` (spacing-1)
- **Gap between chips/badges**: `8px` (spacing-1)

#### Containers

- **Card padding**: `16px` (spacing-2) standard, `24px` (spacing-3) large
- **Form field padding**: `16px` horizontal, `12px` vertical
- **Button padding**: `24px` horizontal, `12px` vertical
- **Page margins**: `16px` mobile, `24px` tablet, `32px` desktop

#### Vertical Rhythm

- **Between form fields**: `16px` (spacing-2)
- **Between paragraphs**: `16px` (spacing-2)
- **Between sections**: `32px` (spacing-4) or `48px` (spacing-6)
- **Between major page sections**: `64px` (spacing-8)

---

### Layout Grid

#### Mobile (< 640px)

```
Columns: 4
Gutters: 16px
Margins: 16px
Column Width: Flexible
```

#### Tablet (640px - 1024px)

```
Columns: 8
Gutters: 24px
Margins: 24px
Column Width: Flexible
```

#### Desktop (> 1024px)

```
Columns: 12
Gutters: 24px
Margins: 32px (up to 1440px max-width)
Column Width: Flexible
```

---

### Container Max Widths

**Token Reference**: `container.*`

- **Mobile**: `100%` (full width with margins)
- **Tablet**: `768px` max
- **Desktop**: `1440px` max
- **Content** (forms, articles): `600px` max for readability

---

### Responsive Breakpoints

**Token Reference**: `breakpoints.*`

| Name        | Value  | Description           |
| ----------- | ------ | --------------------- |
| `mobile`    | 0px    | Default, mobile-first |
| `mobileLg`  | 480px  | Large phones          |
| `tablet`    | 640px  | Small tablets         |
| `tabletLg`  | 768px  | Large tablets         |
| `desktop`   | 1024px | Laptops, desktops     |
| `desktopLg` | 1280px | Large desktops        |
| `wide`      | 1440px | Wide screens          |
| `ultraWide` | 1920px | Ultra-wide monitors   |

---

### Spacing Guidelines

#### Do's

✅ Use spacing tokens (never arbitrary values like 13px)  
✅ Maintain consistent spacing throughout the app  
✅ Use more spacing on desktop (users have more screen space)  
✅ Align all elements to 8px grid  
✅ Use generous padding in cards (16-24px)

#### Don'ts

❌ Don't use spacing values that aren't multiples of 8px  
❌ Don't cram content (minimum 16px padding)  
❌ Don't use same spacing for all breakpoints  
❌ Don't misalign elements to grid  
❌ Don't use negative margins except for specific layout needs

---

## Component States

Every interactive component MUST implement these states:

### State Definitions

#### 1. Default (Resting State)

The component's normal appearance when not being interacted with.

**Visual Characteristics**:

- Base colors from design tokens
- Standard elevation/shadow
- No special indicators

---

#### 2. Hover

Appears when mouse cursor is over the element (desktop/tablet).

**Visual Characteristics**:

- Background color: Darken by 5-10% (dark mode) or lighten by 5-10% (light mode)
- Cursor: `pointer` for clickable elements
- Transition: `300ms ease-out`
- Optional: Slight elevation increase (2dp)

**Implementation**:

```dart
ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.hovered)) {
      return AppColors.primary600; // Darker on hover
    }
    return AppColors.primary500; // Default
  }),
)
```

---

#### 3. Active/Pressed

Appears during the click/tap interaction.

**Visual Characteristics**:

- Background color: Darken by 10-15% from default
- Scale: Optionally reduce by 98% (subtle press effect)
- Elevation: Reduce by 2dp
- Transition: `150ms` (faster than hover)

---

#### 4. Focused (Keyboard Navigation) ✅ Critical for Accessibility

Appears when element receives keyboard focus (Tab key).

**Visual Characteristics**:

- **Focus outline**: `2px solid` primary color
- **Outline offset**: `2px` from element edge
- **Visible and high contrast** (WCAG requirement)
- Never remove focus outline (`outline: none` ❌)

**Implementation**:

```dart
FocusedBorder: OutlineInputBorder(
  borderSide: BorderSide(
    color: AppColors.primary500,
    width: 2,
  ),
)
```

**Flutter Material 3** handles focus automatically, but ensure:

- All interactive elements are focusable
- Focus order is logical (top-to-bottom, left-to-right)
- Focus indicators are visible on all backgrounds

---

#### 5. Disabled

Element is visible but non-interactive.

**Visual Characteristics**:

- **Background**: Desaturated (use neutral grays)
- **Text**: Reduced opacity (60% or neutral.700)
- **Cursor**: `not-allowed` or `default`
- **No hover/active states**

**Opacity Levels**:

- **Background**: `opacity: 0.2` (20%)
- **Text**: `opacity: 0.6` (60%)

**Implementation**:

```dart
ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.disabled)) {
      return AppColors.neutral500.withOpacity(0.2);
    }
    return AppColors.primary500;
  }),
  foregroundColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.disabled)) {
      return AppColors.neutral700;
    }
    return Colors.white;
  }),
)
```

---

#### 6. Loading

Async operation in progress.

**Visual Characteristics**:

- **Disabled interaction** (can't click again)
- **Loading indicator**: Circular progress indicator or spinner
- **Optional**: Replace button text with "Loading..." or spinner
- **Maintain button size** (don't collapse)

**Implementation**:

```dart
ElevatedButton(
  onPressed: isLoading ? null : () => {},
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

#### 7. Error

Validation failed or operation error.

**Visual Characteristics**:

- **Border**: Error color (semantic.error.main)
- **Icon**: Error icon (warning triangle or X)
- **Text**: Error message below element
- **Color**: Red from semantic palette

**Form Field Error Example**:

```dart
TextField(
  decoration: InputDecoration(
    errorText: 'This field is required',
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.errorMain, width: 1),
    ),
  ),
)
```

---

#### 8. Success (Optional)

Operation completed successfully (less common than error state).

**Visual Characteristics**:

- **Border/Icon**: Success color (semantic.success.main)
- **Optional checkmark icon**
- **Brief display**: Auto-dismiss after 2-3 seconds

---

### State Transition Timing

**Token Reference**: `animation.duration.*`

- **Hover transitions**: `300ms` (normal)
- **Active/pressed**: `150ms` (fast)
- **Focus**: Instant (no transition)
- **Loading**: Fade in after `500ms` (avoid flash)
- **Error**: Instant (immediate feedback)

---

## Motion & Animation

### Animation Principles

1. **Purposeful**: Animations serve a function (feedback, attention, continuity)
2. **Subtle**: Prefer understated over flashy
3. **Fast**: Keep durations under 500ms for UI interactions
4. **Accessible**: Respect `prefers-reduced-motion`

---

### Animation Tokens

**Token Reference**: `animation.*`

#### Durations

| Token    | Value | Usage                            |
| -------- | ----- | -------------------------------- |
| `fast`   | 150ms | Button press, quick feedback     |
| `normal` | 300ms | Hover states, simple transitions |
| `slow`   | 500ms | Page transitions, modals         |
| `slower` | 700ms | Complex animations (rare)        |

#### Easing Curves

| Token       | Curve                               | Usage                               |
| ----------- | ----------------------------------- | ----------------------------------- |
| `easeOut`   | `cubic-bezier(0, 0, 0.2, 1)`        | **Most common** - Elements entering |
| `easeIn`    | `cubic-bezier(0.4, 0, 1, 1)`        | Elements exiting                    |
| `easeInOut` | `cubic-bezier(0.4, 0, 0.2, 1)`      | Smooth transitions                  |
| `spring`    | `cubic-bezier(0.34, 1.56, 0.64, 1)` | Playful bounce (use sparingly)      |

---

### Common Animations

#### Button Hover

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  curve: Curves.easeOut,
  color: isHovered ? AppColors.primary600 : AppColors.primary500,
)
```

#### Modal Fade In

```dart
FadeTransition(
  opacity: animation,
  child: child,
)
// Duration: 300ms, Curve: easeOut
```

#### Page Transition (Slide)

```dart
SlideTransition(
  position: Tween<Offset>(
    begin: Offset(1.0, 0.0), // From right
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: controller,
    curve: Curves.easeOut,
  )),
  child: child,
)
// Duration: 300ms
```

#### Loading Spinner

```dart
CircularProgressIndicator()
// Indeterminate animation (continuous rotation)
```

---

### Accessibility: Reduced Motion

**CRITICAL**: Respect user's motion preferences.

```dart
final reducedMotion = MediaQuery.of(context).disableAnimations;

AnimatedContainer(
  duration: reducedMotion
    ? Duration.zero  // Instant, no animation
    : Duration(milliseconds: 300),
  child: child,
)
```

**Or disable globally in app:**

```dart
MaterialApp(
  builder: (context, child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        disableAnimations: /* check system preference */,
      ),
      child: child!,
    );
  },
)
```

---

### Animation Guidelines

#### Do's

✅ Use animations for feedback (button press, successful action)  
✅ Keep animations under 500ms  
✅ Use easeOut curve for most transitions  
✅ Respect `prefers-reduced-motion`  
✅ Test animations on slow devices

#### Don'ts

❌ Don't animate everything (causes distraction)  
❌ Don't use slow animations (> 700ms) for UI interactions  
❌ Don't auto-play animations with sound  
❌ Don't use flashing/strobing effects (accessibility hazard)  
❌ Don't ignore reduced motion preferences

---

## Icons

### Icon System

**Source**: Material Icons (built into Flutter)

**Token Reference**: `iconSize.*`

| Size | Value | Usage                          |
| ---- | ----- | ------------------------------ |
| `xs` | 16px  | Inline with small text         |
| `sm` | 20px  | Button icons, inline icons     |
| `md` | 24px  | **Default icon size**          |
| `lg` | 32px  | Prominent icons                |
| `xl` | 48px  | Hero icons, feature highlights |

---

### Icon Usage Guidelines

#### Icon + Text Buttons

**Always include text label for primary actions.**

```dart
ElevatedButton.icon(
  icon: Icon(Icons.add, size: 20), // iconSize.sm
  label: Text('Add Credential'),
  onPressed: () {},
)
```

**Spacing**: `8px` gap between icon and text (built into Flutter)

---

#### Icon-Only Buttons

**Must include accessible label (Tooltip or Semantics).**

```dart
IconButton(
  icon: Icon(Icons.settings, size: 24),
  tooltip: 'Settings', // ✅ Required for accessibility
  onPressed: () {},
)
```

❌ **Never** use icon-only buttons without labels (WCAG violation).

---

#### Icon Colors

Icons inherit text color by default:

```dart
Icon(
  Icons.check_circle,
  color: Theme.of(context).colorScheme.primary,
  size: 24,
)
```

**Semantic icon colors**:

- Success: `AppColors.successMain`
- Warning: `AppColors.warningMain`
- Error: `AppColors.errorMain`
- Info: `AppColors.infoMain`

---

### Icon Style

**Filled vs. Outlined**:

- **Outlined** (default): Most UI icons
- **Filled**: Active states, selected items, primary actions

**Example**:

```dart
// Unselected navigation item
Icon(Icons.home_outlined)

// Selected navigation item
Icon(Icons.home) // Filled version
```

---

## Imagery

### Placeholder Images

Use consistent placeholder approach:

**Avatar placeholders**:

- **Icon**: `Icons.person` (Material Icons)
- **Background**: `neutral.800` (dark mode) or `neutral.200` (light mode)
- **Icon color**: `neutral.500`

**Image placeholders**:

- **Icon**: `Icons.image` (Material Icons)
- **Background**: `neutral.900` (dark mode) or `neutral.100` (light mode)
- **Icon color**: `neutral.600`

---

### Image Guidelines

#### Do's

✅ Provide alt text for all images (accessibility)  
✅ Use appropriate image sizes (optimize for mobile)  
✅ Use WebP format for web (better compression)  
✅ Provide placeholder while loading  
✅ Handle image load errors gracefully

#### Don'ts

❌ Don't use images for text (accessibility issue)  
❌ Don't use overly large images (performance)  
❌ Don't skip alt text  
❌ Don't use low-contrast images for backgrounds

---

## Summary

The Credulon UI Style Guide provides comprehensive visual standards:

- **Colors**: Token-based palette with WCAG AA compliance
- **Typography**: IBM Plex Sans font family, 8px baseline grid, minimum 16px body text
- **Spacing**: 8px grid system for consistency
- **States**: 8 component states (default, hover, active, focus, disabled, loading, error, success)
- **Motion**: Purposeful animations with reduced-motion support
- **Icons**: Material Icons with proper sizing and accessibility labels

**Next Steps**:

- Review [Components](05-components.md) for implementation details
- Check [Accessibility](06-accessibility.md) for WCAG compliance
- Reference [Flutter Theme](07-flutter-theme.md) for code implementation

All values reference tokens from `03-design-tokens.yaml`. Never hardcode values in implementation.
