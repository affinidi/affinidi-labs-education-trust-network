import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:governance_portal/core/config/framework_templates.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/design_system/app_typography.dart';
import 'package:governance_portal/core/storage/settings_provider.dart';
import 'package:governance_portal/features/authorities/data/authorities_provider.dart';
import 'package:governance_portal/features/authorities/domain/entities/authority.dart';
import 'package:governance_portal/features/authorities/presentation/widgets/authority_form_widget.dart';
import 'package:governance_portal/features/entities/data/entities_provider.dart';
import 'package:governance_portal/features/entities/domain/entities/entity.dart';
import 'package:governance_portal/features/welcome/presentation/widgets/action_selector.dart';
import 'package:governance_portal/features/welcome/presentation/widgets/resource_selector.dart';
import 'package:governance_portal/features/welcome/presentation/widgets/record_type_selector.dart';
import 'package:governance_portal/features/entities/presentation/widgets/entity_form_widget.dart';
import 'package:governance_portal/features/welcome/presentation/widgets/data_cards.dart';

/// Authority setup screen with tab-based form interface
class AuthoritySetupScreen extends ConsumerStatefulWidget {
  final TrustFrameworkTemplate? selectedFramework;

  const AuthoritySetupScreen({
    super.key,
    this.selectedFramework,
  });

  @override
  ConsumerState<AuthoritySetupScreen> createState() =>
      _AuthoritySetupScreenState();
}

class _AuthoritySetupScreenState extends ConsumerState<AuthoritySetupScreen> {
  int _selectedTabIndex = 0;
  String? _selectedRecordType;
  String? _selectedAction;
  String? _selectedResource;

  @override
  Widget build(BuildContext context) {
    final registryName = ref.watch(registryNameProvider);
    final authorities = ref.watch(authoritiesListProvider);
    final entities = ref.watch(entitiesListProvider);

    // Calculate completion status
    final authorityComplete = authorities.isNotEmpty;
    final typeComplete = _selectedRecordType != null;
    final entityComplete = entities.isNotEmpty;
    final recordComplete = _selectedAction != null && _selectedResource != null;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.navBackground,
        ),
        child: Stack(
          children: [
            // Background gradient circles (same as onboarding)
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 800,
                  height: 800,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentPink.withOpacity(0.2),
                        AppColors.accentPink.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -200,
              left: -1000,
              right: 1,
              child: Center(
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentBlue.withOpacity(0.3),
                        AppColors.accentBlue.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Scrollable content
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: const EdgeInsets.all(AppSpacing.spacing6),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.spacing8),

                      // Title
                      Text(
                        'Create Your Trust Registry',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppColors.navText,
                                  fontSize: 32,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.spacing6),

                      // Registry name display
                      _buildInfoCard(
                        label: 'Name',
                        value: registryName ?? 'Unnamed Registry',
                        onEdit: () => context.pop(),
                      ),
                      const SizedBox(height: AppSpacing.spacing4),

                      // Framework display
                      _buildInfoCard(
                        label: 'Trust Framework',
                        value:
                            widget.selectedFramework?.name ?? 'None selected',
                        onEdit: () => context.pop(),
                      ),
                      const SizedBox(height: AppSpacing.spacing8),

                      // Tab menu
                      _buildTabMenu(
                        authorityComplete: authorityComplete,
                        typeComplete: typeComplete,
                        entityComplete: entityComplete,
                        recordComplete: recordComplete,
                      ),
                      const SizedBox(height: AppSpacing.spacing4),

                      // White container with form
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.spacing6),
                        decoration: BoxDecoration(
                          color: AppColors.navText,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                        child: _buildTabContent(
                          authorityComplete: authorityComplete,
                          entityComplete: entities.isNotEmpty,
                        ),
                      ),

                      // Complete Setup button (below white container)
                      if (typeComplete && recordComplete) ...[
                        const SizedBox(height: AppSpacing.spacing6),
                        SizedBox(
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.accentBlueDark,
                                  AppColors.accentPurpleDark,
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                context.go('/records');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.spacing4,
                                ),
                                textStyle:
                                    Theme.of(context).textTheme.titleLarge,
                              ),
                              child: const Text('Complete Setup'),
                            ),
                          ),
                        ),
                      ],

                      // Skip for now - always visible
                      const SizedBox(height: AppSpacing.spacing3),
                      Center(
                        child: TextButton(
                          onPressed: () => context.go('/records'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.neutral400,
                            textStyle: Theme.of(context).textTheme.titleLarge,
                          ),
                          child: const Text('Skip for now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Toggle navigation button (bottom right)
            Positioned(
              bottom: AppSpacing.spacing6,
              right: AppSpacing.spacing6,
              child: _buildToggleButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.navText.withOpacity(0.5),
                            fontSize: AppTypography.fontSizeMd,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.spacing1),
                    Text(
                      value,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.navText,
                              ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 20),
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.navText.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Container(
            height: 2,
            color: AppColors.navText.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildTabMenu({
    required bool authorityComplete,
    required bool typeComplete,
    required bool entityComplete,
    required bool recordComplete,
  }) {
    final tabs = [
      _TabInfo(
        index: 0,
        name: 'Record',
        icon: Icons.description,
        color: AppColors.semanticWarning,
        isComplete: recordComplete,
      ),
      _TabInfo(
        index: 1,
        name: 'Type',
        icon: Icons.category,
        color: AppColors.accentPurple,
        isComplete: typeComplete,
      ),
      _TabInfo(
        index: 2,
        name: 'Authority',
        icon: Icons.shield,
        color: AppColors.accentBlue,
        isComplete: authorityComplete,
      ),
      _TabInfo(
        index: 3,
        name: 'Entity',
        icon: Icons.business,
        color: AppColors.semanticSuccess,
        isComplete: entityComplete,
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: tabs.map((tab) => _buildTab(tab)).toList(),
    );
  }

  Widget _buildTab(_TabInfo tab) {
    final isSelected = _selectedTabIndex == tab.index;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedTabIndex = tab.index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing1),
            padding: const EdgeInsets.all(AppSpacing.spacing2),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.navText.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                // Icon circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tab.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    tab.icon,
                    color: AppColors.navText,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing3),

                // Text column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        tab.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.navText,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.spacing0),

                      // Status
                      Text(
                        tab.isComplete ? 'Completed' : 'Incomplete',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: tab.isComplete
                                  ? AppColors.semanticSuccess
                                  : AppColors.neutral400,
                              fontSize: AppTypography.fontSizeMd,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent({
    required bool authorityComplete,
    required bool entityComplete,
  }) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildRecordTab();
      case 1:
        return _buildTypeTab();
      case 2:
        return _buildAuthorityTab(authorityComplete);
      case 3:
        return _buildEntityTab(entityComplete);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAuthorityTab(bool authorityComplete) {
    final authorities = ref.watch(authoritiesListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Authority',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.neutral500,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing1),
        Text(
          'Define who can issue and verify credentials',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.neutral400,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing6),

        // Display existing authorities with edit/delete options
        if (authorities.isNotEmpty) ...[
          ...authorities.map((authority) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.spacing3),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.spacing3),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.neutral200),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AuthorityCard(authority: authority),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // TODO: Implement edit functionality
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: AppColors.semanticError,
                        onPressed: () async {
                          final storage =
                              await ref.read(authoritiesStorageProvider.future);
                          await storage.deleteAuthority(authority.id);
                          ref.invalidate(authoritiesListProvider);
                        },
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: AppSpacing.spacing4),
        ],

        // Always show form to add another authority
        Text(
          authorities.isEmpty ? 'Create Authority' : 'Add Another Authority',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.neutral500,
                fontWeight: AppTypography.fontWeightBold,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing3),
        AuthorityFormWidget(
          onSaved: () {
            setState(() {});
          },
          onSubmit: (authorityData) async {
            final storage = await ref.read(authoritiesStorageProvider.future);
            final authority = Authority(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: authorityData['name'] as String,
              did: authorityData['did'] as String,
              createdAt: DateTime.now(),
            );
            await storage.addAuthority(authority);
            ref.invalidate(authoritiesListProvider);
          },
          suggestions: widget.selectedFramework?.suggestedAuthorities,
        ),

        // Save and Continue button (only if at least one authority exists)
        if (authorities.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.spacing6),
          Align(
            alignment: Alignment.centerRight,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  AppColors.accentBlue,
                  AppColors.accentPurple,
                ],
              ).createShader(bounds),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedTabIndex = 1; // Move to Type tab
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                  ),
                  child: const Text(
                    'Save and Continue →',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTypeTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Type',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.neutral500,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing1),
        Text(
          'Choose whether this is an authorizing or recognizing record',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.neutral400,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing6),
        RecordTypeSelector(
          selectedRecordType: _selectedRecordType,
          onRecordTypeSelected: (recordType) {
            setState(() {
              _selectedRecordType = recordType;
            });
          },
        ),
        if (_selectedRecordType != null) ...[
          const SizedBox(height: AppSpacing.spacing6),
          Align(
            alignment: Alignment.centerRight,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  AppColors.accentBlue,
                  AppColors.accentPurple,
                ],
              ).createShader(bounds),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedTabIndex = 2; // Move to Entity tab
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                  ),
                  child: const Text(
                    'Save and Continue →',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEntityTab(bool entityComplete) {
    final entities = ref.watch(entitiesListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Entity',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.neutral500,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing1),
        Text(
          'Define the entity for this ${_selectedRecordType ?? 'record'}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.neutral400,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing6),
        if (!entityComplete) ...[
          EntityFormWidget(
            onSaved: () {
              setState(() {});
            },
            onSubmit: (entityData) async {
              final storage = await ref.read(entitiesStorageProvider.future);
              final entity = Entity(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: entityData['name'] as String,
                did: entityData['did'] as String,
                createdAt: DateTime.now(),
              );
              await storage.addEntity(entity);
              ref.invalidate(entitiesListProvider);
            },
            suggestions: widget.selectedFramework?.suggestedEntities,
          ),
        ] else ...[
          ...entities.map((entity) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.spacing4),
                child: EntityCard(entity: entity),
              )),
          const SizedBox(height: AppSpacing.spacing4),
          Align(
            alignment: Alignment.centerRight,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  AppColors.accentBlue,
                  AppColors.accentPurple,
                ],
              ).createShader(bounds),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedTabIndex = 0; // Move to Record tab
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                  ),
                  child: const Text(
                    'Save and Continue →',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRecordTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configure Record',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.neutral500,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing1),
        Text(
          'Define actions and resources for this trust record',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.neutral400,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing6),

        ActionSelector(
          selectedAction: _selectedAction,
          framework: widget.selectedFramework,
          onActionSelected: (action) {
            setState(() {
              _selectedAction = action;
            });
          },
        ),

        if (_selectedAction != null) ...[
          const SizedBox(height: AppSpacing.spacing6),
          ResourceSelector(
            selectedResource: _selectedResource,
            framework: widget.selectedFramework,
            onResourceSelected: (resource) {
              setState(() {
                _selectedResource = resource;
              });
            },
          ),
        ],

        // Save and Continue button (only if both action and resource are selected)
        if (_selectedAction != null && _selectedResource != null) ...[
          const SizedBox(height: AppSpacing.spacing6),
          Align(
            alignment: Alignment.centerRight,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  AppColors.accentBlue,
                  AppColors.accentPurple,
                ],
              ).createShader(bounds),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedTabIndex = 1; // Move to Type tab
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                  ),
                  child: const Text(
                    'Save and Continue →',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildToggleButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pop(),
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.navText.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.keyboard_arrow_up,
            color: AppColors.navText,
            size: 32,
          ),
        ),
      ),
    );
  }
}

class _TabInfo {
  final int index;
  final String name;
  final IconData icon;
  final Color color;
  final bool isComplete;

  _TabInfo({
    required this.index,
    required this.name,
    required this.icon,
    required this.color,
    required this.isComplete,
  });
}
