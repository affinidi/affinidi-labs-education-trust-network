import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/widgets/app_header.dart';
import 'package:governance_portal/core/storage/settings_provider.dart';
import 'package:governance_portal/core/storage/settings_constants.dart';
import 'package:governance_portal/features/authorities/data/authorities_provider.dart';
import 'package:governance_portal/features/entities/data/entities_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registryName = ref.watch(registryNameProvider);
    final mediatorDid = ref.watch(mediatorDidProvider);
    final storage = ref.watch(settingsStorageProvider).valueOrNull;

    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'Settings',
            searchPlaceholder: 'Search settings...',
            showCreateButton: false,
            showNotifications: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.spacing6),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        context: context,
                        title: 'General',
                        items: [
                          // _buildSettingItem(
                          //   context: context,
                          //   icon: Icons.label_outlined,
                          //   title: 'App Name',
                          //   subtitle: appName,
                          //   onTap: () {
                          //     _showEditAppNameDialog(
                          //         context, ref, storage, appName);
                          //   },
                          // ),
                          _buildSettingItem(
                            context: context,
                            icon: Icons.language,
                            title: 'Language',
                            subtitle: 'English',
                            onTap: () {
                              // TODO: Implement language selection
                            },
                          ),
                          _buildSettingItem(
                            context: context,
                            icon: Icons.palette_outlined,
                            title: 'Theme',
                            subtitle: 'Light mode',
                            onTap: () {
                              // TODO: Implement theme toggle
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.spacing6),
                      _buildSection(
                        context: context,
                        title: 'Trust Registry',
                        items: [
                          _buildSettingItem(
                            context: context,
                            icon: Icons.account_balance_outlined,
                            title: 'Registry Name',
                            subtitle: registryName ?? 'Not set',
                            onTap: () {
                              _showEditRegistryNameDialog(
                                  context, ref, storage, registryName);
                            },
                          ),
                          _buildSettingItem(
                            context: context,
                            icon: Icons.link_outlined,
                            title: 'Mediator',
                            subtitle: _getMediatorLabel(mediatorDid),
                            onTap: () {
                              _showEditMediatorDidDialog(
                                  context, ref, storage, mediatorDid);
                            },
                          ),
                          _buildSettingItem(
                            context: context,
                            icon: Icons.dns_outlined,
                            title: 'Registry Endpoint',
                            subtitle: 'Configure trust registry connection',
                            onTap: () {
                              // TODO: Implement endpoint configuration
                            },
                          ),
                          _buildSettingItem(
                            context: context,
                            icon: Icons.key_outlined,
                            title: 'DID Configuration',
                            subtitle: 'Manage DID and keys',
                            onTap: () {
                              // TODO: Implement DID configuration
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.spacing6),
                      _buildSection(
                        context: context,
                        title: 'Notifications',
                        items: [
                          _buildSettingItem(
                            context: context,
                            icon: Icons.notifications_outlined,
                            title: 'Email Notifications',
                            subtitle: 'Receive updates via email',
                            trailing: Switch(
                              value: true,
                              onChanged: (value) {
                                // TODO: Implement notification toggle
                              },
                            ),
                          ),
                          _buildSettingItem(
                            context: context,
                            icon: Icons.campaign_outlined,
                            title: 'Record Updates',
                            subtitle: 'Get notified about record changes',
                            trailing: Switch(
                              value: false,
                              onChanged: (value) {
                                // TODO: Implement record updates toggle
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.spacing6),
                      _buildSection(
                        context: context,
                        title: 'About',
                        items: [
                          _buildSettingItem(
                            context: context,
                            icon: Icons.info_outline,
                            title: 'Version',
                            subtitle: '1.0.0',
                          ),
                          _buildSettingItem(
                            context: context,
                            icon: Icons.description_outlined,
                            title: 'License',
                            subtitle: 'View license information',
                            onTap: () {
                              // TODO: Show license dialog
                            },
                          ),
                          _buildSettingItem(
                            context: context,
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy Policy',
                            subtitle: 'View privacy policy',
                            onTap: () {
                              // TODO: Show privacy policy
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.spacing6),

                      // Danger Zone
                      _buildSection(
                        context: context,
                        title: 'Danger Zone',
                        items: [
                          _buildSettingItem(
                            context: context,
                            icon: Icons.delete_forever_outlined,
                            title: 'Delete Trust Registry',
                            subtitle: 'Delete all data and start fresh',
                            onTap: () {
                              _showDeleteRegistryDialog(context, ref, storage);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.spacing8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.spacing2,
            bottom: AppSpacing.spacing3,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.neutral500,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.neutral0,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: AppColors.neutral200,
              width: 1,
            ),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                icon,
                color: AppColors.neutral500,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral500,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.neutral500,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: AppColors.neutral400,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showEditMediatorDidDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic storage,
    String currentDid,
  ) {
    // Define mediator options
    final mediatorOptions = {
      'Affinidi APSE1 (Singapore)': 'did:peer:2.Vz6MkaffinidiAPSE1',
      'Affinidi USE1 (US East)': 'did:peer:2.Vz6MkaffinidiUSE1',
      'Affinidi EUW1 (EU West)': 'did:peer:2.Vz6MkaffinidiEUW1',
      'Local Development': 'did:peer:2.Vz6MklocalDev',
      'Custom': '', // Will allow entering custom DID
    };

    String? selectedOption = mediatorOptions.entries
        .firstWhere(
          (entry) => entry.value == currentDid,
          orElse: () => MapEntry('Custom', ''),
        )
        .key;

    final customController = TextEditingController(
      text: selectedOption == 'Custom' ? currentDid : '',
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Select Mediator'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: selectedOption,
                decoration: InputDecoration(
                  labelText: 'Mediator',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                items: mediatorOptions.keys.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue;
                    if (newValue != 'Custom') {
                      customController.clear();
                    }
                  });
                },
              ),
              if (selectedOption == 'Custom') ...[
                const SizedBox(height: AppSpacing.spacing3),
                TextField(
                  controller: customController,
                  decoration: InputDecoration(
                    labelText: 'Custom Mediator DID',
                    hintText: 'did:peer:2.Vz6Mk...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  autofocus: true,
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                customController.dispose();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newDid;

                if (selectedOption == 'Custom') {
                  newDid = customController.text.trim();
                  if (newDid.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a custom DID'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                } else {
                  newDid = mediatorOptions[selectedOption!]!;
                }

                if (storage != null) {
                  await storage.setMediatorDid(newDid);
                  ref.read(mediatorDidProvider.notifier).state = newDid;
                }

                customController.dispose();

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.linkMain,
                foregroundColor: AppColors.neutral0,
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  String _getMediatorLabel(String did) {
    final labels = {
      'did:peer:2.Vz6MkaffinidiAPSE1': 'Affinidi APSE1 (Singapore)',
      'did:peer:2.Vz6MkaffinidiUSE1': 'Affinidi USE1 (US East)',
      'did:peer:2.Vz6MkaffinidiEUW1': 'Affinidi EUW1 (EU West)',
      'did:peer:2.Vz6MklocalDev': 'Local Development',
    };

    return labels[did] ?? 'Custom: $did';
  }

  void _showEditRegistryNameDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic storage,
    String? currentName,
  ) {
    final controller = TextEditingController(text: currentName ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Registry Name'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Registry Name',
            hintText: 'Hong Kong Education Bureau',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
          ),
          autofocus: true,
          onSubmitted: (value) async {
            if (value.isNotEmpty && storage != null) {
              await storage.setRegistryName(value);
              ref.read(registryNameProvider.notifier).state = value;
              if (context.mounted) Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && storage != null) {
                await storage.setRegistryName(newName);
                ref.read(registryNameProvider.notifier).state = newName;
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.linkMain,
              foregroundColor: AppColors.neutral0,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteRegistryDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic storage,
  ) {
    final registryName = ref.read(registryNameProvider);
    final confirmationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.semanticError,
              size: 28,
            ),
            const SizedBox(width: AppSpacing.spacing2),
            const Text('Delete Trust Registry'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action will permanently delete:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.spacing3),
            _buildWarningItem(context, 'Trust registry name and configuration'),
            _buildWarningItem(context, 'All authorities'),
            _buildWarningItem(context, 'All entities'),
            _buildWarningItem(context, 'All application settings'),
            _buildWarningItem(context, 'Stored preferences and data'),
            const SizedBox(height: AppSpacing.spacing4),
            Container(
              padding: const EdgeInsets.all(AppSpacing.spacing3),
              decoration: BoxDecoration(
                color: AppColors.semanticError.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                  color: AppColors.semanticError.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppColors.semanticError,
                  ),
                  const SizedBox(width: AppSpacing.spacing2),
                  Expanded(
                    child: Text(
                      'This cannot be undone',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.semanticError,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacing4),
            Text(
              'Type "${registryName ?? 'the registry name'}" to confirm:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.spacing2),
            TextField(
              controller: confirmationController,
              decoration: InputDecoration(
                hintText: registryName ?? 'Registry name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing3,
                  vertical: AppSpacing.spacing2,
                ),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              confirmationController.dispose();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final confirmedName = confirmationController.text.trim();

              if (confirmedName != registryName) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                        'Registry name does not match. Deletion cancelled.'),
                    backgroundColor: AppColors.semanticError,
                  ),
                );
                confirmationController.dispose();
                Navigator.of(context).pop();
                return;
              }

              if (storage != null) {
                // Clear settings storage
                await storage.clearAll();

                // Clear authorities storage
                final authoritiesStorageAsync =
                    ref.read(authoritiesStorageProvider);
                final authoritiesStorage = authoritiesStorageAsync.valueOrNull;
                if (authoritiesStorage != null) {
                  await authoritiesStorage.clearAuthorities();
                }

                // Clear entities storage
                final entitiesStorageAsync = ref.read(entitiesStorageProvider);
                final entitiesStorage = entitiesStorageAsync.valueOrNull;
                if (entitiesStorage != null) {
                  await entitiesStorage.clearEntities();
                }

                // Reset all providers
                ref.read(appNameProvider.notifier).state = 'Certizen';
                ref.read(mediatorDidProvider.notifier).state =
                    SettingsConstants.defaultMediatorDid;
                ref.read(registryNameProvider.notifier).state = null;
                ref.read(authoritiesListProvider.notifier).state = [];
                ref.read(entitiesListProvider.notifier).state = [];

                confirmationController.dispose();

                if (context.mounted) {
                  Navigator.of(context).pop();

                  // Navigate to welcome screen to start fresh
                  context.go('/');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.semanticError,
              foregroundColor: AppColors.neutral0,
            ),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacing2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.close,
            size: 16,
            color: AppColors.semanticError,
          ),
          const SizedBox(width: AppSpacing.spacing2),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
