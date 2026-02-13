import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/widgets/app_header.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'Dashboard',
            searchPlaceholder: 'Search...',
            showCreateButton: false,
            showNotifications: true,
          ),
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(AppSpacing.spacing4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.dashboard_outlined,
                      size: 80,
                      color: AppColors.neutral300,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      'Dashboard Coming Soon',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            // color: AppColors.neutral500,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Use the Records page to view and manage trust registry data.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.neutral400,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
