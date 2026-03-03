import 'package:flutter/material.dart';
import 'package:governance_portal/core/config/framework_templates.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';

class FrameworkSelection extends StatelessWidget {
  final TrustFrameworkTemplate? selectedFramework;
  final Function(TrustFrameworkTemplate) onFrameworkSelected;

  const FrameworkSelection({
    super.key,
    required this.selectedFramework,
    required this.onFrameworkSelected,
  });

  @override
  Widget build(BuildContext context) {
    final frameworks = [
      FrameworkTemplates.getById('education')!,
      FrameworkTemplates.getById('finance')!,
      FrameworkTemplates.getById('ai_agent')!,
      FrameworkTemplates.getById('custom')!,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Trust Framework',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing2),
        Text(
          'Select a template to get started with suggested configurations',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
        ),
        const SizedBox(height: AppSpacing.spacing4),
        SizedBox(
          height: 240,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: frameworks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final framework = entry.value;
                  final isSelected = selectedFramework?.id == framework.id;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index < frameworks.length - 1
                            ? AppSpacing.spacing3
                            : 0,
                      ),
                      child: InkWell(
                        onTap: () => onFrameworkSelected(framework),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 240,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? null
                                : Colors.white.withOpacity(0.05),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: Colors.white.withOpacity(0.05),
                                    width: 1,
                                  ),
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      AppColors.accentPink,
                                      AppColors.rainbowAmber,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                          ),
                          child: Container(
                            margin: isSelected
                                ? const EdgeInsets.all(6)
                                : EdgeInsets.zero,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? null
                                  : Colors.white.withOpacity(0.01),
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: AppColors.rainbowGradient
                                          .map((c) => c.withOpacity(0.1))
                                          .toList(),
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMd - 6),
                            ),
                            padding: const EdgeInsets.all(AppSpacing.spacing4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  framework.icon,
                                  size: 40,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.8),
                                  shadows: isSelected
                                      ? [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                const SizedBox(height: AppSpacing.spacing2),
                                Text(
                                  framework.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w600,
                                        shadows: isSelected
                                            ? [
                                                Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.spacing1),
                                Text(
                                  framework.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.9)
                                            : Colors.white.withOpacity(0.6),
                                        shadows: isSelected
                                            ? [
                                                Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
