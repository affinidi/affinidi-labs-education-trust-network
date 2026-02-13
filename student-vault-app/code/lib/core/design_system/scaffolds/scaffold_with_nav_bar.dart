import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../infrastructure/extensions/build_context_extensions.dart';
import '../../navigation/tabs/navigation_tab_destination.dart';
import '../../navigation/tabs/tabs.dart';
import '../loaders/control_plane_events_progress_indicator.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // final onboardingState = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFC470),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            const ControlPlaneEventsProgressIndicator(),
            Expanded(child: navigationShell),
          ],
        ),
      ),
      // Only show navigation bar when onboarding is complete
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            // borderRadius: BorderRadius.circular(30),
            child: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              backgroundColor: Colors.transparent,
              indicatorColor: Theme.of(context).primaryColor.withOpacity(0.2),
              elevation: 0,
              destinations: Tabs.values
                  .map((tab) => tab.destination(l10n))
                  .toList(),
            ),
          ),
        ),
      ),
      // : null,
    );
  }
}
