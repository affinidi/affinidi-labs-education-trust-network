import 'package:flutter/material.dart';
import 'package:governance_portal/features/records/domain/repositories/records_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/widgets/destructive_button.dart';
import 'package:governance_portal/core/widgets/did_autocomplete_field.dart';
import '../../../../core/widgets/primary_cta_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/hooks/af_value_notifier.dart';
import '../../domain/entities/trust_record.dart';
import '../../domain/usecases/create_record_usecase.dart';
import '../../domain/usecases/update_record_usecase.dart';
import '../../domain/usecases/delete_record_usecase.dart';
import '../../../entities/data/entities_storage.dart';
import '../../../authorities/data/authorities_storage.dart';
import '../widgets/record_form.dart';

class RecordFormScreen extends HookConsumerWidget {
  final TrustRecord? record;
  final bool isModal;
  final VoidCallback? onSaved;
  final RecordsRepository repository;

  const RecordFormScreen({
    super.key,
    this.record,
    this.isModal = false,
    this.onSaved,
    required this.repository,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final entityIdController =
        useTextEditingController(text: record?.entityId ?? '');
    final authorityIdController =
        useTextEditingController(text: record?.authorityId ?? '');
    final actionController =
        useTextEditingController(text: record?.action ?? '');
    final resourceController =
        useTextEditingController(text: record?.resource ?? '');

    // Determine initial status from record
    final initialStatus = useMemoized(() {
      if (record == null) return TrustStatus.recognized;
      if (record!.recognized) return TrustStatus.recognized;
      if (record!.authorized) return TrustStatus.authorized;
      return TrustStatus.recognized;
    }, [record]);

    final statusNotifier = useAfValueNotifier<TrustStatus>(initialStatus);
    final isSubmittingNotifier = useAfValueNotifier<bool>(false);

    // Load entities and authorities from storage
    final entityOptions = useMemoized(() async {
      final storage = await EntitiesStorage.init();
      final entities = storage.getEntities();
      return entities.map((e) => DIDOption(name: e.name, did: e.did)).toList();
    });

    final authorityOptions = useMemoized(() async {
      final storage = await AuthoritiesStorage.init();
      final authorities = storage.getAuthorities();
      return authorities
          .map((a) => DIDOption(name: a.name, did: a.did))
          .toList();
    });

    final entityOptionsFuture = useFuture(entityOptions);
    final authorityOptionsFuture = useFuture(authorityOptions);

    // Get repository and create use cases

    final createUseCase =
        useMemoized(() => CreateRecordUseCase(repository), [repository]);
    final updateUseCase =
        useMemoized(() => UpdateRecordUseCase(repository), [repository]);
    final deleteUseCase =
        useMemoized(() => DeleteRecordUseCase(repository), [repository]);

    Future<void> saveRecord() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      if (isSubmittingNotifier.isDisposed) return;
      isSubmittingNotifier.value = true;

      try {
        final recordData = TrustRecord(
          entityId: entityIdController.text.trim(),
          authorityId: authorityIdController.text.trim(),
          action: actionController.text.trim(),
          resource: resourceController.text.trim(),
          recognized: statusNotifier.value == TrustStatus.recognized,
          authorized: statusNotifier.value == TrustStatus.authorized,
          createdAt: record?.createdAt,
          updatedAt: record?.updatedAt,
        );

        if (record == null) {
          // Create new record
          await createUseCase(recordData);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Record created successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          // Update existing record
          await updateUseCase(recordData);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Record updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }

        // Call callback if provided
        onSaved?.call();

        // Navigate back
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (!isSubmittingNotifier.isDisposed) {
          isSubmittingNotifier.value = false;
        }
      }
    }

    Future<void> deleteRecord() async {
      if (record == null) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Record'),
          content: const Text(
              'Are you sure you want to delete this record? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            DestructiveButton(
              label: 'Delete',
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      if (isSubmittingNotifier.isDisposed) return;
      isSubmittingNotifier.value = true;

      try {
        await deleteUseCase(
          entityId: record!.entityId,
          authorityId: record!.authorityId,
          action: record!.action,
          resource: record!.resource,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Record deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Call callback if provided
        onSaved?.call();

        // Navigate back
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting record: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (!isSubmittingNotifier.isDisposed) {
          isSubmittingNotifier.value = false;
        }
      }
    }

    final isEditing = record != null;

    // Show loading while options are loading
    if (!entityOptionsFuture.hasData || !authorityOptionsFuture.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final entities = entityOptionsFuture.data ?? [];
    final authorities = authorityOptionsFuture.data ?? [];

    // Modal mode - return just form content with footer
    if (isModal) {
      return ValueListenableBuilder<bool>(
        valueListenable: isSubmittingNotifier,
        builder: (context, isSubmitting, _) {
          return ValueListenableBuilder<TrustStatus>(
            valueListenable: statusNotifier,
            builder: (context, status, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RecordForm(
                    formKey: formKey,
                    entityIdController: entityIdController,
                    authorityIdController: authorityIdController,
                    actionController: actionController,
                    resourceController: resourceController,
                    entityOptions: entities,
                    authorityOptions: authorities,
                    status: status,
                    isEditing: isEditing,
                    isSubmitting: isSubmitting,
                    onStatusChanged: (value) => statusNotifier.value = value,
                    onSave: saveRecord,
                    showButton: false,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: AppSpacing.spacing1_5,
                    runSpacing: AppSpacing.spacing1_5,
                    children: [
                      SecondaryButton(
                        label: 'Cancel',
                        onPressed: isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                      ),
                      if (isEditing)
                        SecondaryButton(
                          label: 'Delete',
                          icon: Icons.delete_outline,
                          onPressed: isSubmitting ? null : deleteRecord,
                        ),
                      PrimaryCTAButton(
                        label: isEditing ? 'Update Record' : 'Create Record',
                        icon: isEditing ? Icons.save : Icons.add,
                        onPressed: isSubmitting ? null : saveRecord,
                        isLoading: isSubmitting,
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      );
    }

    // Full-screen mode (fallback)
    return ValueListenableBuilder<bool>(
      valueListenable: isSubmittingNotifier,
      builder: (context, isSubmitting, _) {
        return ValueListenableBuilder<TrustStatus>(
          valueListenable: statusNotifier,
          builder: (context, status, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text(isEditing ? 'Edit Record' : 'Create Record'),
                actions: [
                  if (isEditing)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: isSubmitting ? null : deleteRecord,
                      tooltip: 'Delete',
                    ),
                ],
              ),
              body: RecordForm(
                formKey: formKey,
                entityIdController: entityIdController,
                authorityIdController: authorityIdController,
                actionController: actionController,
                resourceController: resourceController,
                entityOptions: entities,
                authorityOptions: authorities,
                status: status,
                isEditing: isEditing,
                isSubmitting: isSubmitting,
                onStatusChanged: (value) => statusNotifier.value = value,
                onSave: saveRecord,
              ),
            );
          },
        );
      },
    );
  }
}
