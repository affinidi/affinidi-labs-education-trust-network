import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/widgets/accent_purple_button.dart';
import 'package:governance_portal/core/widgets/primary_cta_button.dart';
import 'package:governance_portal/core/widgets/secondary_button.dart';
import 'package:governance_portal/features/entities/domain/entities/entity.dart';

class EntityFormWidget extends StatefulWidget {
  final Future<void> Function(Map<String, dynamic> entity) onSubmit;
  final bool showCancelButton;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  final List<String>? suggestions;
  final Entity? initialEntity;

  const EntityFormWidget({
    super.key,
    required this.onSubmit,
    this.showCancelButton = false,
    this.onCancel,
    this.onSaved,
    this.suggestions,
    this.initialEntity,
  });

  @override
  State<EntityFormWidget> createState() => _EntityFormWidgetState();
}

class _EntityFormWidgetState extends State<EntityFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _didController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _contextController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _didFocusNode;
  late final FocusNode _descriptionFocusNode;
  late final FocusNode _contextFocusNode;

  bool _isSubmitting = false;
  bool _isGeneratingDid = false;

  @override
  void initState() {
    super.initState();
    final entity = widget.initialEntity;
    _nameController = TextEditingController(text: entity?.name ?? '');
    _didController = TextEditingController(text: entity?.did ?? '');
    _descriptionController = TextEditingController();
    _contextController = TextEditingController();

    _nameFocusNode = FocusNode();
    _didFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _contextFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _didController.dispose();
    _descriptionController.dispose();
    _contextController.dispose();

    _nameFocusNode.dispose();
    _didFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _contextFocusNode.dispose();
    super.dispose();
  }

  Map<String, dynamic>? _parseOptionalJsonObject(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final decoded = jsonDecode(trimmed);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry(key.toString(), value));
    }

    throw const FormatException('Context must be a JSON object');
  }

  Future<void> _generateDid() async {
    setState(() {
      _isGeneratingDid = true;
    });

    try {
      // Simulate DID generation (replace with actual DID generation logic)
      await Future.delayed(const Duration(seconds: 1));

      // Generate a placeholder did:peer DID
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final randomPart = timestamp.toRadixString(36);
      final generatedDid = 'did:peer:2.Vz6Mk$randomPart';

      _didController.text = generatedDid;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('DID generated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Move focus to the next field (description)
        _descriptionFocusNode.requestFocus();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating DID: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingDid = false;
        });
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final contextJson = _parseOptionalJsonObject(_contextController.text);

      final entity = {
        if (widget.initialEntity != null) 'id': widget.initialEntity!.id,
        'name': _nameController.text.trim(),
        'did': _didController.text.trim(),
        'description': _descriptionController.text.trim(),
        if (contextJson != null) 'context': contextJson,
      };

      await widget.onSubmit(entity);

      // Call onSaved callback if provided (after entity is saved)
      if (widget.onSaved != null) {
        widget.onSaved!();
      }

      // Don't clear form - let parent control when to clear
      // Form fields will persist to allow review of entered data
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Entity name field
          Text(
            'Entity Name',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.spacing2),
          TextFormField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            decoration: InputDecoration(
              hintText:
                  widget.suggestions != null && widget.suggestions!.isNotEmpty
                      ? widget.suggestions!.first
                      : 'Hong Kong University',
              prefixIcon: const Icon(Icons.business_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              alignLabelWithHint: true,
            ),
            enabled: !_isSubmitting,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _didFocusNode.requestFocus(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Entity name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          // DID field
          Text(
            'DID (Decentralized Identifier)',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.spacing2),
          TextFormField(
            controller: _didController,
            focusNode: _didFocusNode,
            decoration: InputDecoration(
              hintText: 'did:peer:2.Vz6Mk...',
              prefixIcon: const Icon(Icons.fingerprint_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              alignLabelWithHint: true,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_didController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        tooltip: 'Copy DID',
                        onPressed: _isSubmitting || _isGeneratingDid
                            ? null
                            : () {
                                Clipboard.setData(
                                  ClipboardData(text: _didController.text),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('DID copied to clipboard'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                      ),
                    const SizedBox(width: 4),
                    AccentPurpleButton(
                      onPressed: _isSubmitting || _isGeneratingDid
                          ? null
                          : _generateDid,
                      icon: Icons.auto_awesome,
                      label: _isGeneratingDid ? 'Generating...' : 'Generate',
                      isLoading: _isGeneratingDid,
                    ),
                  ],
                ),
              ),
            ),
            enabled: !_isSubmitting && !_isGeneratingDid,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'DID is required';
              }
              if (!value.trim().startsWith('did:')) {
                return 'DID must start with "did:"';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {}); // Rebuild to show/hide copy button
            },
          ),
          const SizedBox(height: AppSpacing.md),
          // Description field
          Text(
            'Entity Description',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.spacing2),
          TextFormField(
            controller: _descriptionController,
            focusNode: _descriptionFocusNode,
            decoration: InputDecoration(
              hintText: 'Short description of what this entity represents',
              prefixIcon: const Icon(Icons.description_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              alignLabelWithHint: true,
            ),
            enabled: !_isSubmitting,
            minLines: 3,
            maxLines: 6,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _contextFocusNode.requestFocus(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Entity description is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          // Context field (optional)
          Text(
            'Additional Context (optional)',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.spacing2),
          TextFormField(
            controller: _contextController,
            decoration: InputDecoration(
              hintText:
                  '{\n  "website": "https://example.org",\n  "country": "HK"\n}',
              prefixIcon: const Icon(Icons.data_object_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              helperText: 'If provided, must be a JSON object.',
              alignLabelWithHint: true,
            ),
            enabled: !_isSubmitting,
            minLines: 4,
            maxLines: 10,
            validator: (value) {
              final trimmed = (value ?? '').trim();
              if (trimmed.isEmpty) return null;
              try {
                _parseOptionalJsonObject(trimmed);
                return null;
              } catch (_) {
                return 'Additional context must be a valid JSON object';
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.spacing1_5,
            runSpacing: AppSpacing.spacing1_5,
            children: [
              if (widget.showCancelButton)
                SecondaryButton(
                  label: 'Cancel',
                  onPressed: _isSubmitting
                      ? null
                      : widget.onCancel ?? () => Navigator.of(context).pop(),
                ),
              PrimaryCTAButton(
                label: widget.initialEntity != null ? 'Save' : 'Create Entity',
                icon: widget.initialEntity != null ? Icons.save : Icons.add,
                onPressed: _isSubmitting ? null : _handleSubmit,
                isLoading: _isSubmitting,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
