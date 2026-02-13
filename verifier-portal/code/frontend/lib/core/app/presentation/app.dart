import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nova_corp_verifier/core/design_system/themes/app_theme.dart';
import 'package:nova_corp_verifier/core/navigation/app_router.dart';

/// NovaCorp Employer Verification Portal - Root Application Widget
///
/// Theme Usage Guide:
/// ==================
/// Access Material theme properties:
///   - Colors: Theme.of(context).colorScheme.primary
///   - Typography: Theme.of(context).textTheme.bodyLarge
///   - Icon sizes: Theme.of(context).iconTheme.size
///
/// Access design tokens directly:
///   - Colors: Theme.of(context).extension<ColorTokens>()!.primary500
///   - Typography: Theme.of(context).extension<TypographyTokens>()!.h1Desktop
///   - Spacing: Theme.of(context).extension<SpacingTokens>()!.spacing3
///   - Radii: Theme.of(context).extension<RadiiTokens>()!.borderMd
///   - Elevation: Theme.of(context).extension<ElevationTokens>()!.level2
///
class NovaCorpApp extends ConsumerWidget {
  const NovaCorpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'NovaCorp - Employer Verification Portal',

      // Design System Themes (verifier-portal/design-language/03-design-tokens.yaml)
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light, // TODO: Add theme toggle in settings
      // Material 3 Design
      // Note: useMaterial3 is already set in AppTheme.light/dark ThemeData

      // Navigation (app_router.dart - routes defined via go_router)
      routerConfig: router,

      // Production settings
      debugShowCheckedModeBanner: false,
    );
  }
}
