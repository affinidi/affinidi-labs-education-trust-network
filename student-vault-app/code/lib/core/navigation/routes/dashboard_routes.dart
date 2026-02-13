import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ssi/ssi.dart';
import '../../design_system/scaffolds/scaffold_with_nav_bar.dart';
import 'route_names.dart';
import 'route_paths.dart';
import '../../../features/profile/presentation/profile_screen.dart';
import '../../../features/vault/presentation/screens/credential_json_screen.dart';
import '../../../features/vault/presentation/screens/credential_view_screen.dart';
import '../../../features/vault/presentation/screens/credentials_screen.dart';
import '../../../features/vdsp_share/presentation/screens/scan_flow/scan_screen.dart';
import '../../../features/vdsp_share/presentation/screens/scan_share_screen.dart';

part 'dashboard_routes.g.dart';

// Dashboard shell route
@TypedStatefulShellRoute<DashboardShellRouteData>(
  branches: [
    TypedStatefulShellBranch<CredentialsBranchData>(
      routes: [
        TypedGoRoute<CredentialsRoute>(
          path: '/dashboard/credentials',
          name: RouteNames.credentials,
          routes: [
            TypedGoRoute<CredentialViewRoute>(
              path: RoutePaths.credentialView,
              name: RouteNames.credentialView,
            ),
            TypedGoRoute<CredentialJsonRoute>(
              path: RoutePaths.credentialJson,
              name: RouteNames.credentialJson,
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranchData>(
      routes: [
        TypedGoRoute<ProfileRoute>(
          path: '/dashboard/profile',
          name: RouteNames.profile,
        ),
      ],
    ),
    TypedStatefulShellBranch<ScanShareBranchData>(
      routes: [
        TypedGoRoute<ScanShareRoute>(
          path: '/dashboard/scan-share',
          name: RouteNames.scanShare,
          routes: [
            TypedGoRoute<ScanCameraRoute>(
              path: RoutePaths.scanCamera,
              name: RouteNames.scanCamera,
            ),
          ],
        ),
      ],
    ),
  ],
)
class DashboardShellRouteData extends StatefulShellRouteData {
  const DashboardShellRouteData();

  static final $navigatorKey = dashboardNavigatorKey;
  static const String $restorationScopeId = 'appShellRestorationScopeId';

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return ScaffoldWithNavBar(navigationShell: navigationShell);
  }
}

// Global navigator keys for branches
final dashboardNavigatorKey = GlobalKey<NavigatorState>();
final _contactsNavigatorKey = GlobalKey<NavigatorState>();
final _connectionsNavigatorKey = GlobalKey<NavigatorState>();
final _identitiesNavigatorKey = GlobalKey<NavigatorState>();
final _settingsNavigatorKey = GlobalKey<NavigatorState>();
final _dashboardTabNavigatorKey = GlobalKey<NavigatorState>();
final _credentialsNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();
final _scanShareNavigatorKey = GlobalKey<NavigatorState>();

// Branch data classes
class DashboardBranchData extends StatefulShellBranchData {
  const DashboardBranchData();

  static final $navigatorKey = _dashboardTabNavigatorKey;
  static const String $restorationScopeId = 'dashboardBranchRestorationScopeId';
}

class CredentialsBranchData extends StatefulShellBranchData {
  const CredentialsBranchData();

  static final $navigatorKey = _credentialsNavigatorKey;
  static const String $restorationScopeId =
      'credentialsBranchRestorationScopeId';
}

class ProfileBranchData extends StatefulShellBranchData {
  const ProfileBranchData();

  static final $navigatorKey = _profileNavigatorKey;
  static const String $restorationScopeId = 'profileBranchRestorationScopeId';
}

class ScanShareBranchData extends StatefulShellBranchData {
  const ScanShareBranchData();

  static final $navigatorKey = _scanShareNavigatorKey;
  static const String $restorationScopeId = 'scanShareBranchRestorationScopeId';
}

// Route classes
// class DashboardRoute extends GoRouteData with _$DashboardRoute {
//   const DashboardRoute();

//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return Consumer(
//       builder: (context, ref, _) {
//         final onboardingState = ref.watch(onboardingProvider);

//         // Show onboarding if not completed
//         if (onboardingState.step != OnboardingStep.done) {
//           return const OnboardingScreen();
//         }
//         return const DashboardScreen();
//       },
//     );
//   }
// }

class CredentialsRoute extends GoRouteData with _$CredentialsRoute {
  const CredentialsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CredentialsScreen();
  }
}

class ProfileRoute extends GoRouteData with _$ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Consumer(
      builder: (context, ref, _) {
        // final authState = ref.watch(authProvider);
        return const ProfileScreen();
      },
    );
  }
}

class ScanShareRoute extends GoRouteData with _$ScanShareRoute {
  const ScanShareRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ScanShareScreen();
  }
}

// class IdvFlowRoute extends GoRouteData with _$IdvFlowRoute {
//   const IdvFlowRoute({this.autoStart = false});

//   final bool autoStart;

//   @override
//   Widget build(BuildContext context, GoRouterState state) =>
//       IdvFlowScreen(autoStart: autoStart);
// }

// class BusinessCardRoute extends GoRouteData with _$BusinessCardRoute {
//   const BusinessCardRoute();

//   @override
//   Widget build(BuildContext context, GoRouterState state) =>
//       const BusinessCardScreen();
// }

class ScanCameraRoute extends GoRouteData with _$ScanCameraRoute {
  const ScanCameraRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ScannerScreen();
}

class CredentialViewRoute extends GoRouteData with _$CredentialViewRoute {
  const CredentialViewRoute({required this.$extra});
  final ParsedVerifiableCredential $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CredentialViewScreen(credential: $extra);
}

class CredentialJsonRoute extends GoRouteData with _$CredentialJsonRoute {
  const CredentialJsonRoute({required this.$extra});
  final ParsedVerifiableCredential $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CredentialJsonScreen(credential: $extra);
}

// Branch data classes for each tab
class ContactsBranchData extends StatefulShellBranchData {
  const ContactsBranchData();

  static final $navigatorKey = _contactsNavigatorKey;
  static const String $restorationScopeId = 'contactsBranchRestorationScopeId';
}

class ConnectionsBranchData extends StatefulShellBranchData {
  const ConnectionsBranchData();

  static final $navigatorKey = _connectionsNavigatorKey;
  static const String $restorationScopeId =
      'connectionsBranchRestorationScopeId';
}

class IdentitiesBranchData extends StatefulShellBranchData {
  const IdentitiesBranchData();

  static final $navigatorKey = _identitiesNavigatorKey;
  static const String $restorationScopeId =
      'identitiesBranchRestorationScopeId';
}

class SettingsBranchData extends StatefulShellBranchData {
  const SettingsBranchData();

  static final $navigatorKey = _settingsNavigatorKey;
  static const String $restorationScopeId = 'settingsBranchRestorationScopeId';
}
