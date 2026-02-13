import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens/color_tokens.dart';
import '../../../../core/design_system/tokens/spacing_tokens.dart';
import '../../../../core/design_system/tokens/radii_tokens.dart';
import '../../../../core/design_system/tokens/typography_tokens.dart';
import '../../../../core/design_system/tokens/elevation_tokens.dart';
import '../../../../core/design_system/components/top_navigation_bar.dart';
import '../../../../core/design_system/components/app_chip.dart';
import '../../domain/entities/job_opening.dart';
import '../providers/jobs_providers.dart';
import 'package:intl/intl.dart';

/// Job detail screen with NovaCorp design
///
/// Displays full job details with:
/// - Top navigation bar with logo
/// - Desktop-friendly max-width layout
/// - Horizontal pill row for job attributes
/// - Proper spacing per design tokens
/// - Fixed-width buttons (not full-width)
class JobDetailScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;
    final radiiTokens = Theme.of(context).extension<RadiiTokens>()!;
    final typographyTokens = Theme.of(context).extension<TypographyTokens>()!;
    final elevationTokens = Theme.of(context).extension<ElevationTokens>()!;

    // Fetch job by ID
    final jobsAsync = ref.watch(jobsListProvider);

    return Scaffold(
      backgroundColor: colorTokens.neutral50, // Token: colors.neutral.50
      body: jobsAsync.when(
        data: (jobs) {
          // Find job by ID
          final job = jobs.firstWhere(
            (j) => j.id == jobId,
            orElse: () => JobOpening(
              id: '',
              title: 'Job Not Found',
              department: '',
              description: '',
              responsibilities: [],
              requirements: [],
              preferredQualifications: [],
              location: '',
              employmentType: '',
              salaryRange: '',
              postedDate: DateTime.now(),
              closingDate: DateTime.now(),
              applicantsCount: 0,
              isActive: false,
            ),
          );

          if (job.id.isEmpty) {
            return Column(
              children: [
                TopNavigationBar(onLogoTap: () => context.go('/')),
                Expanded(
                  child: _buildNotFound(
                    context,
                    colorTokens,
                    spacingTokens,
                    typographyTokens,
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              TopNavigationBar(onLogoTap: () => context.go('/')),
              // Gradient Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: spacingTokens.spacing4,
                  vertical: spacingTokens.spacing6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorTokens.primary500.withOpacity(0.12),
                      colorTokens.secondary500.withOpacity(0.10),
                      colorTokens.neutral0.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: typographyTokens.h1Desktop.copyWith(
                        color: colorTokens.neutral900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacingTokens.spacing1),
                    Text(
                      job.department,
                      style: typographyTokens.h4.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: spacingTokens.spacing3),
                    ChipGroup(
                      chips: [
                        AppChip.standard(
                          label: job.employmentType,
                          context: context,
                        ),
                        AppChip.standard(
                          label: job.location,
                          icon: Icons.location_on_outlined,
                          context: context,
                        ),
                        AppChip.info(
                          label: '${job.applicantsCount} candidates',
                          context: context,
                        ),
                      ],
                    ),
                    SizedBox(height: spacingTokens.spacing3),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 20,
                          color: colorTokens.neutral500,
                        ),
                        SizedBox(width: spacingTokens.spacing1),
                        Text(
                          job.salaryRange,
                          style: typographyTokens.h4.copyWith(
                            color: colorTokens.neutral900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacingTokens.spacing1),
                    Text(
                      'Posted ${DateFormat('MMM dd, yyyy').format(job.postedDate)}',
                      style: typographyTokens.bodyMedium.copyWith(
                        color: colorTokens.neutral500,
                      ),
                    ),
                    SizedBox(height: spacingTokens.spacing4),
                    SizedBox(
                      width: 240,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/jobs/$jobId/apply');
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 48),
                          padding: EdgeInsets.symmetric(
                            horizontal: spacingTokens.spacing3,
                            vertical: spacingTokens.spacing2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.work_outline, size: 20),
                            SizedBox(width: spacingTokens.spacing1),
                            const Text('Apply Now'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content Section
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(spacingTokens.spacing4),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(
                            context,
                            title: 'About This Role',
                            content: job.description,
                            colorTokens: colorTokens,
                            spacingTokens: spacingTokens,
                            radiiTokens: radiiTokens,
                            typographyTokens: typographyTokens,
                            elevationTokens: elevationTokens,
                          ),
                          SizedBox(height: spacingTokens.spacing3),
                          if (job.requirements.isNotEmpty)
                            _buildSection(
                              context,
                              title: 'Requirements',
                              content: job.requirements
                                  .map((r) => '• $r')
                                  .join('\n'),
                              colorTokens: colorTokens,
                              spacingTokens: spacingTokens,
                              radiiTokens: radiiTokens,
                              typographyTokens: typographyTokens,
                              elevationTokens: elevationTokens,
                            ),
                          SizedBox(height: spacingTokens.spacing6),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => Column(
          children: [
            TopNavigationBar(onLogoTap: () => context.go('/')),
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        error: (error, stack) => Column(
          children: [
            TopNavigationBar(onLogoTap: () => context.go('/')),
            Expanded(
              child: _buildNotFound(
                context,
                colorTokens,
                spacingTokens,
                typographyTokens,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    required ColorTokens colorTokens,
    required SpacingTokens spacingTokens,
    required RadiiTokens radiiTokens,
    required TypographyTokens typographyTokens,
    required ElevationTokens elevationTokens,
  }) {
    return Card(
      elevation: elevationTokens.level2,
      shape: RoundedRectangleBorder(borderRadius: radiiTokens.borderLg),
      child: Padding(
        padding: EdgeInsets.all(spacingTokens.spacing3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: typographyTokens.h3.copyWith(
                color: colorTokens.neutral900,
              ),
            ),
            SizedBox(height: spacingTokens.spacing2),
            Text(
              content,
              style: typographyTokens.bodyLarge.copyWith(
                color: colorTokens.neutral700,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFound(
    BuildContext context,
    ColorTokens colorTokens,
    SpacingTokens spacingTokens,
    TypographyTokens typographyTokens,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacingTokens.spacing4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off_outlined,
              size: 64,
              color: colorTokens.neutral300,
            ),
            SizedBox(height: spacingTokens.spacing3),
            Text(
              'Job Not Found',
              style: typographyTokens.h2.copyWith(
                color: colorTokens.neutral700,
              ),
            ),
            SizedBox(height: spacingTokens.spacing1),
            Text(
              'This job posting may have been removed or is no longer available.',
              style: typographyTokens.bodyMedium.copyWith(
                color: colorTokens.neutral500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacingTokens.spacing3),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to Jobs'),
            ),
          ],
        ),
      ),
    );
  }
}
