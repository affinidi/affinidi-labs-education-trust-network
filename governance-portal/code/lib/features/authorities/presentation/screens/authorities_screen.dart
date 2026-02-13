import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/widgets/app_header.dart';
import 'package:governance_portal/core/widgets/app_modal.dart';
import 'package:governance_portal/features/authorities/presentation/screens/authority_form_screen.dart';
import 'package:governance_portal/features/authorities/presentation/widgets/authority_form_widget.dart';
import 'package:governance_portal/features/authorities/presentation/widgets/authorities_table.dart';
import 'package:governance_portal/features/authorities/data/authorities_provider.dart';
import '../../domain/entities/authority.dart';

class AuthoritiesScreen extends ConsumerWidget {
  const AuthoritiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorities = ref.watch(authoritiesListProvider);

    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'Authorities',
            searchPlaceholder: 'Search Authorities',
            showNotifications: true,
            showCreateButton: true,
            createButtonLabel: 'Create Authority',
            onCreatePressed: () async {
              print('🔵 [AuthoritiesScreen] Create Authority button pressed');
              final result = await showAppModal<Map<String, dynamic>>(
                context: context,
                title: 'Create Authority',
                body: const AuthorityFormScreen(isModal: true),
              );

              print('🔵 [AuthoritiesScreen] Modal returned result: $result');

              if (result != null && context.mounted) {
                print(
                    '🔵 [AuthoritiesScreen] Result is not null and context is mounted');
                final storage =
                    ref.read(authoritiesStorageProvider).valueOrNull;

                print(
                    '🔵 [AuthoritiesScreen] Storage instance: ${storage != null ? "available" : "null"}');

                if (storage != null) {
                  print(
                      '🔵 [AuthoritiesScreen] Creating Authority object with:');
                  print('   - name: ${result['name']}');
                  print('   - did: ${result['did']}');

                  final authority = Authority(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: result['name'] as String,
                    did: result['did'] as String,
                    createdAt: DateTime.now(),
                  );

                  print('🔵 [AuthoritiesScreen] Authority created: $authority');
                  print(
                      '🔵 [AuthoritiesScreen] Adding authority to storage...');

                  await storage.addAuthority(authority);

                  print('🔵 [AuthoritiesScreen] Authority added to storage');

                  // Update the authorities list
                  final updatedList = storage.getAuthorities();
                  print(
                      '🔵 [AuthoritiesScreen] Updated authorities list count: ${updatedList.length}');

                  ref.read(authoritiesListProvider.notifier).state =
                      updatedList;

                  print('🔵 [AuthoritiesScreen] State updated in provider');
                } else {
                  print('🔴 [AuthoritiesScreen] Storage is null!');
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Authority "${result['name']}" created'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                print(
                    '🔴 [AuthoritiesScreen] Result is null or context not mounted');
                print('   - result is null: ${result == null}');
                print('   - context mounted: ${context.mounted}');
              }
            },
          ),
          Expanded(
            child: authorities.isEmpty
                ? _buildEmptyState(context, ref)
                : _buildAuthoritiesList(context, authorities),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(AppSpacing.spacing6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.admin_panel_settings_outlined,
              size: 80,
              color: AppColors.neutral300,
            ),
            const SizedBox(height: AppSpacing.spacing4),
            Text(
              'Create Your First Authority',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.neutral500,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Authorities manage trust registry permissions and credentials. Get started by creating your first authority below.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.neutral400,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spacing6),
            // Show the form inline
            AuthorityFormWidget(
              showCancelButton: false,
              onSubmit: (data) async {
                print(
                    '🟢 [AuthoritiesScreen EmptyState] onSubmit called with data: $data');

                final storage =
                    ref.read(authoritiesStorageProvider).valueOrNull;

                print(
                    '🟢 [AuthoritiesScreen EmptyState] Storage instance: ${storage != null ? "available" : "null"}');

                if (storage != null) {
                  print(
                      '🟢 [AuthoritiesScreen EmptyState] Creating Authority object');

                  final authority = Authority(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: data['name'] as String,
                    did: data['did'] as String,
                    createdAt: DateTime.now(),
                  );

                  print(
                      '🟢 [AuthoritiesScreen EmptyState] Authority created: $authority');
                  print(
                      '🟢 [AuthoritiesScreen EmptyState] Adding to storage...');

                  await storage.addAuthority(authority);

                  print(
                      '🟢 [AuthoritiesScreen EmptyState] Authority added to storage');

                  // Update the authorities list
                  final updatedList = storage.getAuthorities();
                  print(
                      '🟢 [AuthoritiesScreen EmptyState] Updated authorities list count: ${updatedList.length}');

                  ref.read(authoritiesListProvider.notifier).state =
                      updatedList;

                  print(
                      '🟢 [AuthoritiesScreen EmptyState] State updated in provider');

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Authority "${data['name']}" created'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  print('🔴 [AuthoritiesScreen EmptyState] Storage is null!');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthoritiesList(
    BuildContext context,
    List<Authority> authorities,
  ) {
    return Consumer(
      builder: (context, ref, _) {
        return AuthoritiesTable(
          authorities: authorities,
          onEdit: (id, data) async {
            final storage = ref.read(authoritiesStorageProvider).valueOrNull;
            if (storage != null) {
              final updatedAuthority = Authority(
                id: id,
                name: data['name'] as String,
                did: data['did'] as String,
                description: data['description'] as String?,
                context: data['context'] as Map<String, dynamic>?,
                createdAt: authorities.firstWhere((a) => a.id == id).createdAt,
                updatedAt: DateTime.now(),
              );

              await storage.updateAuthority(id, updatedAuthority);

              // Refresh the list
              ref.read(authoritiesListProvider.notifier).state =
                  storage.getAuthorities();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Authority "${data['name']}" updated'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
