import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'routes/app_routes.dart';
import 'routes/route_paths.dart';
import '../../features/onboarding/presentation/screens/onboarding.screen.dart';
import '../../features/profile/presentation/providers/user_profile_provider.dart';
import '../../features/settings/data/settings_service/settings_service.dart';

import '../../features/authentication/presentation/screens/login/login_screen.dart';

part 'router_config_provider.g.dart';

/// Global navigator key used for accessing the root [Navigator] instance
/// outside of the widget tree.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Holds the return URL for navigation after authentication/onboarding.
String? returnUrl;

/// Logger key for this router configuration.
const logKey = 'routerConfigProvider';

/// Route guard used to control navigation based on user profile and
/// onboarding state.
///
/// Returns a redirect path if conditions require it, otherwise `null`
/// to continue with the requested navigation.
///
/// [ref] - Reference to providers for reading state.
/// [context] - The current build context.
/// [state] - The current [GoRouterState].
/// [defaultRoute] - The default route to redirect to if conditions are not met.
String? _guard(
  Ref ref,
  BuildContext context,
  GoRouterState state,
  String defaultRoute,
) {
  final settingsState = ref.read(settingsServiceProvider);
  final userProfileState = ref.read(userProfileProvider);
  final currentPath = state.matchedLocation;

  // Check if user profile exists
  final hasProfile = userProfileState.when(
    data: (profile) => profile != null,
    loading: () => false,
    error: (_, __) => false,
  );

  // Check if user has completed onboarding
  final hasOnboarded = settingsState.alreadyOnboarded ?? false;

  // If user has profile and has onboarded, go to dashboard
  if (hasProfile && hasOnboarded) {
    // If on login or onboarding screen, redirect to dashboard
    if (currentPath == RoutePaths.login ||
        currentPath == RoutePaths.onboarding) {
      return '/dashboard/credentials';
    }
    // If trying to access root, redirect to dashboard
    if (currentPath == '/') {
      return '/dashboard/credentials';
    }
    return null;
  }

  // If has profile but not onboarded (shouldn't happen, but handle it)
  if (hasProfile && !hasOnboarded) {
    if (currentPath.startsWith('/dashboard')) {
      return RoutePaths.onboarding;
    }
    return null;
  }

  // No profile - need to go through login/onboarding flow
  // If on login screen, let it proceed
  if (currentPath == RoutePaths.login) {
    return null;
  }

  // If on onboarding screen, let it proceed
  if (currentPath == RoutePaths.onboarding) {
    return null;
  }

  // Without profile, redirect to login
  if (currentPath.startsWith('/dashboard')) {
    return RoutePaths.login;
  }

  // Default: redirect to login
  if (currentPath == '/') {
    return RoutePaths.login;
  }

  return null;
}

/// Notifier to refresh [GoRouter] when user profile or
/// onboarding state changes.
///
/// Listens to:
/// - [userProfileProvider]
/// - [settingsServiceProvider]
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this.ref) {
    ref.listen(userProfileProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });

    ref.listen(
      settingsServiceProvider.select((state) => state.alreadyOnboarded),
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  final Ref ref;
}

/// Provides the app's [GoRouter] configuration.
///
/// Sets up navigation guards, refresh logic, and the main route table.
///
/// [ref] - Used to read dependencies like authentication and settings state.
@Riverpod(keepAlive: true)
GoRouter routerConfig(Ref ref) {
  final defaultPath = RoutePaths.login;

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    redirect: (BuildContext context, GoRouterState state) =>
        _guard(ref, context, state, defaultPath),
    refreshListenable: GoRouterRefreshNotifier(ref),
    routes: [
      GoRoute(path: '/', redirect: (context, state) => null),
      GoRoute(
        path: RoutePaths.dashboard,
        redirect: (context, state) => '/dashboard/credentials',
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      ...appRoutes,
    ],
  );
}
