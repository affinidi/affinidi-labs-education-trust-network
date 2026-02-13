import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../design_system/themes/app_theme.dart';
import '../navigation/router_config_provider.dart';
import 'app_controller.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routerConfigProvider);
    ref.read(appControllerProvider);

    return MaterialApp.router(
      scrollBehavior: const ScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      debugShowCheckedModeBanner: false,
      title: 'Universal Student Vault',
      routerConfig: routerConfig,
      theme: AppTheme.light,
      localizationsDelegates: [...AppLocalizations.localizationsDelegates],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();

        return MediaQuery.withNoTextScaling(child: child);
      },
    );
  }
}
