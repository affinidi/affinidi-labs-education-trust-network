import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:governance_portal/core/design_system/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/infrastructure/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 [main] Starting app initialization...');

  // Load environment variables through AppConfig
  await AppConfig.loadEnvironment();

  print('🚀 [main] Environment loaded, validating config...');

  // Validate required configuration
  try {
    AppConfig.validate();
    print('✅ [main] Configuration validated successfully');
  } catch (e) {
    print('⚠️  [main] Configuration error: $e');
    // Continue anyway - validation errors will surface when features are used
  }

  print('🚀 [main] Running app...');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Trust Registry Governance Portal by Affinidi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
