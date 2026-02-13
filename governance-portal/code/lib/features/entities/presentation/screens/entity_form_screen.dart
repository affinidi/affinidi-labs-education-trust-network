import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/features/entities/domain/entities/entity.dart';
import 'package:governance_portal/features/entities/presentation/widgets/entity_form_widget.dart';

class EntityFormScreen extends ConsumerWidget {
  final bool isModal;
  final Entity? initialEntity;

  const EntityFormScreen({
    super.key,
    this.isModal = false,
    this.initialEntity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isModal) {
      return EntityFormWidget(
        initialEntity: initialEntity,
        showCancelButton: true,
        onSubmit: (entity) async {
          Navigator.of(context).pop(entity);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Entity')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.modalPadding),
        child: EntityFormWidget(
          initialEntity: initialEntity,
          showCancelButton: true,
          onSubmit: (entity) async {
            Navigator.of(context).pop(entity);
          },
        ),
      ),
    );
  }
}
