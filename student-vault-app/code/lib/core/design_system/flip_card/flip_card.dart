import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'flip_card_controller.dart';

/// A reusable flip card widget that provides a 3D flip animation
/// between a front and back side.
///
/// This widget handles all the animation logic internally and exposes
/// simple properties for customization. It integrates with a global
/// flip card controller to ensure only one card is flipped at a time.
class FlipCard extends HookConsumerWidget {
  const FlipCard({
    super.key,
    required this.cardId,
    required this.frontSide,
    required this.backSide,
    this.canFlip = true,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
    this.onFlip,
  });

  /// Unique identifier for this card (required for global flip coordination)
  final String cardId;

  /// The widget to display on the front of the card
  final Widget frontSide;

  /// The widget to display on the back of the card
  final Widget backSide;

  /// Whether the card can be flipped (defaults to true)
  final bool canFlip;

  /// Duration of the flip animation
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Callback when the card is flipped
  final VoidCallback? onFlip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(duration: duration);

    final animation = useMemoized(
      () => Tween<double>(
        begin: 0,
        end: pi,
      ).animate(CurvedAnimation(parent: controller, curve: curve)),
      [controller, curve],
    );

    final showBack = useState(false);

    void toggleFlip() {
      if (!canFlip) return;

      // Update global flip state
      ref.read(flipCardControllerProvider.notifier).flipCard(cardId);
      onFlip?.call();
    }

    // Watch the global flip state
    final flippedCardId = ref.watch(flipCardControllerProvider);
    final shouldBeFlipped = flippedCardId == cardId;

    // Sync local animation state with global state
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (shouldBeFlipped && !showBack.value) {
          showBack.value = true;
          controller.forward();
        } else if (!shouldBeFlipped && showBack.value) {
          showBack.value = false;
          controller.reverse();
        }
      });
      return null;
    }, [shouldBeFlipped]);

    return GestureDetector(
      onTap: toggleFlip,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final angle = animation.value;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(angle);

          // Determine which side to show based on rotation angle
          final showFront = angle <= pi / 2;

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: showFront
                ? frontSide
                : Transform(
                    transform: Matrix4.rotationY(pi),
                    alignment: Alignment.center,
                    child: backSide,
                  ),
          );
        },
      ),
    );
  }
}
