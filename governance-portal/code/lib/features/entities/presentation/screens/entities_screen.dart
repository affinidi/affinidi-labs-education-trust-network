import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/widgets/app_header.dart';
import 'package:governance_portal/core/widgets/app_modal.dart';
import 'package:governance_portal/features/entities/data/entities_provider.dart';
import 'package:governance_portal/features/entities/presentation/screens/entity_form_screen.dart';
import 'package:governance_portal/features/entities/presentation/widgets/entity_form_widget.dart';
import 'package:governance_portal/features/entities/presentation/widgets/entities_table.dart';
import '../../domain/entities/entity.dart';

class EntitiesScreen extends ConsumerStatefulWidget {
  const EntitiesScreen({super.key});

  @override
  ConsumerState<EntitiesScreen> createState() => _EntitiesScreenState();
}

class _EntitiesScreenState extends ConsumerState<EntitiesScreen> {
  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  Future<void> _loadEntities() async {
    final storage = await ref.read(entitiesStorageProvider.future);
    final entities = storage.getEntities();
    if (mounted) {
      ref.read(entitiesListProvider.notifier).state = entities;
    }
  }

  Future<void> _handleCreateEntity(Map<String, dynamic> entityData) async {
    final storage = ref.read(entitiesStorageProvider).valueOrNull;
    if (storage == null) return;

    final entity = Entity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: entityData['name'] as String,
      did: entityData['did'] as String,
      createdAt: DateTime.now(),
    );

    await storage.addEntity(entity);
    await _loadEntities();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Entity "${entityData['name']}" created'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final entities = ref.watch(entitiesListProvider);

    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'Entities',
            searchPlaceholder: 'Search Entities',
            showNotifications: true,
            showCreateButton: true,
            createButtonLabel: 'Create Entity',
            onCreatePressed: () async {
              final result = await showAppModal<Map<String, dynamic>>(
                context: context,
                title: 'Create Entity',
                body: const EntityFormScreen(isModal: true),
              );

              if (result != null) {
                await _handleCreateEntity(result);
              }
            },
          ),
          Expanded(
            child: entities.isEmpty
                ? _buildEmptyState()
                : _buildEntityList(entities),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              size: 80,
              color: AppColors.neutral300,
            ),
            const SizedBox(height: AppSpacing.spacing4),
            Text(
              'No Entities Yet',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.neutral500,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Create your first entity to manage organizations, universities, or verifiers in the trust registry.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.neutral400,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spacing4),
            EntityFormWidget(
              onSubmit: _handleCreateEntity,
              showCancelButton: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntityList(List<Entity> entities) {
    return EntitiesTable(
      entities: entities,
      onEdit: (id, data) async {
        final storage = ref.read(entitiesStorageProvider).valueOrNull;
        if (storage != null) {
          final updatedEntity = Entity(
            id: id,
            name: data['name'] as String,
            did: data['did'] as String,
            description: data['description'] as String?,
            context: data['context'] as Map<String, dynamic>?,
            createdAt: entities.firstWhere((e) => e.id == id).createdAt,
            updatedAt: DateTime.now(),
          );

          await storage.updateEntity(id, updatedEntity);
          await _loadEntities();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Entity "${data['name']}" updated'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      },
    );
  }
}
