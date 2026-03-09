# Art Direction

**Document Version**: 1.0.0  
**Last Updated**: January 6, 2026

---

## Overview

Credulon's art direction establishes the visual identity and emotional tone across all applications. This document defines the aesthetic principles, illustration style, mood, and tone of voice that make Credulon recognizable and trustworthy.

### Design Context

Credulon serves multiple stakeholder groups across three jurisdictions (Hong Kong, Macau, Singapore):

**Trust Registry Admin Portal**: Government administrators managing educational governance frameworks, authorizing universities, and creating authority statements. Interface must convey authority, control, and precision.

**Student Vault App**: University students receiving, storing, and sharing educational credentials. Experience must feel secure, personal, and empowering.

**Employer Verification Portal**: HR professionals and hiring managers verifying credential authenticity. Interface must communicate reliability, efficiency, and compliance.

**Visual Identity Goal**: Unified professional aesthetic that adapts tone appropriately for each stakeholder while maintaining brand consistency across all touchpoints.

---

## Visual Style

### Overall Aesthetic

**Headspace Warmth, Revolut Efficiency**

Credulon combines the calm, approachable palette of Headspace with the clear, organized information architecture of Revolut. Clean, modern, and emotionally warm—never cold or corporate.

**Key Characteristics**:

- **Warm**: Cream and orange accents create calm yet energetic atmosphere
- **Organized**: Clear modular patterns, efficient information hierarchy, decisive UI
- **Clean**: Generous negative space, uncluttered layouts, purposeful spacing
- **Modern**: Material Design 3, minimal shadows, smooth animations
- **Confident**: Bold orange accents draw focus to key actions; strong visual weight guides users

---

### Design Language

#### Shapes & Forms

**Primary Shapes**:

- **Rounded Rectangles**: Primary container shape (8-12px border radius)
- **Circles**: Icons, avatars, badges
- **Clean Lines**: Dividers, borders, underlines

**Avoid**:

- Overly sharp corners (except for intentional emphasis)
- Irregular organic shapes
- Excessive ornamentation
- Skeuomorphic elements

#### Depth & Elevation

**Subtle Layering** (Headspace-inspired lightness):

- Use shadows sparingly to indicate elevation
- Elevation levels: 0 (flat), 1 (subtle), 3 (raised), 8 (prominent), 16 (modal)
- Light mode: Minimal shadows; rely on warm cream surface colors and spacing for hierarchy
- Cards: Elevation 1 (barely perceptible) with warm cream backgrounds (#FFEEC8)
- AppBar: Elevation 0 (flat, seamless)
- Modals: Elevation 16 (significant shadow + backdrop)

**Contrast with Depth**: Warm backgrounds and clean spacing create perceived depth without shadow heaviness

#### Borders & Dividers

**Border Philosophy**:

- Use borders to separate, not decorate
- 1px borders for subtle separation
- 2px borders for emphasis
- High contrast borders only when necessary for accessibility

**Divider Usage**:

- Prefer spacing over dividers when possible
- Use subtle dividers (low opacity) within grouped content
- Full-width dividers for major section breaks

---

### Grid & Layout System

#### 8px Baseline Grid

All elements align to an 8px grid:

- Spacing: 8, 16, 24, 32, 40, 48, 64, 80, 96...
- Component dimensions: Heights and widths in 8px increments
- Line heights: Based on 8px rhythm

#### Layout Patterns

**Mobile (< 640px)**:

- Single column layouts
- Full-width cards with 16px margins
- Bottom navigation for primary actions
- Stacked forms

**Tablet (640px - 1024px)**:

- Two-column layouts where appropriate
- Side navigation option
- Adaptive card widths
- Side-by-side forms

**Desktop (> 1024px)**:

- Multi-column layouts (2-3 columns)
- Persistent side navigation
- Max content width: 1440px (centered)
- Horizontal form layouts

#### Container Widths

- **Mobile**: 100% with 16px padding
- **Tablet**: 100% with 24px padding, max 768px
- **Desktop**: 100% with 32px padding, max 1440px
- **Cards**: Max 600px for readability

---

## Illustration Style

### Illustration Approach

**Minimalist Iconography**

Credulon uses Material Icons for UI elements and simple, geometric illustrations for empty states and onboarding.

**Characteristics**:

- **Geometric**: Simple shapes, clean lines (Revolut organization)
- **Flat Design**: No gradients, shadows, or 3D effects in illustrations
- **Warm Color Palette**: Warm orange (#FF8E32) for key actions, cream backgrounds, neutral grays
- **Outline Style**: Line-based illustrations (2px stroke weight, warm orange or neutral)
- **Friendly & Warm**: Approachable Headspace-inspired tone without being childish

---

### Illustration Usage

#### When to Use Illustrations

1. **Empty States**: Guide users when no content exists
2. **Onboarding**: Welcome screens, feature introduction
3. **Error States**: 404, network errors, permissions issues
4. **Success Confirmations**: Credential issued, verification complete
5. **Feature Highlights**: Marketing pages, landing screens

#### When NOT to Use Illustrations

- Dense data screens (use icons instead)
- Forms (focus on clarity, not decoration)
- Navigation (use Material Icons)
- Data visualization (use charts/graphs)

---

### Illustration Guidelines

#### Style Rules

1. **Stroke Weight**: 2px consistent line weight
2. **Corner Style**: Rounded corners (4px radius on shapes)
3. **Color**:
   - Primary elements: Warm orange (#FF8E32) for key features
   - Secondary elements: Warm cream (#FFEEC8) for supporting content
   - Backgrounds: Warm off-white (#FFFDF7, #FFFBF7)
   - Accents: Success green, warning amber (sparingly)
4. **Simplicity**: Maximum 3-4 elements per illustration
5. **Scale**: Illustrations should be 200-400px wide on mobile

#### Example Scenarios

**Empty Credential List**:

- Icon: Minimalist credential card outline
- Color: Warm orange (#FF8E32) outline on warm cream background
- Composition: Centered, 300px wide
- Supporting text: "No credentials yet"

**Network Error**:

- Icon: Disconnected plug or signal
- Color: Warning amber
- Composition: Centerd, 250px wide
- Supporting text: "Connection lost"

**Verification Success**:

- Icon: Checkmark in circle
- Color: Success green
- Animation: Subtle scale-up entrance
- Supporting text: "Verified successfully"

---

## Mood & Atmosphere

### Emotional Qualities

**Warm Professionalism** (Headspace + Revolut)

Credulon balances authoritative competence (educational credentials are serious) with warm approachability (users should feel comfortable and empowered).

**Primary Emotions**:

1. **Trust**: Reliable, secure, authoritative
2. **Clarity**: Clear, organized, transparent (Revolut efficiency)
3. **Confidence**: Decisive, professional, capable (bold orange accents for key actions)
4. **Calm**: Warm colors, uncluttered layouts, peaceful focus (Headspace warmth)

**Avoid**:

- Overly formal/corporate (cold, intimidating)
- Too casual (unprofessional, flippant)
- Anxious (urgent warnings, aggressive CTAs)
- Playful (childish, trivializing credentials)

---

### Visual Mood Board

**Color Atmosphere** (Headspace warmth, organized clarity):

- **Warm Orange (#FF8E32)**: High-priority actions, key features stand out ("Claim Credential", primary CTAs)
- **Warm Cream (#FFEEC8, #FFFDF7)**: Approachable backgrounds, reduces eye strain, feels inviting
- **Dark Near-Black Text (#1E1E1E)**: Clear, readable on warm surfaces, sophisticated
- **Minimal Shadows (elevation 1)**: Depth without heaviness, maintains warm aesthetic
- **Modular Sections**: Color blocking organizes content (Revolut organization)

**Interaction Atmosphere**:

- **Smooth Animations**: Polished, responsive, delightful
- **Instant Feedback**: Confident, reliable, responsive
- **Clear States**: Unambiguous, transparent, honest
- **Gentle Transitions**: Calm, flowing, natural

---

## Tone of Voice

### Writing Style

**Clear, Confident, and Concise**

All interface text should be:

- **Direct**: Get to the point quickly
- **Active Voice**: "Issue credential" not "Credential is issued"
- **User-Focused**: "Your credentials" not "Credentials list"
- **Jargon-Free**: Explain technical terms when necessary
- **Encouraging**: "Add your first credential" not "No credentials found"

---

### Content Principles

#### 1. Clarity First

**Principle**: Users should never be confused about what an action does.

✅ **Good**: "Issue Credential to Student"  
❌ **Bad**: "Process Request"

✅ **Good**: "This credential will be shared with the employer"  
❌ **Bad**: "Credential sharing initiated"

---

#### 2. Empowering Language

**Principle**: Give users control and confidence.

✅ **Good**: "You can add credentials from any accredited institution"  
❌ **Bad**: "Credentials must be from approved sources"

✅ **Good**: "Ready to verify this credential?"  
❌ **Bad**: "Are you sure?"

---

#### 3. Helpful Errors

**Principle**: Error messages explain the problem AND the solution.

✅ **Good**: "Network connection lost. Please check your internet and try again."  
❌ **Bad**: "Error: Network failure"

✅ **Good**: "This field is required. Please enter your institution name."  
❌ **Bad**: "Validation error"

---

#### 4. Appropriate Formality

**Principle**: Professional but not stiff, friendly but not casual.

✅ **Good**: "Welcome to Credulon! Let's get started."  
❌ **Too Casual**: "Hey there! 👋 Ready to rock?"  
❌ **Too Formal**: "Greetings. Please commence onboarding procedures."

✅ **Good**: "Credential verified successfully"  
❌ **Too Casual**: "Awesome! It's legit! 🎉"  
❌ **Too Formal**: "Verification process completed without error"

---

### Content Guidelines by Context

#### Button Labels

**Primary Actions** (CTAs):

- "Issue Credential"
- "Verify Now"
- "Add to Wallet"
- "Create Record"

**Secondary Actions**:

- "View Details"
- "Edit Record"
- "Cancel"
- "Go Back"

**Destructive Actions**:

- "Delete Credential"
- "Remove Record"
- "Revoke Access"

**Rules**:

- Use action verbs
- Be specific (not generic "Submit")
- Keep under 3 words when possible

---

#### Form Labels

**Field Labels**:

- "Institution Name" (not "Name")
- "Credential Type" (not "Type")
- "Issue Date" (not "Date")

**Placeholder Text**:

- "Enter your email address"
- "Select a credential type"
- "YYYY-MM-DD"

**Rules**:

- Labels are nouns
- Placeholders are instructions
- Never rely on placeholder alone (accessibility)

---

#### Empty States

**Structure**: Icon + Heading + Description + CTA

**Examples**:

```
[Icon: Credential Card]
No credentials yet
Start by requesting a credential from your institution
[Button: Request Credential]
```

```
[Icon: Search]
No results found
Try adjusting your filters or search terms
[Button: Clear Filters]
```

**Rules**:

- Heading: State the situation
- Description: Explain or encourage
- CTA: Suggest next action

---

#### Success Messages

**Toast/Snackbar Messages**:

- "Credential issued successfully"
- "Record created"
- "Changes saved"

**Full-Page Success**:

```
[Icon: Checkmark]
Credential Verified
This credential is valid and issued by Hong Kong University
[Button: View Details]
```

**Rules**:

- Confirm the action completed
- Keep brief for transient messages
- Provide details for important confirmations

---

#### Error Messages

**Validation Errors** (inline):

- "Email address is required"
- "Password must be at least 8 characters"
- "Please select a credential type"

**System Errors** (banner):

- "Connection lost. Please check your internet and try again."
- "Unable to load credentials. Tap to retry."

**Critical Errors** (full-page):

```
[Icon: Warning]
Something Went Wrong
We encountered an unexpected error. Please try again later.
[Button: Go to Dashboard]
```

**Rules**:

- Explain what happened
- Provide a solution or next step
- Never blame the user
- Avoid technical jargon

---

### Microcopy Examples

#### Navigation

- "Dashboard" (not "Home")
- "Credentials" (not "My Credentials")
- "Verify" (not "Verification")
- "Settings" (not "Preferences")

#### Status Indicators

- "Active" / "Inactive" (not "Enabled" / "Disabled")
- "Valid" / "Expired" (not "Current" / "Past")
- "Verified" / "Pending" (not "Confirmed" / "Waiting")

#### Time References

- "Just now" (< 1 minute)
- "5 minutes ago"
- "Today at 2:30 PM"
- "Yesterday"
- "Jan 15, 2026" (> 7 days)

---

## Visual References

### Color Atmosphere

Based on existing implementation:

- **Warm Orange (#FF8E32)**: Key features and actions that should stand out (primary CTAs, highlights)
- **Warm Cream (#FFEEC8, #FFFDF7)**: Card backgrounds and supporting surfaces
- **Dark Near-Black (#1E1E1E)**: Primary text on warm backgrounds
- **Warm Off-White (#FFFDF7)**: Main background, calm and inviting

### Component Atmosphere

From existing screens:

- **Cards**: Minimal shadows (elevation 1), warm cream backgrounds, rounded corners (8-12px)
- **Buttons**: Bold warm orange (#FF8E32) for primary CTAs (especially "Claim Credential"), warm cream for secondary
- **Forms**: Clear labels, outlined inputs, warm backgrounds, generous padding
- **Navigation**: Bottom tabs on mobile, side navigation on desktop
- **Key Features**: Strong visual weight, prominent sizing (button minHeight: 56px for CTAs)

### Layout Atmosphere

- **Mobile**: Single column, thumb-friendly, bottom navigation
- **Desktop**: Multi-column, sidebar navigation, spacious
- **Responsive**: Graceful transitions between breakpoints

---

## Do's and Don'ts

### Visual Do's

✅ Use consistent border radius (8-12px)  
✅ Maintain generous padding (16-24px) for breathing room  
✅ Align elements to 8px grid (Revolut organization)  
✅ Use minimal shadows (elevation 1) for depth  
✅ Keep layouts modular and sectioned (color-blocked organization)  
✅ Use warm orange for key features—make them stand out and look exciting

### Visual Don'ts

❌ Mix border radius values randomly  
❌ Cram content with minimal spacing  
❌ Misalign elements to grid  
❌ Overuse shadows or elevation  
❌ Add decorative elements without purpose

---

### Content Do's

✅ Write in active voice  
✅ Keep sentences short  
✅ Use simple, common words  
✅ Explain technical terms  
✅ Guide users to next steps

### Content Don'ts

❌ Use passive voice ("credential was issued")  
❌ Write long, complex sentences  
❌ Use jargon without explanation  
❌ Leave users wondering what to do  
❌ Blame users for errors

---

## Conclusion

Credulon's art direction creates a cohesive visual and emotional experience:

- **Visually**: Warm, organized, modern (Headspace colors + Revolut organization)
- **Emotionally**: Trustworthy, approachable, confident, calm
- **Verbally**: Clear, helpful, empowering
- **Hierarchically**: Key features stand out with bold orange accents and strong visual weight

When making design decisions, ask:

1. Does this feel warm and trustworthy, not cold or sterile?
2. Is this organized and clear with strong information hierarchy?
3. Do key actions ("Claim Credential", primary CTAs) stand out with visual prominence?
4. Does this empower the user with clarity and confidence?
5. Is this consistent with our established warm orange + cream palette and patterns?

If the answer to all five is "yes," you're aligned with Credulon's art direction.
