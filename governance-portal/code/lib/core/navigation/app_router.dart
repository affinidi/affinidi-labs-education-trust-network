import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/welcome/presentation/screens/welcome_screen.dart';
import '../../features/welcome/presentation/screens/onboarding_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/authorities/presentation/screens/authorities_screen.dart';
import '../../features/entities/presentation/screens/entities_screen.dart';
import '../../features/records/presentation/screens/records_list_screen/records_list_screen.dart';
import '../../features/records/presentation/screens/record_form_screen.dart';
import '../../features/query/presentation/screens/query_test_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/records/data/repositories/records_repository.provider.dart';
import '../widgets/app_shell.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/authorities',
            name: 'authorities',
            builder: (context, state) => const AuthoritiesScreen(),
          ),
          GoRoute(
            path: '/entities',
            name: 'entities',
            builder: (context, state) => const EntitiesScreen(),
          ),
          GoRoute(
            path: '/records',
            name: 'records',
            builder: (context, state) => Consumer(
              builder: (context, ref, _) {
                final repositoryAsync = ref.watch(recordsRepositoryProvider);
                return repositoryAsync.when(
                  data: (repository) =>
                      RecordsListScreen(repository: repository),
                  loading: () => const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stack) => Scaffold(
                    body: Center(child: Text('Error: $error')),
                  ),
                );
              },
            ),
          ),
          GoRoute(
            path: '/records/create',
            name: 'create-record',
            builder: (context, state) => Consumer(
              builder: (context, ref, _) {
                final repositoryAsync = ref.watch(recordsRepositoryProvider);
                return repositoryAsync.when(
                  data: (repository) =>
                      RecordFormScreen(repository: repository),
                  loading: () => const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stack) => Scaffold(
                    body: Center(child: Text('Error: $error')),
                  ),
                );
              },
            ),
          ),
          GoRoute(
            path: '/query',
            name: 'query',
            builder: (context, state) => const QueryTestScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
}

// Helper class for router refresh
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
