import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/components/top_navigation_bar.dart';
import '../../../../core/design_system/tokens/color_tokens.dart';
import '../../../../core/design_system/tokens/spacing_tokens.dart';
import '../../../../core/design_system/tokens/radii_tokens.dart';
import '../../../../core/design_system/tokens/typography_tokens.dart';
import '../../../../core/design_system/tokens/elevation_tokens.dart';
import '../providers/jobs_providers.dart';

class JobDetailsScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailsScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsync = ref.watch(selectedJobProvider(jobId));
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;

    return Scaffold(
      body: jobAsync.when(
        data: (job) {
          return Column(
            children: [
              // Top Navigation Bar
              TopNavigationBar(onLogoTap: () => context.go('/jobs')),
              // Job Details Content - 2 Column Layout
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(spacingTokens.spacing3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(context, job),
                      SizedBox(height: spacingTokens.spacing4),
                      // Responsive 2-Column Layout
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isDesktop = constraints.maxWidth > 900;
                          if (isDesktop) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Column: Content Sections
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSection(
                                        context,
                                        'About the Role',
                                        job.description,
                                      ),
                                      SizedBox(height: spacingTokens.spacing3),
                                      _buildListSection(
                                        context,
                                        'Responsibilities',
                                        job.responsibilities,
                                      ),
                                      SizedBox(width: spacingTokens.spacing4),
                                      // Right Column: Meta Info
                                      Expanded(
                                        flex: 1,
                                        child: _buildSidebarMetaCard(
                                          context,
                                          job,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: spacingTokens.spacing4),
                                // Right Column: Meta Info
                                Expanded(
                                  flex: 1,
                                  child: _buildSidebarMetaCard(context, job),
                                ),
                              ],
                            );
                          } else {
                            // Mobile: Single Column
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSection(
                                  context,
                                  'About the Role',
                                  job.description,
                                ),
                                SizedBox(height: spacingTokens.spacing3),
                                _buildListSection(
                                  context,
                                  'Responsibilities',
                                  job.responsibilities,
                                ),
                                SizedBox(height: spacingTokens.spacing3),
                                _buildListSection(
                                  context,
                                  'Requirements',
                                  job.requirements,
                                ),
                                SizedBox(height: spacingTokens.spacing3),
                                _buildListSection(
                                  context,
                                  'Preferred Qualifications',
                                  job.preferredQualifications,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => _buildLoadingState(context, colorTokens, spacingTokens),
        error: (error, stack) =>
            _buildErrorState(context, error, colorTokens, spacingTokens),
      ),
      bottomNavigationBar: jobAsync.maybeWhen(
        data: (job) => _buildBottomBar(context, job),
        orElse: () => null,
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, job) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;
    final radiiTokens = Theme.of(context).extension<RadiiTokens>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gradient header with job title and department
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: spacingTokens.spacing3,
            vertical: spacingTokens.spacing5,
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
            borderRadius: radiiTokens.borderMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                style: Theme.of(context)
                    .extension<TypographyTokens>()!
                    .h1Desktop
                    .copyWith(
                      color: colorTokens.neutral900,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: spacingTokens.spacing1),
              Text(
                job.department,
                style: Theme.of(context)
                    .extension<TypographyTokens>()!
                    .h4
                    .copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;
    final typographyTokens = Theme.of(context).extension<TypographyTokens>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: typographyTokens.h3.copyWith(color: colorTokens.neutral900),
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
    );
  }

  Widget _buildListSection(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;
    final typographyTokens = Theme.of(context).extension<TypographyTokens>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: typographyTokens.h3.copyWith(color: colorTokens.neutral900),
        ),
        SizedBox(height: spacingTokens.spacing2),
        ...items.map(
          (item) => Padding(
            padding: EdgeInsets.only(
              bottom: spacingTokens.spacing1 + spacingTokens.spacing2 / 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•',
                  style: typographyTokens.bodyLarge.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: spacingTokens.spacing1 + spacingTokens.spacing2 / 2,
                ),
                Expanded(
                  child: Text(
                    item,
                    style: typographyTokens.bodyLarge.copyWith(
                      color: colorTokens.neutral700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(
    BuildContext context,
    ColorTokens colorTokens,
    SpacingTokens spacingTokens,
  ) {
    final typographyTokens = Theme.of(context).extension<TypographyTokens>()!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: spacingTokens.spacing2),
          Text(
            'Loading job details...',
            style: typographyTokens.bodyMedium.copyWith(
              color: colorTokens.neutral500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    Object error,
    ColorTokens colorTokens,
    SpacingTokens spacingTokens,
  ) {
    final typographyTokens = Theme.of(context).extension<TypographyTokens>()!;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacingTokens.spacing3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorTokens.failedMain),
            SizedBox(height: spacingTokens.spacing3),
            Text(
              'Something went wrong',
              style: typographyTokens.h3.copyWith(
                color: colorTokens.neutral700,
              ),
            ),
            SizedBox(height: spacingTokens.spacing1),
            Text(
              error.toString(),
              style: typographyTokens.bodyMedium.copyWith(
                color: colorTokens.neutral500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarMetaCard(BuildContext context, dynamic job) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;
    final typographyTokens = Theme.of(context).extension<TypographyTokens>()!;
    final radiiTokens = Theme.of(context).extension<RadiiTokens>()!;
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      decoration: BoxDecoration(
        color: colorTokens.neutral50,
        border: Border.all(color: colorTokens.neutral200, width: 1),
        borderRadius: radiiTokens.borderMd,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(spacingTokens.spacing3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salary Range Section
          Text(
            'Salary Range',
            style: typographyTokens.labelMedium.copyWith(
              color: colorTokens.neutral600,
            ),
          ),
          SizedBox(height: spacingTokens.spacing1),
          Text(
            job.salaryRange,
            style: typographyTokens.h3.copyWith(color: colorTokens.neutral900),
          ),
          SizedBox(height: spacingTokens.spacing3),
          Divider(color: colorTokens.neutral200, height: 1),
          SizedBox(height: spacingTokens.spacing3),
          // Posted Date Section
          Text(
            'Posted Date',
            style: typographyTokens.labelMedium.copyWith(
              color: colorTokens.neutral600,
            ),
          ),
          SizedBox(height: spacingTokens.spacing1),
          Text(
            dateFormat.format(job.postedDate),
            style: typographyTokens.bodyMedium.copyWith(
              color: colorTokens.neutral900,
            ),
          ),
          SizedBox(height: spacingTokens.spacing3),
          Divider(color: colorTokens.neutral200, height: 1),
          SizedBox(height: spacingTokens.spacing3),
          // Employment Type Section
          Text(
            'Employment Type',
            style: typographyTokens.labelMedium.copyWith(
              color: colorTokens.neutral600,
            ),
          ),
          SizedBox(height: spacingTokens.spacing1),
          Text(
            job.employmentType,
            style: typographyTokens.bodyMedium.copyWith(
              color: colorTokens.neutral900,
            ),
          ),
          SizedBox(height: spacingTokens.spacing3),
          Divider(color: colorTokens.neutral200, height: 1),
          SizedBox(height: spacingTokens.spacing3),
          // Location Section
          Text(
            'Location',
            style: typographyTokens.labelMedium.copyWith(
              color: colorTokens.neutral600,
            ),
          ),
          SizedBox(height: spacingTokens.spacing1),
          Text(
            job.location,
            style: typographyTokens.bodyMedium.copyWith(
              color: colorTokens.neutral900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, job) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktopWidth = screenWidth >= 1024;
    const double maxContentWidth = 1200;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorTokens.neutral200, width: 1),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktopWidth
                    ? spacingTokens.spacing4
                    : spacingTokens.spacing3,
                vertical: spacingTokens.spacing2,
              ),
              child: Text(
                'Apply for this Job',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
