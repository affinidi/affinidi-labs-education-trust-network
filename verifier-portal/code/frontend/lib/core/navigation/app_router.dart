import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/jobs/presentation/screens/jobs_list_screen.dart';
import '../../features/jobs/presentation/screens/job_detail_screen.dart';
import '../../features/job_application/presentation/screens/job_application_screen.dart';
import '../../features/debug/presentation/screens/theme_preview_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/jobs',
    routes: [
      GoRoute(
        path: '/jobs',
        name: 'jobs',
        builder: (context, state) => const JobsListScreen(),
      ),
      GoRoute(
        path: '/jobs/:id',
        name: 'job-detail',
        builder: (context, state) {
          final jobId = state.pathParameters['id']!;
          return JobDetailScreen(jobId: jobId);
        },
      ),
      GoRoute(
        path: '/jobs/:jobId/apply',
        name: 'apply',
        builder: (context, state) {
          final jobId = state.pathParameters['jobId']!;
          return JobApplicationScreen(jobId: jobId);
        },
      ),

      // ===========================================================================
      // DEBUG ROUTES (Not exposed in production UI)
      // ===========================================================================
      GoRoute(
        path: '/debug/theme-preview',
        name: 'theme-preview',
        builder: (context, state) => const ThemePreviewScreen(),
      ),
    ],
  );
});
