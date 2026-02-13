import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ssi/ssi.dart';

import '../../../../vault/presentation/widgets/generic_credential_card.dart';
import '../../../data/vdsp_service/vdsp_service.dart';

// Biometric Authentication Bottom Sheet
class BiometricBottomSheet extends HookWidget {
  const BiometricBottomSheet({
    super.key,
    required this.onAuthenticated,
    required this.onCancel,
  });

  final VoidCallback onAuthenticated;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final slideController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    final touchController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final scaleAnimation = useMemoized(
      () => Tween<double>(begin: 1.0, end: 0.92).animate(
        CurvedAnimation(parent: touchController, curve: Curves.easeInOut),
      ),
      [touchController],
    );

    final glowAnimation = useMemoized(
      () => Tween<double>(begin: 0.2, end: 0.6).animate(
        CurvedAnimation(parent: touchController, curve: Curves.easeInOut),
      ),
      [touchController],
    );

    final isTouched = useState(false);

    useEffect(() {
      slideController.forward();

      // Simulate biometric authentication with touch animation
      Future.delayed(const Duration(milliseconds: 1200), () {
        isTouched.value = true;
        touchController.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 200), onAuthenticated);
        });
      });

      return null;
    }, []);
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: slideController,
              curve: Curves.easeOutCubic,
            ),
          ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isTouched.value ? 'Authenticated' : 'Authenticating',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade100,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Center(
                  child: AnimatedBuilder(
                    animation: touchController,
                    builder: (context, child) {
                      return ScaleTransition(
                        scale: scaleAnimation,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF4F39F6,
                            ).withValues(alpha: glowAnimation.value),
                            boxShadow: isTouched.value
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF4F39F6,
                                      ).withValues(alpha: 0.6),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                    ),
                                  ]
                                : [],
                          ),
                          child: const Icon(
                            Icons.fingerprint,
                            size: 60,
                            color: Color(0xFF4F39F6),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isTouched.value ? 'Verified!' : 'Touch ID to verify',
                  style: TextStyle(
                    fontSize: 16,
                    color: isTouched.value
                        ? Colors.green.shade400
                        : Colors.grey.shade400,
                    fontWeight: isTouched.value
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Sharing Credential Bottom Sheet
class SharingBottomSheet extends HookWidget {
  const SharingBottomSheet({
    super.key,
    required this.onComplete,
    required this.onCancel,
  });

  final VoidCallback onComplete;
  final VoidCallback onCancel;

  Future<ParsedVerifiablePresentation> _loadEmployeeCredential() async {
    final jsonString = await rootBundle.loadString(
      'assets/employee-credentials.json',
    );
    return UniversalPresentationParser.parse(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    final credentialFuture = useMemoized(_loadEmployeeCredential);
    final progress = useState(0.0);

    useEffect(() {
      controller.forward();

      // Animate progress bar (10 seconds)
      const steps = 100;
      const stepDuration = Duration(milliseconds: 100);

      for (var i = 0; i <= steps; i++) {
        Future.delayed(stepDuration * i, () {
          progress.value = i / steps;

          if (i == steps) {
            // Sharing complete
            Future.delayed(const Duration(milliseconds: 300), onComplete);
          }
        });
      }

      return null;
    }, []);
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
          ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Sharing Credential',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade100,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Meeting Room A is requesting access to your:',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FutureBuilder<ParsedVerifiablePresentation>(
                  future: credentialFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final credential = snapshot.data!;
                    return GenericCredentialCard(
                      credential: credential as VerifiableCredential,
                      canFlip: false,
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Cancel button with progress fill
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      // Background fill that progresses from left to right
                      Positioned.fill(
                        child: Row(
                          children: [
                            Expanded(
                              flex: (progress.value * 100).toInt(),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.shade900,
                                      Colors.red.shade700,
                                      Colors.red.shade400,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 100 - (progress.value * 100).toInt(),
                              child: Container(
                                color: Colors.red.shade900.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Button content
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onCancel,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Result Bottom Sheet (Success or Failure)
class ResultBottomSheet extends HookWidget {
  const ResultBottomSheet({
    super.key,
    required this.result,
    required this.onDone,
  });

  final VdspScanResult result;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final slideController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    final iconController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );

    final iconScaleAnimation = useMemoized(
      () => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: iconController, curve: Curves.elasticOut),
      ),
      [iconController],
    );

    final isSuccess = result.isSuccess;

    useEffect(() {
      slideController.forward();
      iconController.forward();

      // Auto-close success after 3 seconds, failure requires manual dismiss
      if (isSuccess) {
        Future.delayed(const Duration(seconds: 3), onDone);
      }

      return null;
    }, []);

    final iconColor = isSuccess ? Colors.green.shade500 : Colors.red.shade500;
    final icon = isSuccess ? Icons.check : Icons.close;
    final title = isSuccess ? 'Success!' : 'Failed';

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: slideController,
              curve: Curves.easeOutCubic,
            ),
          ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ScaleTransition(
                  scale: iconScaleAnimation,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconColor,
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 60,
                      weight: 700,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade100,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  result.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Show dismiss button only for failure
                if (!isSuccess)
                  ElevatedButton(
                    onPressed: onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Dismiss',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Share Confirmation Bottom Sheet
class ShareConfirmationBottomSheet extends HookWidget {
  const ShareConfirmationBottomSheet({
    super.key,
    required this.operation,
    required this.credentials,
    required this.onConfirm,
    required this.onCancel,
  });

  final String operation;
  final List<ParsedVerifiableCredential<dynamic>> credentials;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  Widget _buildInfoCard(String operation) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildInfoRow(Icons.business, 'Purpose: $operation')],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4F39F6), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade100,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    final selectedIndices = useState(<int>{});
    final topCardIndex = useState(0);

    useEffect(() {
      controller.forward();
      // Pre-select all credentials by default
      selectedIndices.value = Set<int>.from(
        List.generate(credentials.length, (index) => index),
      );
      // Set the last card as the top card initially
      topCardIndex.value = credentials.length - 1;
      return null;
    }, []);

    final textTheme = Theme.of(context).textTheme;

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
          ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Credential Request',
                        style: textTheme.headlineMedium?.copyWith(
                          color: Colors.grey.shade100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoCard(operation),
                      const SizedBox(height: 24),
                      Text(
                        'Your Credential${credentials.length > 1 ? 's' : ''}',
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.grey.shade100,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Display credentials in stack
                      if (credentials.isNotEmpty)
                        _buildCredentialStack(
                          credentials,
                          selectedIndices,
                          topCardIndex,
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'No credentials to share',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      // Hide credential count section
                      // Container(
                      //   padding: const EdgeInsets.all(16),
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey.shade800.withValues(alpha:0.5),
                      //     borderRadius: BorderRadius.circular(12),
                      //     border: Border.all(
                      //       color: Colors.orange.shade700.withValues(alpha:0.3),
                      //       width: 1,
                      //     ),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         Icons.info_outline,
                      //         color: Colors.orange.shade700,
                      //         size: 24,
                      //       ),
                      //       const SizedBox(width: 12),
                      //       Expanded(
                      //         child: Text(
                      //           '${_selectedIndices.length} credential${_selectedIndices.length != 1 ? 's' : ''} selected to share',
                      //           style: TextStyle(
                      //             color: Colors.grey.shade300,
                      //             fontSize: 13,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: selectedIndices.value.isEmpty
                            ? null
                            : onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F39F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Confirm & Share',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: onCancel,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialStack(
    List<ParsedVerifiableCredential<dynamic>> credentials,
    ValueNotifier<Set<int>> selectedIndices,
    ValueNotifier<int> topCardIndex,
  ) {
    const stackedCardOffset = 60.0;
    const cardHeight = 260.0;

    final totalHeight =
        cardHeight + ((credentials.length - 1) * stackedCardOffset);

    final renderOrder = List.generate(credentials.length, (i) => i);
    if (topCardIndex.value < renderOrder.length) {
      renderOrder.remove(topCardIndex.value);
      renderOrder.add(topCardIndex.value);
    }

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: renderOrder.map((i) {
          final isSelected = selectedIndices.value.contains(i);
          final credential = credentials[i];

          final positionIndex = i == topCardIndex.value
              ? credentials.length - 1
              : (i > topCardIndex.value ? i - 1 : i);
          final topOffset = positionIndex * stackedCardOffset;

          return AnimatedPositioned(
            key: ValueKey(i),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: topOffset,
            left: 0,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // Move this card to the top
                topCardIndex.value = i;
              },
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.5,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: cardHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: i == topCardIndex.value ? 12 : 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      // Credential card with constrained height - wrapped to block taps
                      Positioned.fill(
                        child: IgnorePointer(
                          child: SizedBox(
                            height: cardHeight,
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: GenericCredentialCard(
                                credential: credential as VerifiableCredential,
                                canFlip: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Selection indicator
                      Positioned(
                        top: 12,
                        right: 12,
                        child: InkWell(
                          onTap: () {
                            final newIndices = Set<int>.from(
                              selectedIndices.value,
                            );
                            if (isSelected) {
                              newIndices.remove(i);
                            } else {
                              newIndices.add(i);
                            }
                            selectedIndices.value = newIndices;
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFF4F39F6)
                                  : Colors.grey.shade800,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
