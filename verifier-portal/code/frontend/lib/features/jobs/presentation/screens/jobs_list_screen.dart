import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens/color_tokens.dart';
import '../../../../core/design_system/tokens/spacing_tokens.dart';
import '../../../../core/design_system/tokens/radii_tokens.dart';
import '../../../../core/design_system/tokens/typography_tokens.dart';
import '../../../../core/design_system/components/top_navigation_bar.dart';
import '../providers/jobs_providers.dart';
import '../widgets/job_card.dart';

class JobsListScreen extends ConsumerWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(filteredJobsProvider);
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;
    final radiiTokens = Theme.of(context).extension<RadiiTokens>()!;
    final typographyTokens = Theme.of(context).extension<TypographyTokens>()!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 640;
    const double maxContentWidth = 1200;
    final contentHorizontalPadding =
        isMobile ? spacingTokens.spacing2 : spacingTokens.spacing4;

    return Scaffold(
      backgroundColor: colorTokens
          .neutral50, // Token: colors.neutral.50 (off-white background)
      body: Column(
        children: [
          // Top Navigation Bar with NovaCorp Logo
          TopNavigationBar(onLogoTap: () => context.go('/jobs')),
          // Scrollable Content
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Hero Section with Gradient Header (improved)
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
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
                    padding: EdgeInsets.symmetric(
                      vertical: spacingTokens.spacing6,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: maxContentWidth,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: contentHorizontalPadding,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Left side: Text content
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Be part of our mission',
                                      style: typographyTokens.h1Desktop.copyWith(
                                        color: colorTokens.neutral900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: spacingTokens.spacing2),
                                    Text(
                                      "We're looking for talented people who want to make a difference. Join us and help shape the future of digital trust and responsibility.",
                                      style: typographyTokens.bodyLarge.copyWith(
                                        color: colorTokens.neutral700,
                                      ),
                                    ),
                                    SizedBox(height: spacingTokens.spacing2),
                                    jobsAsync.maybeWhen(
                                      data: (jobs) => Text(
                                        '${jobs.length} open ${jobs.length == 1 ? 'position' : 'positions'}',
                                        style: typographyTokens.bodyMedium.copyWith(
                                          color: colorTokens.neutral600,
                                        ),
                                      ),
                                      orElse: () => const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: spacingTokens.spacing6),
                              // Right side: Team image
                              Expanded(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: AspectRatio(
                                    aspectRatio: 1.2,
                                    child: Image.asset(
                                      'assets/images/nova-portal.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        // Fallback if image not found
                                        return Container(
                                          color: colorTokens.neutral200,
                                          child: Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: colorTokens.neutral400,
                                              size: 64,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Spacing between header and search
                SliverToBoxAdapter(
                  child: SizedBox(height: spacingTokens.spacing4),
                ),
                // Search Bar Section (full width)
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    color: colorTokens
                        .neutral50, // Match page background (grey)
                    padding: EdgeInsets.only(bottom: spacingTokens.spacing3),
                    child: Align(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: maxContentWidth),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: contentHorizontalPadding,
                          ),
                          child: _buildSearchField(
                            context,
                            ref,
                            colorTokens,
                            spacingTokens,
                            radiiTokens,
                            typographyTokens,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Jobs List Content
                jobsAsync.when(
                  data: (jobs) {
                    if (jobs.isEmpty) {
                      return SliverToBoxAdapter(
                        child: _buildEmptyState(
                          context,
                          colorTokens,
                          typographyTokens,
                          spacingTokens,
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final job = jobs[index];
                        return Align(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: maxContentWidth,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: contentHorizontalPadding,
                                vertical: spacingTokens.spacing3 / 2,
                              ),
                              child: JobCard(
                                job: job,
                                onTap: () => context.go('/jobs/${job.id}'),
                                applyButtonRight:
                                    true, // Custom param for CTA on right
                                titleFontScale: 1.1, // 10% bigger title
                              ),
                            ),
                          ),
                        );
                      }, childCount: jobs.length),
                    );
                  },
                  loading: () => SliverToBoxAdapter(
                    child: _buildLoadingState(
                      context,
                      colorTokens,
                      spacingTokens,
                      typographyTokens,
                    ),
                  ),
                  error: (error, stack) => SliverToBoxAdapter(
                    child: _buildErrorState(
                      context,
                      error,
                      colorTokens,
                      spacingTokens,
                      typographyTokens,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(
    BuildContext context,
    WidgetRef ref,
    ColorTokens colorTokens,
    SpacingTokens spacingTokens,
    RadiiTokens radiiTokens,
    TypographyTokens typographyTokens,
  ) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 1200,
      ), // Constrain search field width for better UX
      child: TextField(
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        style: typographyTokens.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Search by job title, department, or keyword...',
          hintStyle: typographyTokens.bodyMedium.copyWith(
            color: colorTokens.neutral500,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 24, // Token: iconSize.md
            color: colorTokens.neutral500,
          ),
          suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: colorTokens.neutral500),
                  onPressed: () {
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                  tooltip: 'Clear search',
                )
              : null,
          filled: true,
          fillColor: colorTokens.neutral50, // Grey background matching page
          contentPadding: EdgeInsets.symmetric(
            horizontal: spacingTokens.spacing2, // Token: spacing.2 (16px)
            vertical:
                spacingTokens.spacing2, // Increased padding for prominence
          ),
          border: OutlineInputBorder(
            borderRadius: radiiTokens.borderLg, // Token: radius.lg (12px)
            borderSide: BorderSide(color: colorTokens.neutral300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: radiiTokens.borderLg,
            borderSide: BorderSide(color: colorTokens.neutral300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: radiiTokens.borderLg,
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.primary, // Token: colors.primary.500
              width: 2, // Token: borderWidth.medium
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ColorTokens colorTokens,
    TypographyTokens typographyTokens,
    SpacingTokens spacingTokens,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacingTokens.spacing3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, size: 64, color: colorTokens.neutral300),
            SizedBox(height: spacingTokens.spacing3),
            Text(
              'No jobs found',
              style: typographyTokens.h3.copyWith(
                color: colorTokens.neutral700,
              ),
            ),
            SizedBox(height: spacingTokens.spacing1),
            Text(
              'Try adjusting your search filters',
              style: typographyTokens.bodyMedium.copyWith(
                color: colorTokens.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(
    BuildContext context,
    ColorTokens colorTokens,
    SpacingTokens spacingTokens,
    TypographyTokens typographyTokens,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: spacingTokens.spacing2),
          Text(
            'Loading opportunities...',
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
    TypographyTokens typographyTokens,
  ) {
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
}
