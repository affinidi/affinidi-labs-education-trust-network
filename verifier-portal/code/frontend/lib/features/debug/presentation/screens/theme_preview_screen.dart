import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/color_tokens.dart';
import '../../../../core/design_system/tokens/typography_tokens.dart';
import '../../../../core/design_system/tokens/spacing_tokens.dart';
import '../../../../core/design_system/tokens/radii_tokens.dart';
import '../../../../core/design_system/tokens/elevation_tokens.dart';

/// NovaCorp Design System Preview Screen
///
/// DEBUG ONLY - Not exposed in production routes
/// Route: /debug/theme-preview
///
/// Displays all design tokens and component themes:
/// - ColorScheme and ColorTokens swatches
/// - TextTheme typography samples
/// - Button states (elevated, text, outlined)
/// - Cards and input fields
/// - Spacing, radii, and elevation examples
///
/// Accessibility Note:
/// All interactive elements meet WCAG 2.1 minimum touch target size of 44x44 pixels
class ThemePreviewScreen extends StatelessWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Access design tokens via extensions
    final colors = theme.extension<ColorTokens>()!;
    final typography = theme.extension<TypographyTokens>()!;
    final spacing = theme.extension<SpacingTokens>()!;
    final radii = theme.extension<RadiiTokens>()!;
    final elevation = theme.extension<ElevationTokens>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Preview'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.spacing3), // 24px
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _SectionHeader(
              title: 'NovaCorp Design System',
              subtitle: 'Theme preview and token inspector',
              spacing: spacing,
            ),
            SizedBox(height: spacing.spacing4),

            // Accessibility Note
            _AccessibilityNote(spacing: spacing),
            SizedBox(height: spacing.spacing5),

            // Color System
            _ColorSystemSection(
              colorScheme: colorScheme,
              colors: colors,
              spacing: spacing,
            ),
            SizedBox(height: spacing.spacing5),

            // Typography System
            _TypographySection(
              theme: theme,
              typography: typography,
              spacing: spacing,
            ),
            SizedBox(height: spacing.spacing5),

            // Button States
            _ButtonStatesSection(spacing: spacing),
            SizedBox(height: spacing.spacing5),

            // Card Theme
            _CardThemeSection(
              spacing: spacing,
              radii: radii,
              elevation: elevation,
            ),
            SizedBox(height: spacing.spacing5),

            // Input Theme
            _InputThemeSection(spacing: spacing),
            SizedBox(height: spacing.spacing5),

            // Spacing & Radii
            _SpacingRadiiSection(spacing: spacing, radii: radii),
            SizedBox(height: spacing.spacing5),

            // Elevation
            _ElevationSection(
              spacing: spacing,
              elevation: elevation,
              colorScheme: colorScheme,
            ),
            SizedBox(height: spacing.spacing6),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// SECTION COMPONENTS
// ===========================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final SpacingTokens spacing;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.displaySmall),
        SizedBox(height: spacing.spacing1),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _AccessibilityNote extends StatelessWidget {
  final SpacingTokens spacing;

  const _AccessibilityNote({required this.spacing});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(spacing.spacing2),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.accessibility_new,
            color: colorScheme.onPrimaryContainer,
            size: 24,
          ),
          SizedBox(width: spacing.spacing2),
          Expanded(
            child: Text(
              'WCAG 2.1 Compliance: All interactive elements meet minimum 44x44px touch target size. '
              'Text contrast ratios meet AA standards (4.5:1 normal, 3:1 large).',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// COLOR SYSTEM SECTION
// ===========================================================================

class _ColorSystemSection extends StatelessWidget {
  final ColorScheme colorScheme;
  final ColorTokens colors;
  final SpacingTokens spacing;

  const _ColorSystemSection({
    required this.colorScheme,
    required this.colors,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color System', style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: spacing.spacing2),
        Text(
          'Material 3 ColorScheme + ColorTokens',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        SizedBox(height: spacing.spacing3),

        // ColorScheme Swatches
        Text(
          'ColorScheme (Material 3)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: spacing.spacing2),
        Wrap(
          spacing: spacing.spacing2,
          runSpacing: spacing.spacing2,
          children: [
            _ColorSwatch(
              label: 'Primary',
              color: colorScheme.primary,
              onColor: colorScheme.onPrimary,
              spacing: spacing,
            ),
            _ColorSwatch(
              label: 'Secondary',
              color: colorScheme.secondary,
              onColor: colorScheme.onSecondary,
              spacing: spacing,
            ),
            _ColorSwatch(
              label: 'Tertiary',
              color: colorScheme.tertiary,
              onColor: colorScheme.onTertiary,
              spacing: spacing,
            ),
            _ColorSwatch(
              label: 'Error',
              color: colorScheme.error,
              onColor: colorScheme.onError,
              spacing: spacing,
            ),
            _ColorSwatch(
              label: 'Surface',
              color: colorScheme.surface,
              onColor: colorScheme.onSurface,
              spacing: spacing,
            ),
            _ColorSwatch(
              label: 'Surface Variant',
              color: colorScheme.surfaceContainerHighest,
              onColor: colorScheme.onSurface,
              spacing: spacing,
            ),
          ],
        ),
        SizedBox(height: spacing.spacing3),

        // ColorTokens Swatches
        Text(
          'ColorTokens (Design System)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: spacing.spacing2),
        Wrap(
          spacing: spacing.spacing2,
          runSpacing: spacing.spacing2,
          children: [
            _ColorSwatch(
              label: 'Primary 500',
              color: colors.primary500,
              onColor: colors.neutral0,
              spacing: spacing,
            ),
            _ColorSwatch(
              label: 'Secondary 500',
              color: colors.secondary500,
              onColor: colors.neutral0,
              spacing: spacing,
            ),
            _ColorSwatch(
              label: 'Verified',
              color: colors.verifiedMain,
              onColor: colors.verifiedContrast,
              spacing: spacing,
            ),
            _ColorSwatch(
              label: 'Pending',
              color: colors.pendingMain,
              onColor: colors.pendingContrast,
              spacing: spacing,
            ),
            _ColorSwatch(
              label: 'Failed',
              color: colors.failedMain,
              onColor: colors.failedContrast,
              spacing: spacing,
            ),
          ],
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String label;
  final Color color;
  final Color onColor;
  final SpacingTokens spacing;

  const _ColorSwatch({
    required this.label,
    required this.color,
    required this.onColor,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: onColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ===========================================================================
// TYPOGRAPHY SECTION
// ===========================================================================

class _TypographySection extends StatelessWidget {
  final ThemeData theme;
  final TypographyTokens typography;
  final SpacingTokens spacing;

  const _TypographySection({
    required this.theme,
    required this.typography,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Typography System', style: theme.textTheme.headlineMedium),
        SizedBox(height: spacing.spacing2),
        Text(
          'Figtree font family with responsive sizing',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.spacing3),

        _TypographySample(
          label: 'Display Large',
          style: theme.textTheme.displayLarge,
        ),
        _TypographySample(
          label: 'Display Medium',
          style: theme.textTheme.displayMedium,
        ),
        _TypographySample(
          label: 'Display Small',
          style: theme.textTheme.displaySmall,
        ),
        _TypographySample(
          label: 'Headline Medium',
          style: theme.textTheme.headlineMedium,
        ),
        _TypographySample(
          label: 'Headline Small',
          style: theme.textTheme.headlineSmall,
        ),
        _TypographySample(
          label: 'Title Large',
          style: theme.textTheme.titleLarge,
        ),
        _TypographySample(
          label: 'Body Large',
          style: theme.textTheme.bodyLarge,
        ),
        _TypographySample(
          label: 'Body Medium',
          style: theme.textTheme.bodyMedium,
        ),
        _TypographySample(
          label: 'Body Small',
          style: theme.textTheme.bodySmall,
        ),
        _TypographySample(
          label: 'Label Large',
          style: theme.textTheme.labelLarge,
        ),
        _TypographySample(
          label: 'Label Medium',
          style: theme.textTheme.labelMedium,
        ),
        _TypographySample(
          label: 'Label Small',
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _TypographySample extends StatelessWidget {
  final String label;
  final TextStyle? style;

  const _TypographySample({required this.label, required this.style});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<SpacingTokens>()!;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.spacing2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.spacing1 / 2),
          Text('The quick brown fox jumps over the lazy dog', style: style),
        ],
      ),
    );
  }
}

// ===========================================================================
// BUTTON STATES SECTION
// ===========================================================================

class _ButtonStatesSection extends StatelessWidget {
  final SpacingTokens spacing;

  const _ButtonStatesSection({required this.spacing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Button States',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: spacing.spacing2),
        Text(
          'Interactive states with token-based spacing and radii',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.spacing3),

        // Elevated Buttons
        Text(
          'Elevated Buttons',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: spacing.spacing2),
        Wrap(
          spacing: spacing.spacing2,
          runSpacing: spacing.spacing2,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Default')),
            ElevatedButton(onPressed: () {}, child: const Text('Hover/Focus')),
            const ElevatedButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
        SizedBox(height: spacing.spacing3),

        // Text Buttons
        Text('Text Buttons', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: spacing.spacing2),
        Wrap(
          spacing: spacing.spacing2,
          runSpacing: spacing.spacing2,
          children: [
            TextButton(onPressed: () {}, child: const Text('Default')),
            TextButton(onPressed: () {}, child: const Text('Hover/Focus')),
            const TextButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
        SizedBox(height: spacing.spacing3),

        // Outlined Buttons
        Text(
          'Outlined Buttons',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: spacing.spacing2),
        Wrap(
          spacing: spacing.spacing2,
          runSpacing: spacing.spacing2,
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Default')),
            OutlinedButton(onPressed: () {}, child: const Text('Hover/Focus')),
            const OutlinedButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
      ],
    );
  }
}

// ===========================================================================
// CARD THEME SECTION
// ===========================================================================

class _CardThemeSection extends StatelessWidget {
  final SpacingTokens spacing;
  final RadiiTokens radii;
  final ElevationTokens elevation;

  const _CardThemeSection({
    required this.spacing,
    required this.radii,
    required this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Card Theme', style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: spacing.spacing2),
        Text(
          'Surface containers with elevation and rounded corners',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.spacing3),

        Card(
          child: Padding(
            padding: EdgeInsets.all(spacing.spacing3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sample Card',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: spacing.spacing1),
                Text(
                  'Uses CardTheme with RadiiTokens.md (8px) and ElevationTokens.level2.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: spacing.spacing2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Action')),
                    SizedBox(width: spacing.spacing1),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Primary'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// INPUT THEME SECTION
// ===========================================================================

class _InputThemeSection extends StatelessWidget {
  final SpacingTokens spacing;

  const _InputThemeSection({required this.spacing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Input Theme', style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: spacing.spacing2),
        Text(
          'Text fields with label, helper, and error states',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.spacing3),

        // Default state
        TextField(
          decoration: const InputDecoration(
            labelText: 'Label',
            helperText: 'Helper text using typography.bodySmall',
          ),
        ),
        SizedBox(height: spacing.spacing2),

        // Filled state
        TextField(
          decoration: const InputDecoration(
            labelText: 'Filled Field',
            hintText: 'Placeholder text',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: spacing.spacing2),

        // Error state
        const TextField(
          decoration: InputDecoration(
            labelText: 'Error State',
            errorText: 'Error message using typography.bodySmall',
          ),
        ),
        SizedBox(height: spacing.spacing2),

        // Disabled state
        const TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Disabled',
            helperText: 'Disabled state with 12% opacity border',
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// SPACING & RADII SECTION
// ===========================================================================

class _SpacingRadiiSection extends StatelessWidget {
  final SpacingTokens spacing;
  final RadiiTokens radii;

  const _SpacingRadiiSection({required this.spacing, required this.radii});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spacing & Radii',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: spacing.spacing2),
        Text(
          '8px grid spacing system and border radius tokens',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        SizedBox(height: spacing.spacing3),

        // Spacing scale
        Text(
          'Spacing Scale (8px grid)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: spacing.spacing2),
        Wrap(
          spacing: spacing.spacing2,
          runSpacing: spacing.spacing2,
          children: [
            _SpacingBox(
              label: '1 (8px)',
              size: spacing.spacing1,
              colorScheme: colorScheme,
            ),
            _SpacingBox(
              label: '2 (16px)',
              size: spacing.spacing2,
              colorScheme: colorScheme,
            ),
            _SpacingBox(
              label: '3 (24px)',
              size: spacing.spacing3,
              colorScheme: colorScheme,
            ),
            _SpacingBox(
              label: '4 (32px)',
              size: spacing.spacing4,
              colorScheme: colorScheme,
            ),
            _SpacingBox(
              label: '5 (40px)',
              size: spacing.spacing5,
              colorScheme: colorScheme,
            ),
          ],
        ),
        SizedBox(height: spacing.spacing3),

        // Border radius
        Text('Border Radius', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: spacing.spacing2),
        Wrap(
          spacing: spacing.spacing2,
          runSpacing: spacing.spacing2,
          children: [
            _RadiiBox(
              label: 'sm (4px)',
              radius: radii.sm,
              colorScheme: colorScheme,
            ),
            _RadiiBox(
              label: 'md (8px)',
              radius: radii.md,
              colorScheme: colorScheme,
            ),
            _RadiiBox(
              label: 'lg (12px)',
              radius: radii.lg,
              colorScheme: colorScheme,
            ),
            _RadiiBox(
              label: 'xl (16px)',
              radius: radii.xl,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ],
    );
  }
}

class _SpacingBox extends StatelessWidget {
  final String label;
  final double size;
  final ColorScheme colorScheme;

  const _SpacingBox({
    required this.label,
    required this.size,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _RadiiBox extends StatelessWidget {
  final String label;
  final double radius;
  final ColorScheme colorScheme;

  const _RadiiBox({
    required this.label,
    required this.radius,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: colorScheme.outline),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

// ===========================================================================
// ELEVATION SECTION
// ===========================================================================

class _ElevationSection extends StatelessWidget {
  final SpacingTokens spacing;
  final ElevationTokens elevation;
  final ColorScheme colorScheme;

  const _ElevationSection({
    required this.spacing,
    required this.elevation,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Elevation', style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: spacing.spacing2),
        Text(
          'Material Design elevation levels (0-24)',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        SizedBox(height: spacing.spacing3),

        Wrap(
          spacing: spacing.spacing3,
          runSpacing: spacing.spacing3,
          children: [
            _ElevationBox(
              label: 'Level 0',
              level: elevation.level0,
              colorScheme: colorScheme,
            ),
            _ElevationBox(
              label: 'Level 1',
              level: elevation.level1,
              colorScheme: colorScheme,
            ),
            _ElevationBox(
              label: 'Level 2',
              level: elevation.level2,
              colorScheme: colorScheme,
            ),
            _ElevationBox(
              label: 'Level 3',
              level: elevation.level3,
              colorScheme: colorScheme,
            ),
            _ElevationBox(
              label: 'Level 4',
              level: elevation.level4,
              colorScheme: colorScheme,
            ),
            _ElevationBox(
              label: 'Level 6',
              level: elevation.level6,
              colorScheme: colorScheme,
            ),
            _ElevationBox(
              label: 'Level 8',
              level: elevation.level8,
              colorScheme: colorScheme,
            ),
            _ElevationBox(
              label: 'Level 12',
              level: elevation.level12,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ],
    );
  }
}

class _ElevationBox extends StatelessWidget {
  final String label;
  final double level;
  final ColorScheme colorScheme;

  const _ElevationBox({
    required this.label,
    required this.level,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: level,
      borderRadius: BorderRadius.circular(8),
      color: colorScheme.surface,
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
