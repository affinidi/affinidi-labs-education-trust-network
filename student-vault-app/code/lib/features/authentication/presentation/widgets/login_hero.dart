import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A hero/banner widget with a complex gradient background and 3 floating emojis.
/// - Gradient derives from the current theme's ColorScheme (primary/secondary).
/// - Emojis float vertically with slight rotation; each has its own phase offset.
class FloatingEmojiBanner extends StatefulWidget {
  const FloatingEmojiBanner({
    super.key,
    this.height = 180,
    this.emojis = const ['🎓', '💼', '✨'],
    this.amplitude = 8.0, // max vertical movement in px
    this.period = const Duration(seconds: 6),
    this.gradientBoost = 0.22, // how strong the gradient overlays are (0..1)
    this.semanticLabel,
  }) : assert(emojis.length == 3, 'Provide exactly 3 emojis for this banner');

  final double height;
  final List<String> emojis;
  final double amplitude;
  final Duration period;
  final double gradientBoost;
  final String? semanticLabel;

  @override
  State<FloatingEmojiBanner> createState() => _FloatingEmojiBannerState();
}

class _FloatingEmojiBannerState extends State<FloatingEmojiBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();

    // Bounded controller (repeat expects 0..1)
    final safePeriod = widget.period <= Duration.zero
        ? const Duration(seconds: 6)
        : widget.period;

    _ctrl = AnimationController(vsync: this, duration: safePeriod)..repeat();
  }

  @override
  void didUpdateWidget(covariant FloatingEmojiBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period && widget.period > Duration.zero) {
      _ctrl
        ..duration = widget.period
        ..repeat();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Semantics(
      label: widget.semanticLabel,
      container: widget.semanticLabel != null, // decorative if null
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1) Base gradient (top -> bottom orange→cream)
            DecoratedBox(decoration: _gradientDecoration(scheme)),
            // Optional soft “sun” overlays
            DecoratedBox(decoration: _topLeftSunOverlay(scheme)),
            DecoratedBox(decoration: _topRightRadialGlowOverlay(scheme)),
            // 2) Subtle vignette for readability
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.7, -0.9),
                  radius: 1.4,
                  colors: [
                    Colors.black.withOpacity(0.05),
                    Colors.transparent,
                    Colors.black.withOpacity(0.10),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),

            // 3) Floating emojis
            AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                final t = _ctrl.value * 2 * math.pi;

                final w = size.width;
                final spacing = w / 4;

                // Explicit list type, with real generics <_FloatingConfig>
                final items = <_FloatingConfig>[
                  _FloatingConfig(
                    text: widget.emojis[0],
                    centerX: spacing * 1.0,
                    baseY: widget.height * 0.52,
                    phase: 0.0,
                    amp: widget.amplitude,
                    rotAmpDeg: 3.0,
                    fontSize: 44,
                  ),
                  _FloatingConfig(
                    text: widget.emojis[1],
                    centerX: spacing * 2.0,
                    baseY: widget.height * 0.46,
                    phase: math.pi / 2,
                    amp: widget.amplitude * 1.2,
                    rotAmpDeg: 4.0,
                    fontSize: 56,
                  ),
                  _FloatingConfig(
                    text: widget.emojis[2],
                    centerX: spacing * 3.0,
                    baseY: widget.height * 0.50,
                    phase: math.pi * 1.3,
                    amp: widget.amplitude * 0.9,
                    rotAmpDeg: 2.5,
                    fontSize: 40,
                  ),
                ];

                return Stack(
                  // Make map return Widgets explicitly; fix children type
                  children: items
                      .map<Widget>((cfg) {
                        final dy = math.sin(t + cfg.phase) * cfg.amp;
                        final rot =
                            (math.sin(t + cfg.phase * 0.85) * cfg.rotAmpDeg) *
                            (math.pi / 180);

                        return Positioned(
                          left: cfg.centerX - cfg.fontSize / 2,
                          top: cfg.baseY + dy - cfg.fontSize / 2,
                          child: Transform.rotate(
                            angle: rot,
                            child: Text(
                              cfg.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: cfg.fontSize.toDouble(),
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.18),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                      .toList(growable: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- Decorations --------------------

BoxDecoration _gradientDecoration(ColorScheme scheme) {
  const orange = Color.fromARGB(255, 255, 196, 112);
  const cream = Color.fromARGB(255, 255, 231, 178);

  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [orange, cream],
      stops: [0.00, 1.00],
    ),
  );
}

/// Adds a subtle top-left radial glow on top of the linear base.
BoxDecoration _topLeftSunOverlay(ColorScheme scheme) {
  const s = Color.fromARGB(255, 255, 240, 162);
  final a = s.withAlpha(0);
  // const s = Colors.redAccent;
  return BoxDecoration(
    gradient: RadialGradient(
      center: const Alignment(-1, -1),
      radius: 1,
      colors: [s, a],
      stops: const [0, 1],
    ),
  );
}

/// Adds a subtle top-right radial glow on top of the linear base.
BoxDecoration _topRightRadialGlowOverlay(ColorScheme scheme) {
  const c = Color.fromARGB(255, 255, 142, 50);
  final a = c.withAlpha(0);
  return BoxDecoration(
    gradient: RadialGradient(
      center: const Alignment(1, -1.5),
      radius: 1,
      colors: [c, a],
      stops: const [0, 1],
    ),
  );
}

// -------------------- Model (top-level!) --------------------

class _FloatingConfig {
  const _FloatingConfig({
    required this.text,
    required this.centerX,
    required this.baseY,
    required this.phase,
    required this.amp,
    required this.rotAmpDeg,
    required this.fontSize,
  });

  final String text;
  final double centerX;
  final double baseY;
  final double phase; // radians
  final double amp; // px
  final double rotAmpDeg; // degrees
  final int fontSize;
}
