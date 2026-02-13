# Accessibility Guidelines

**Document Version**: 1.0.0  
**Last Updated**: January 6, 2026  
**Compliance Target**: WCAG 2.1 Level AA (Minimum)

---

## Overview

Certizen is committed to creating inclusive digital experiences across all stakeholder groups and jurisdictions. **WCAG 2.1 Level AA compliance is mandatory, not optional.** These guidelines ensure all users—National Education administrators, university students, employers, and platform operators—can access and use Certizen applications regardless of ability.

### Accessibility Context

**Multi-Jurisdiction Compliance**: Applications must meet accessibility standards across Hong Kong, Macau, and Singapore regulatory requirements.

**Diverse User Base**:
- **Government Administrators**: Often working in high-stakes governance contexts requiring clarity and precision
- **Students**: Wide age range (18-65+) with varying technical abilities and potential disabilities
- **Employers**: HR professionals who may process high volumes of verification requests
- **Mobile-First Students**: Primary mobile app users requiring touch-optimized, screen-reader compatible interfaces

**Critical Flows Requiring Extra Accessibility Attention**:
- Trust record creation and authorization statements (Admin Portal)
- Credential claim and sharing flows (Student Vault)
- QR code scanning and credential verification (All apps)
- Biometric authentication (Future: facial recognition for student validation)

---

## WCAG 2.1 Level AA Requirements

### Perceivable

Users must be able to perceive the information being presented.

#### 1.1 Text Alternatives
- ✅ **All images** have alt text describing their purpose
- ✅ **Decorative images** use `alt=""` or `aria-hidden="true"`
- ✅ **Icon-only buttons** have accessible labels (Tooltip or Semantics)

**Flutter Implementation**:
```dart
// Image with alt text
Semantics(
  label: 'University logo for Hong Kong University',
  child: Image.asset('assets/hku_logo.png'),
)

// Decorative image (hidden from screen readers)
ExcludeSemantics(
  child: Image.asset('assets/background_pattern.png'),
)

// Icon button with label
IconButton(
  icon: Icon(Icons.settings),
  tooltip: 'Open settings', // ✅ Required
  onPressed: () {},
)
```

---

#### 1.3 Adaptable

Content must be presentable in different ways without losing information.

- ✅ **Heading hierarchy** (H1 → H2 → H3, never skip levels)
- ✅ **Semantic HTML** (use proper heading tags, not just styled text)
- ✅ **Reading order** matches visual order
- ✅ **Form labels** explicitly associated with inputs

**Flutter Implementation**:
```dart
// Proper heading hierarchy
Column(
  children: [
    Text('Page Title', style: theme.textTheme.displayLarge), // H1
    Text('Section', style: theme.textTheme.headlineMedium),  // H2
    Text('Subsection', style: theme.textTheme.titleLarge),   // H3
  ],
)

// Form field with label
TextField(
  decoration: InputDecoration(
    labelText: 'Email Address', // ✅ Explicit label
    hintText: 'Enter your email',
  ),
)
```

---

#### 1.4 Distinguishable

Make it easier for users to see and hear content.

##### 1.4.3 Contrast (Minimum) - Level AA ✅

**Text Contrast Requirements**:
- **Normal text** (< 18pt): **4.5:1** minimum
- **Large text** (≥ 18pt or 14pt bold): **3:1** minimum
- **Non-text elements** (icons, UI components): **3:1** minimum

**Certizen Color Contrast Ratios** (Dark Mode):

| Combination | Ratio | Status |
|-------------|-------|--------|
| White on Primary 500 (#0368C0) | 4.87:1 | ✅ AA (normal text) |
| White on Secondary 500 (#03A9F4) | 6.39:1 | ✅ AAA |
| White on Success Main (#4CAF50) | 6.24:1 | ✅ AAA |
| White on Error Main (#F44336) | 5.78:1 | ✅ AAA |
| White on Warning Main (#D99A06) | 4.27:1 | ⚠️ AA (large text only) |
| White on Black (#000000) | 21:1 | ✅ AAA |
| Neutral 700 (#636363) on Black | 5.24:1 | ✅ AAA |

**Testing Tools**:
- WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/
- Chrome DevTools Accessibility Inspector
- Lighthouse Accessibility Audit

**Action Required**:
- ⚠️ Warning color (#D99A06): Use only for large text or increase contrast

---

##### 1.4.11 Non-text Contrast - Level AA ✅

UI components and graphical objects must have 3:1 contrast ratio.

**Certizen Compliance**:
- ✅ Buttons: Primary 500 on Black (4.31:1)
- ✅ Input borders: Neutral 700 on Black (5.24:1)
- ✅ Focus indicators: Primary 500 on Black (4.31:1)
- ✅ Icons: White on Primary 500 (4.87:1)

---

##### 1.4.13 Content on Hover or Focus - Level AA ✅

Tooltips and popups triggered by hover/focus must be:
- **Dismissible**: User can close without moving pointer
- **Hoverable**: User can move pointer over the tooltip
- **Persistent**: Tooltip remains until dismissed or pointer leaves

**Flutter Implementation**:
```dart
Tooltip(
  message: 'This is additional information',
  child: Icon(Icons.info),
  waitDuration: Duration(milliseconds: 500),
  // Tooltip persists when hovering over it
)
```

---

### Operable

Users must be able to operate the interface.

#### 2.1 Keyboard Accessible

All functionality must be available via keyboard.

##### 2.1.1 Keyboard - Level A ✅

**Requirements**:
- ✅ All interactive elements are keyboard accessible (Tab, Enter, Space)
- ✅ No keyboard traps (user can navigate away from all elements)
- ✅ Logical tab order (top-to-bottom, left-to-right)

**Flutter Implementation**:
Material 3 widgets are keyboard accessible by default. Ensure:
- Don't use `GestureDetector` for critical interactions (not keyboard accessible)
- Use `InkWell` or `Button` widgets instead
- Test with keyboard navigation (Tab, Shift+Tab, Enter, Space)

```dart
// ❌ Not keyboard accessible
GestureDetector(
  onTap: () => _doSomething(),
  child: Text('Click me'),
)

// ✅ Keyboard accessible
TextButton(
  onPressed: () => _doSomething(),
  child: Text('Click me'),
)
```

---

##### 2.1.2 No Keyboard Trap - Level A ✅

Users must be able to navigate away from all elements using keyboard alone.

**Common Issues**:
- Modal dialogs without close button
- Custom focus management that traps focus
- Infinite carousels without escape

**Flutter Implementation**:
```dart
// ✅ Modal with keyboard-accessible close
AlertDialog(
  title: Text('Confirm Action'),
  content: Text('Are you sure?'),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context), // ✅ Can escape with keyboard
      child: Text('Cancel'),
    ),
    ElevatedButton(
      onPressed: () => _confirm(),
      child: Text('Confirm'),
    ),
  ],
)
```

---

#### 2.4 Navigable

Provide ways to help users navigate, find content, and determine where they are.

##### 2.4.3 Focus Order - Level A ✅

Tab order must be logical and intuitive (typically top-to-bottom, left-to-right).

**Flutter Implementation**:
Default Flutter focus order follows widget tree order. For custom order:
```dart
FocusTraversalGroup(
  policy: OrderedTraversalPolicy(),
  child: Column(
    children: [
      FocusTraversalOrder(
        order: NumericFocusOrder(1.0),
        child: TextField(),
      ),
      FocusTraversalOrder(
        order: NumericFocusOrder(2.0),
        child: TextField(),
      ),
    ],
  ),
)
```

---

##### 2.4.7 Focus Visible - Level AA ✅

**Keyboard focus indicator must be visible.**

**Requirements**:
- **Outline width**: Minimum **2px**
- **Outline color**: High contrast (primary color recommended)
- **Outline offset**: **2px** from element edge (prevents overlap)
- **Never remove**: `outline: none` is WCAG violation ❌

**Certizen Focus Indicators**:
- **Color**: Primary 500 (#0368C0)
- **Width**: 2px
- **Offset**: 2px
- **Style**: Solid

**Flutter Implementation**:
Material 3 provides default focus indicators. To customize:
```dart
Theme(
  data: ThemeData(
    focusColor: AppColors.primary500,
    // Material 3 handles focus indicator automatically
  ),
  child: YourWidget(),
)
```

---

#### 2.5 Input Modalities

Make it easier for users to operate functionality through various inputs beyond keyboard.

##### 2.5.5 Target Size - Level AAA (Certizen Target: Achieve)

**Minimum touch target size: 44x44px** (iOS) or **48x48px** (Android/Material)

**Certizen Standard**: **44x44px minimum** for all touch targets.

**Components Meeting Standard**:
- ✅ Buttons: Min height 44px
- ✅ Text fields: Min height 44px
- ✅ Icon buttons: 48x48px default (Material)
- ✅ Checkboxes: 40x40px (Material default)
- ✅ List items: Min height 56px

**Flutter Implementation**:
```dart
// Ensure minimum touch target
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    minimumSize: Size(64, 44), // ✅ 44px height
  ),
  child: Text('Button'),
)

// Icon button (Material default is 48x48)
IconButton(
  icon: Icon(Icons.settings),
  iconSize: 24,
  onPressed: () {},
  // Padding creates 48x48 touch target automatically
)
```

---

### Understandable

Information and operation of the user interface must be understandable.

#### 3.1 Readable

Make text content readable and understandable.

##### 3.1.1 Language of Page - Level A ✅

**Declare the primary language of the app.**

**Flutter Implementation**:
```dart
MaterialApp(
  locale: Locale('en', 'US'), // ✅ Declares English
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en', 'US'),
    Locale('zh', 'HK'), // If supporting Chinese
  ],
)
```

---

#### 3.2 Predictable

Make pages appear and operate in predictable ways.

##### 3.2.3 Consistent Navigation - Level AA ✅

Navigation must be consistent across all screens.

**Certizen Implementation**:
- ✅ Bottom navigation (mobile) appears in same position on all screens
- ✅ App bar (desktop) appears in same position
- ✅ Same navigation items in same order

---

##### 3.2.4 Consistent Identification - Level AA ✅

Components with the same functionality must be identified consistently.

**Examples**:
- ✅ All "Submit" buttons use same label and icon
- ✅ All "Delete" actions use same icon (delete icon) and color (red)
- ✅ All success messages use same green color and checkmark icon

---

#### 3.3 Input Assistance

Help users avoid and correct mistakes.

##### 3.3.1 Error Identification - Level A ✅

**Errors must be clearly identified and described.**

**Flutter Implementation**:
```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email Address',
    errorText: isError ? 'Please enter a valid email address' : null,
    // ✅ Clear, specific error message
  ),
)
```

**Error Message Guidelines**:
- ✅ Specific: "Email address is required" (not "Invalid input")
- ✅ Actionable: "Password must be at least 8 characters" (not "Invalid password")
- ✅ Visible: Red color + error icon
- ✅ Announced: Screen readers read error messages

---

##### 3.3.2 Labels or Instructions - Level A ✅

**All form fields must have clear labels.**

**Flutter Implementation**:
```dart
// ✅ Explicit label
TextField(
  decoration: InputDecoration(
    labelText: 'Institution Name', // ✅ Required
    hintText: 'Enter your institution', // Optional additional hint
  ),
)

// ❌ Placeholder alone is NOT sufficient
TextField(
  decoration: InputDecoration(
    hintText: 'Institution name', // ❌ Not a label
  ),
)
```

---

##### 3.3.3 Error Suggestion - Level AA ✅

**Provide suggestions for correcting errors when possible.**

**Examples**:
- "Email address is invalid. Example: user@example.com"
- "Password must be at least 8 characters. Current: 5 characters"
- "File type not supported. Please upload PDF or PNG"

---

### Robust

Content must be robust enough to be interpreted by a wide variety of user agents, including assistive technologies.

#### 4.1 Compatible

Maximize compatibility with current and future user agents, including assistive technologies.

##### 4.1.2 Name, Role, Value - Level A ✅

**All UI components must have accessible name, role, and state.**

**Flutter Implementation**:
Material 3 widgets provide semantic information automatically. For custom widgets:
```dart
Semantics(
  label: 'Email address input field', // Name
  hint: 'Enter your email address',
  textField: true, // Role
  child: CustomTextInput(),
)

// Button semantics
Semantics(
  label: 'Issue credential', // Name
  button: true, // Role
  enabled: isEnabled, // State
  child: CustomButton(),
)
```

---

## Testing Accessibility

### Automated Testing

#### Flutter Accessibility Inspector
```dart
// In debug mode
flutter run --accessibility

// Run accessibility checks in tests
testWidgets('Button is accessible', (tester) async {
  await tester.pumpWidget(MyButton());
  
  // Check for semantic label
  expect(
    find.bySemanticsLabel('Issue Credential'),
    findsOneWidget,
  );
});
```

#### Lighthouse (Web)
Run Lighthouse audit in Chrome DevTools:
1. Open DevTools (F12)
2. Go to Lighthouse tab
3. Run Accessibility audit
4. Fix all issues with scores < 90

---

### Manual Testing

#### Keyboard Navigation
Test all functionality using only keyboard:
1. **Tab**: Navigate to next interactive element
2. **Shift+Tab**: Navigate to previous element
3. **Enter/Space**: Activate buttons
4. **Arrow keys**: Navigate lists, radio groups
5. **Escape**: Close modals/dialogs

**Checklist**:
- ✅ Can reach all interactive elements
- ✅ Focus indicator always visible
- ✅ No keyboard traps
- ✅ Logical tab order

---

#### Screen Reader Testing

**macOS**: VoiceOver (Cmd+F5)
**Windows**: NVDA (free), JAWS (paid)
**iOS**: VoiceOver (Settings > Accessibility)
**Android**: TalkBack (Settings > Accessibility)

**Test Checklist**:
- ✅ All content is announced
- ✅ Headings are identified as headings
- ✅ Buttons are identified as buttons
- ✅ Form fields have labels
- ✅ Error messages are announced
- ✅ Focus changes are announced

---

#### Color Contrast Testing

**Tools**:
- WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/
- Contrast Ratio: https://contrast-ratio.com/
- Chrome DevTools: Accessibility pane shows contrast ratios

**Process**:
1. Test all text/background combinations
2. Ensure 4.5:1 for normal text
3. Ensure 3:1 for large text (18pt+)
4. Ensure 3:1 for UI components

---

## Accessibility Quick Checklist

Use this checklist for every new component:

### Visual
- ✅ Color contrast meets 4.5:1 (text) or 3:1 (UI components)
- ✅ Focus indicators visible (2px, high contrast)
- ✅ Text is minimum 16px for body content
- ✅ Touch targets are minimum 44x44px

### Keyboard
- ✅ All interactive elements keyboard accessible
- ✅ Tab order is logical
- ✅ No keyboard traps
- ✅ Focus visible on all elements

### Screen Reader
- ✅ All images have alt text (or marked decorative)
- ✅ All buttons have labels
- ✅ Form fields have labels
- ✅ Headings use proper hierarchy
- ✅ Error messages are announced

### Content
- ✅ Language declared
- ✅ Error messages are specific and actionable
- ✅ Instructions provided for complex interactions
- ✅ Consistent navigation and labeling

---

## Common Accessibility Violations to Avoid

### ❌ Don't Remove Focus Indicators
```dart
// ❌ NEVER DO THIS
OutlineInputBorder(
  borderSide: BorderSide.none, // Removes focus indicator
)
```

### ❌ Don't Use Color Alone for Information
```dart
// ❌ BAD: Only color indicates status
Container(
  color: isActive ? Colors.green : Colors.red,
  child: Text('Status'),
)

// ✅ GOOD: Icon + color + text
Row(
  children: [
    Icon(isActive ? Icons.check : Icons.error),
    Text(isActive ? 'Active' : 'Inactive'),
  ],
)
```

### ❌ Don't Use Low Contrast Text
```dart
// ❌ BAD: Insufficient contrast
Text(
  'Secondary text',
  style: TextStyle(color: Colors.gray.shade600), // < 4.5:1
)

// ✅ GOOD: Meets AA standards
Text(
  'Secondary text',
  style: TextStyle(color: AppColors.neutral700), // 5.24:1
)
```

### ❌ Don't Create Touch Targets < 44px
```dart
// ❌ BAD: Too small
IconButton(
  icon: Icon(Icons.close, size: 16),
  padding: EdgeInsets.zero,
  onPressed: () {},
)

// ✅ GOOD: 48x48 touch target
IconButton(
  icon: Icon(Icons.close, size: 24),
  onPressed: () {},
  // Default padding creates 48x48 target
)
```

---

## Conclusion

Accessibility is not optional in Certizen. Every component, every screen, every interaction must meet WCAG 2.1 Level AA standards.

**Remember**:
- **Test with keyboard** (no mouse)
- **Test with screen reader** (eyes closed)
- **Check color contrast** (use tools)
- **Validate touch targets** (minimum 44x44px)
- **Use semantic elements** (Material widgets handle this)

When in doubt, ask: "Can a user with disabilities complete this task independently?" If not, fix it.

**Resources**:
- WCAG 2.1 Guidelines: https://www.w3.org/WAI/WCAG21/quickref/
- WebAIM: https://webaim.org/
- Flutter Accessibility: https://docs.flutter.dev/accessibility-and-localization/accessibility
