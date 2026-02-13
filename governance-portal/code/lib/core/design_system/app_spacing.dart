/// Governance Portal Dashboard Spacing System
///
/// Based on 03-design-tokens.yaml
/// Version: 2.0.0
/// Last Updated: January 15, 2026
///
/// Design Philosophy:
/// - 8px baseline grid (industry standard for component-based design)
/// - 4px fine steps for micro-adjustments (tight layouts, icon padding)
/// - Ensures visual rhythm and consistent layouts
class AppSpacing {
  AppSpacing._(); // Private constructor

  // ===========================================================================
  // SPACING SCALE (8px Grid with 4px Fine Steps)
  // ===========================================================================

  /// No spacing (0px)
  static const double spacing0 = 0.0;

  /// Fine step (4px)
  ///
  /// Usage: Micro spacing, icon padding, tight layouts
  static const double spacing0_5 = 4.0;

  /// Base unit (8px)
  ///
  /// Usage: Minimal spacing between elements
  static const double spacing1 = 8.0;

  /// Fine step (12px)
  ///
  /// Usage: Compact padding, small gaps
  static const double spacing1_5 = 12.0;

  /// Small spacing (16px)
  ///
  /// Usage: Common spacing, card padding, form field gaps
  static const double spacing2 = 16.0;

  /// Medium spacing (24px)
  ///
  /// Usage: Section spacing, larger gaps
  static const double spacing3 = 24.0;

  /// Large spacing (32px)
  ///
  /// Usage: Major section gaps, modal padding
  static const double spacing4 = 32.0;

  /// XL spacing (40px)
  ///
  /// Usage: Large section separations
  static const double spacing5 = 40.0;

  /// 2XL spacing (48px)
  ///
  /// Usage: Very large gaps between major sections
  static const double spacing6 = 48.0;

  /// 3XL spacing (64px)
  ///
  /// Usage: Extra large section spacing
  static const double spacing8 = 64.0;

  /// 4XL spacing (80px)
  ///
  /// Usage: Very large spacing (rare)
  static const double spacing10 = 80.0;

  /// 5XL spacing (96px)
  ///
  /// Usage: Massive spacing (rare)
  static const double spacing12 = 96.0;

  /// 6XL spacing (128px)
  ///
  /// Usage: Ultra-large spacing (very rare)
  static const double spacing16 = 128.0;

  // ===========================================================================
  // SEMANTIC SPACING ALIASES
  // ===========================================================================

  /// Extra Small (4px)
  static const double xs = spacing0_5;

  /// Small (8px)
  static const double sm = spacing1;

  /// Medium (16px)
  static const double md = spacing2;

  /// Large (24px)
  static const double lg = spacing3;

  /// Extra Large (32px)
  static const double xl = spacing4;

  /// 2XL (48px)
  static const double xxl = spacing6;

  // ===========================================================================
  // COMPONENT-SPECIFIC SPACING
  // ===========================================================================

  /// Button Padding Horizontal (24px)
  static const double buttonPaddingHorizontal = spacing3;

  /// Button Padding Vertical (12px)
  static const double buttonPaddingVertical = spacing1_5;

  /// Button Small Padding Horizontal (16px)
  static const double buttonSmallPaddingHorizontal = spacing2;

  /// Button Small Padding Vertical (8px)
  static const double buttonSmallPaddingVertical = spacing1;

  /// Button Large Padding Horizontal (32px)
  static const double buttonLargePaddingHorizontal = spacing4;

  /// Button Large Padding Vertical (16px)
  static const double buttonLargePaddingVertical = spacing2;

  /// Input Field Padding Horizontal (12px)
  static const double inputPaddingHorizontal = spacing1_5;

  /// Input Field Padding Vertical (8px)
  static const double inputPaddingVertical = spacing1;

  /// Card Padding (16px)
  static const double cardPadding = spacing2;

  /// Card Large Padding (24px)
  static const double cardLargePadding = spacing3;

  /// Modal Padding (24px)
  static const double modalPadding = spacing3;

  /// Navigation Padding (16px)
  static const double navPadding = spacing2;

  /// Table Cell Padding Horizontal (12px)
  static const double tableCellPaddingHorizontal = spacing1_5;

  /// Table Cell Padding Vertical (8px)
  static const double tableCellPaddingVertical = spacing1;

  /// Key Section Padding (16px)
  ///
  /// Usage: Rainbow outline sections
  static const double keySectionPadding = spacing2;

  // ===========================================================================
  // BORDER RADIUS
  // ===========================================================================

  /// No radius (0px)
  ///
  /// Usage: Sharp corners (table cells)
  static const double radiusNone = 0.0;

  /// Small radius (4px)
  ///
  /// Usage: Subtle rounding
  static const double radiusSm = 4.0;

  /// Medium radius (8px)
  ///
  /// Usage: Buttons, inputs
  static const double radiusMd = 8.0;

  /// Large radius (12px)
  ///
  /// Usage: Cards, modals
  static const double radiusLg = 12.0;

  /// Extra large radius (16px)
  ///
  /// Usage: Large containers
  static const double radiusXl = 16.0;

  /// 2XL radius (24px)
  ///
  /// Usage: Very rounded (rarely used)
  static const double radius2xl = 24.0;

  /// Full radius (9999px)
  ///
  /// Usage: Perfect circles, badges
  static const double radiusFull = 9999.0;

  // ===========================================================================
  // BORDER WIDTHS
  // ===========================================================================

  /// No border (0px)
  static const double borderNone = 0.0;

  /// Thin border (1px)
  ///
  /// Usage: Default borders (tables, inputs)
  static const double borderThin = 1.0;

  /// Medium border (2px)
  ///
  /// Usage: Focus states, emphasis
  static const double borderMedium = 2.0;

  /// Thick border (3px)
  ///
  /// Usage: Rainbow outline for key sections
  static const double borderThick = 3.0;

  // ===========================================================================
  // ICON SIZES
  // ===========================================================================

  /// Extra small icon (16px)
  ///
  /// Usage: Small inline icons
  static const double iconXs = 16.0;

  /// Small icon (20px)
  ///
  /// Usage: Button icons, nav icons
  static const double iconSm = 20.0;

  /// Medium icon (24px)
  ///
  /// Usage: Default icon size
  static const double iconMd = 24.0;

  /// Large icon (32px)
  ///
  /// Usage: Large icons
  static const double iconLg = 32.0;

  /// Extra large icon (48px)
  ///
  /// Usage: Empty state icons
  static const double iconXl = 48.0;

  /// 2XL icon (64px)
  ///
  /// Usage: Hero icons
  static const double icon2xl = 64.0;

  // ===========================================================================
  // TOUCH TARGETS (WCAG Compliance)
  // ===========================================================================

  /// Minimum touch target (44px)
  ///
  /// Usage: WCAG minimum for accessibility
  static const double touchTargetMinimum = 44.0;

  /// Recommended touch target (48px)
  ///
  /// Usage: Comfortable touch target
  static const double touchTargetRecommended = 48.0;

  // ===========================================================================
  // LAYOUT DIMENSIONS
  // ===========================================================================

  /// Navigation width (240px)
  ///
  /// Usage: Fixed left sidebar width on desktop
  static const double navWidth = 240.0;

  /// Navigation collapsed width (64px)
  ///
  /// Usage: Collapsed sidebar (icon-only)
  static const double navWidthCollapsed = 64.0;

  /// Navigation item height (48px)
  static const double navItemHeight = touchTargetRecommended;

  /// App bar height (64px)
  static const double appBarHeight = 64.0;

  /// Modal header height (64px)
  static const double modalHeaderHeight = 64.0;

  /// Modal footer height (72px)
  static const double modalFooterHeight = 72.0;

  /// Table row height compact (36px)
  ///
  /// Usage: Dense table layout
  static const double tableRowHeightCompact = 36.0;

  /// Table row height cozy (44px)
  ///
  /// Usage: Comfortable table layout
  static const double tableRowHeightCozy = 44.0;

  /// Table row height comfortable (52px)
  ///
  /// Usage: Spacious table layout
  static const double tableRowHeightComfortable = 52.0;

  /// Table header height (48px)
  static const double tableHeaderHeight = 48.0;

  // ===========================================================================
  // RESPONSIVE BREAKPOINTS
  // ===========================================================================

  /// Mobile breakpoint (0px)
  ///
  /// Usage: 0-639px
  static const double breakpointMobile = 0.0;

  /// Mobile Large breakpoint (480px)
  ///
  /// Usage: Large phones
  static const double breakpointMobileLg = 480.0;

  /// Tablet breakpoint (640px)
  ///
  /// Usage: Small tablets
  static const double breakpointTablet = 640.0;

  /// Tablet Large breakpoint (768px)
  ///
  /// Usage: Large tablets
  static const double breakpointTabletLg = 768.0;

  /// Desktop breakpoint (1024px)
  ///
  /// Usage: Laptops, desktops (modal becomes 50% width)
  static const double breakpointDesktop = 1024.0;

  /// Desktop Large breakpoint (1280px)
  ///
  /// Usage: Large desktops
  static const double breakpointDesktopLg = 1280.0;

  /// Wide breakpoint (1440px)
  ///
  /// Usage: Wide screens (max content width)
  static const double breakpointWide = 1440.0;

  /// Ultra-wide breakpoint (1920px)
  ///
  /// Usage: Ultra-wide monitors
  static const double breakpointUltraWide = 1920.0;

  // ===========================================================================
  // CONTAINER MAX WIDTHS
  // ===========================================================================

  /// Container width tablet (768px)
  static const double containerTablet = 768.0;

  /// Container width desktop (1440px)
  ///
  /// Usage: Max width for content area
  static const double containerDesktop = 1440.0;

  /// Container width content (720px)
  ///
  /// Usage: Max width for forms, readable content
  static const double containerContent = 720.0;

  /// Modal width minimum (560px)
  static const double modalMinWidth = 560.0;

  /// Modal width maximum (720px)
  static const double modalMaxWidth = 720.0;

  // ===========================================================================
  // Z-INDEX LAYERS
  // ===========================================================================

  /// Base z-index (0)
  ///
  /// Usage: Normal flow
  static const int zIndexBase = 0;

  /// Dropdown z-index (1000)
  static const int zIndexDropdown = 1000;

  /// Sticky z-index (1100)
  ///
  /// Usage: Sticky headers
  static const int zIndexSticky = 1100;

  /// Fixed z-index (1200)
  ///
  /// Usage: Fixed elements
  static const int zIndexFixed = 1200;

  /// Modal backdrop z-index (1300)
  static const int zIndexModalBackdrop = 1300;

  /// Modal z-index (1400)
  static const int zIndexModal = 1400;

  /// Popover z-index (1500)
  static const int zIndexPopover = 1500;

  /// Tooltip z-index (1600)
  static const int zIndexTooltip = 1600;

  // ===========================================================================
  // FOCUS INDICATORS
  // ===========================================================================

  /// Focus outline width (2px)
  static const double focusOutlineWidth = borderMedium;

  /// Focus outline offset (2px)
  static const double focusOutlineOffset = 2.0;
}
