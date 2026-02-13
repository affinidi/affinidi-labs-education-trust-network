import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system/app_colors.dart';
import 'app_navigation.dart';

/// App shell with navigation sidebar + content area
/// Layout: [Navigation (240px/64px)] [Content (flexible)]
class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(navigationCollapsedProvider);

    return Scaffold(
      backgroundColor: AppColors.navBackground,
      body: Row(
        children: [
          // Left navigation sidebar - elevated above glow, responsive width
          SizedBox(
            width: isCollapsed ? 64 : 240,
            child: Material(
              elevation: 16,
              color: Colors.transparent,
              child: const AppNavigation(),
            ),
          ),

          // Main content area with white rounded container
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 16,
                top: 16,
                // No bottom padding - extends to edge
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    // No bottom radius - extends to edge
                  ),
                  boxShadow: [
                    // White glow base (most visible layer)
                    BoxShadow(
                      color: Colors.white.withOpacity(0.6),
                      blurRadius: 24,
                      spreadRadius: 1,
                      offset: const Offset(4, 0),
                    ),
                    // Purple glow (color accent layer)
                    BoxShadow(
                      color: AppColors.accentPurple.withOpacity(0.5),
                      blurRadius: 32,
                      spreadRadius: 1,
                      offset: const Offset(0, 0),
                    ),
                    // Subtle dark shadow for depth
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
