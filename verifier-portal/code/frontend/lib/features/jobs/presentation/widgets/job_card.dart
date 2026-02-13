import 'package:flutter/material.dart';
import '../../domain/entities/job_opening.dart';
import '../../../../core/design_system/tokens/color_tokens.dart';
import '../../../../core/design_system/tokens/spacing_tokens.dart';
import '../../../../core/design_system/tokens/radii_tokens.dart';
import '../../../../core/design_system/tokens/typography_tokens.dart';
import '../../../../core/design_system/tokens/elevation_tokens.dart';
import '../../../../core/design_system/components/app_chip.dart';
import 'package:intl/intl.dart';

class JobCard extends StatelessWidget {
  final JobOpening job;
  final VoidCallback onTap;
  final bool applyButtonRight;
  final double titleFontScale;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
    this.applyButtonRight = false,
    this.titleFontScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorTokens = Theme.of(context).extension<ColorTokens>()!;
    final spacingTokens = Theme.of(context).extension<SpacingTokens>()!;
    final radiiTokens = Theme.of(context).extension<RadiiTokens>()!;
    final typographyTokens = Theme.of(context).extension<TypographyTokens>()!;
    final elevationTokens = Theme.of(context).extension<ElevationTokens>()!;
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: EdgeInsets.zero,
      elevation: elevationTokens.level2,
      shape: RoundedRectangleBorder(borderRadius: radiiTokens.borderMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: radiiTokens.borderMd,
        hoverColor: colorTokens.primary50.withOpacity(0.5),
        child: Padding(
          padding: EdgeInsets.all(spacingTokens.spacing3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title + Department + Apply CTA (right)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Department
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: typographyTokens.h4.copyWith(
                            color: colorTokens.neutral900,
                            fontSize:
                                typographyTokens.h4.fontSize! * titleFontScale,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: spacingTokens.spacing1 / 2),
                        Text(
                          job.department,
                          style: typographyTokens.labelMedium.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (applyButtonRight)
                    Padding(
                      padding: EdgeInsets.only(left: spacingTokens.spacing3),
                      child: SizedBox(
                        height: 44, // Token: touchTarget.minimum
                        child: ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 44),
                            padding: EdgeInsets.symmetric(
                              horizontal: spacingTokens.spacing3,
                              vertical: spacingTokens.spacing1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: radiiTokens.borderMd,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_forward, size: 20),
                              SizedBox(width: spacingTokens.spacing1),
                              Text('Apply'),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: spacingTokens.spacing2),
              // Horizontal Pill Row: Employment Type, Location, Candidate Count
              ChipGroup(
                chips: [
                  AppChip.standard(label: job.employmentType, context: context),
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
              SizedBox(height: spacingTokens.spacing2),
              // Salary Range
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 18,
                    color: colorTokens.neutral500,
                  ),
                  SizedBox(width: spacingTokens.spacing1),
                  Text(
                    job.salaryRange,
                    style: typographyTokens.bodyMedium.copyWith(
                      color: colorTokens.neutral700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacingTokens.spacing2),
              // Description Preview
              Text(
                job.description.split('\n\n').first,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: typographyTokens.bodyMedium.copyWith(
                  color: colorTokens.neutral600,
                ),
              ),
              SizedBox(height: spacingTokens.spacing2),
              // Footer: Posted Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posted ${dateFormat.format(job.postedDate)}',
                    style: typographyTokens.bodySmall.copyWith(
                      color: colorTokens.neutral500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
