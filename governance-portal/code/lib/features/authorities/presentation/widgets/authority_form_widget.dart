import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/widgets/accent_purple_button.dart';
import 'package:governance_portal/core/widgets/primary_cta_button.dart';
import 'package:governance_portal/core/widgets/secondary_button.dart';
import 'package:governance_portal/features/authorities/domain/entities/authority.dart';

/// Self-contained authority form widget with all logic
/// Can be used in modal or inline contexts
class AuthorityFormWidget extends StatefulWidget {
  final bool showCancelButton;
  final VoidCallback? onCancel;
  final Function(Map<String, dynamic> authorityData)? onSubmit;
  final VoidCallback? onSaved;
  final List<String>? suggestions;
  final Authority? initialAuthority;

  const AuthorityFormWidget({
    super.key,
    this.showCancelButton = true,
    this.onCancel,
    this.onSubmit,
    this.onSaved,
    this.suggestions,
    this.initialAuthority,
  });

  @override
  State<AuthorityFormWidget> createState() => _AuthorityFormWidgetState();
}

class _AuthorityFormWidgetState extends State<AuthorityFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _didController;
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
    final authority = widget.initialAuthority;
    _nameController = TextEditingController(text: authority?.name ?? '');
    _descriptionController =
        TextEditingController(text: authority?.description ?? '');
    _didController = TextEditingController(text: authority?.did ?? '');
    _contextController = TextEditingController(
      text: authority?.context != null
          ? const JsonEncoder.withIndent('  ').convert(authority!.context)
          : '',
    );

    _nameFocusNode = FocusNode();
    _didFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _contextFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _didController.dispose();
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

      final authorityData = <String, dynamic>{
        if (widget.initialAuthority != null) 'id': widget.initialAuthority!.id,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'did': _didController.text.trim(),
        'context': contextJson,
      };

      if (widget.onSubmit != null) {
        widget.onSubmit!(authorityData);
      }

      // Call onSaved callback if provided
      if (widget.onSaved != null) {
        widget.onSaved!();
      }
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Authority name field
              Text(
                'Authority Name',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.spacing2),
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(
                  hintText: widget.suggestions != null &&
                          widget.suggestions!.isNotEmpty
                      ? widget.suggestions!.first
                      : 'Hong Kong Education Bureau',
                  prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
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
                    return 'Authority name is required';
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
                                        content:
                                            Text('DID copied to clipboard'),
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
                          label:
                              _isGeneratingDid ? 'Generating...' : 'Generate',
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
              const SizedBox(height: AppSpacing.spacing2),
              // Collapsible DID info panel
              _DidInfoPanel(),
              const SizedBox(height: AppSpacing.md),
              // Authority description field
              Text(
                'Authority Description',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.spacing2),
              TextFormField(
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                decoration: InputDecoration(
                  hintText:
                      'Short description of what this authority represents',
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
                    return 'Authority description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // Additional context field
              Text(
                'Additional Context (optional)',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.spacing2),
              TextFormField(
                controller: _contextController,
                decoration: InputDecoration(
                  hintText:
                      '{\n  "website": "https://example.org",\n  "contact": "admin@example.org"\n}',
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
            ],
          ),
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
                    : () {
                        if (widget.onCancel != null) {
                          widget.onCancel!();
                        }
                      },
              ),
            PrimaryCTAButton(
              label:
                  widget.initialAuthority != null ? 'Save' : 'Create Authority',
              icon: widget.initialAuthority != null ? Icons.save : Icons.add,
              onPressed: _isSubmitting ? null : _handleSubmit,
              isLoading: _isSubmitting,
            ),
          ],
        ),
      ],
    );
  }
}

/// Collapsible info panel for DID explanation
class _DidInfoPanel extends StatefulWidget {
  @override
  State<_DidInfoPanel> createState() => _DidInfoPanelState();
}

class _DidInfoPanelState extends State<_DidInfoPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing2),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.blueGrey.shade700,
                  ),
                  const SizedBox(width: AppSpacing.spacing2),
                  Expanded(
                    child: Text(
                      'What\'s a DID and why do we need to generate one?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey.shade700,
                          ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: Colors.blueGrey.shade700,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacing3,
                0,
                AppSpacing.spacing3,
                AppSpacing.spacing3,
              ),
              child: Text(
                'Placeholder answer',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blueGrey.shade700,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
