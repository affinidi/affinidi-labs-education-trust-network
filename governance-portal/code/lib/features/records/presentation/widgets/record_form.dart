import 'package:flutter/material.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/widgets/primary_cta_button.dart';
import 'package:governance_portal/core/widgets/did_autocomplete_field.dart';

enum TrustStatus {
  recognized,
  authorized,
}

class RecordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController entityIdController;
  final TextEditingController authorityIdController;
  final TextEditingController actionController;
  final TextEditingController resourceController;
  final List<DIDOption> entityOptions;
  final List<DIDOption> authorityOptions;
  final TrustStatus status;
  final bool isEditing;
  final bool isSubmitting;
  final ValueChanged<TrustStatus> onStatusChanged;
  final VoidCallback onSave;
  final bool showButton;

  const RecordForm({
    super.key,
    required this.formKey,
    required this.entityIdController,
    required this.authorityIdController,
    required this.actionController,
    required this.resourceController,
    required this.entityOptions,
    required this.authorityOptions,
    required this.status,
    required this.isEditing,
    required this.isSubmitting,
    required this.onStatusChanged,
    required this.onSave,
    this.showButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Entity ID Field
          DIDAutocompleteField(
            controller: entityIdController,
            options: entityOptions,
            labelText: 'Entity ID',
            hintText: 'did:example:entity123',
            prefixIcon: Icons.person,
            enabled: !isEditing && !isSubmitting,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Entity ID is required';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.md),

          // Authority ID Field
          DIDAutocompleteField(
            controller: authorityIdController,
            options: authorityOptions,
            labelText: 'Authority ID',
            hintText: 'did:example:authority456',
            prefixIcon: Icons.admin_panel_settings,
            enabled: !isEditing && !isSubmitting,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Authority ID is required';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.md),

          // Action Field
          TextFormField(
            controller: actionController,
            decoration: InputDecoration(
              labelText: 'Action',
              hintText: 'issue',
              prefixIcon: const Icon(Icons.arrow_forward),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            enabled: !isEditing && !isSubmitting,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Action is required';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.md),

          // Resource Field
          TextFormField(
            controller: resourceController,
            decoration: InputDecoration(
              labelText: 'Resource',
              hintText: 'credential-type',
              prefixIcon: const Icon(Icons.inventory_2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            enabled: !isEditing && !isSubmitting,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Resource is required';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Trust Status Radio Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trust Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacing0_5),
                  const Text(
                    'Select the trust status for this record',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  RadioListTile<TrustStatus>(
                    title: const Text('Recognized'),
                    subtitle: const Text(
                      'Entity is recognized by the authority',
                    ),
                    value: TrustStatus.recognized,
                    groupValue: status,
                    onChanged: isSubmitting
                        ? null
                        : (value) {
                            if (value != null) onStatusChanged(value);
                          },
                    // secondary: Icon(
                    //   Icons.check_circle,
                    //   color: status == TrustStatus.recognized
                    //       ? Colors.green
                    //       : Colors.grey,
                    // ),
                  ),
                  RadioListTile<TrustStatus>(
                    title: const Text('Authorized'),
                    subtitle: const Text(
                      'Entity is authorized to perform the action',
                    ),
                    value: TrustStatus.authorized,
                    groupValue: status,
                    onChanged: isSubmitting
                        ? null
                        : (value) {
                            if (value != null) onStatusChanged(value);
                          },
                    // secondary: Icon(
                    //   Icons.verified_user,
                    //   color: status == TrustStatus.authorized
                    //       ? Colors.blue
                    //       : Colors.grey,
                    // ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Save Button - only show if showButton is true
          if (showButton)
            PrimaryCTAButton(
              label: isEditing ? 'Update Record' : 'Create Record',
              icon: isEditing ? Icons.save : Icons.add,
              onPressed: isSubmitting ? null : onSave,
              isLoading: isSubmitting,
              fullWidth: true,
            ),

          const SizedBox(height: AppSpacing.md),

          // Info Card
          Card(
            color: Colors.blue[50],
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing1_5),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: AppSpacing.spacing1_5),
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'Note: Entity ID, Authority ID, Action, and Resource cannot be changed after creation.'
                          : 'All fields are required. The combination of Entity ID, Authority ID, Action, and Resource must be unique.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
