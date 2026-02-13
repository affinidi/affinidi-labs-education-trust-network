import 'package:flutter/material.dart';
import '../../domain/entities/query_input.dart';

class QueryForm extends StatefulWidget {
  final Function(QueryInput) onSubmit;
  final VoidCallback? onClear;

  const QueryForm({
    super.key,
    required this.onSubmit,
    this.onClear,
  });

  @override
  State<QueryForm> createState() => _QueryFormState();
}

class _QueryFormState extends State<QueryForm> {
  final _formKey = GlobalKey<FormState>();
  final _entityIdController = TextEditingController();
  final _authorityIdController = TextEditingController();
  final _actionController = TextEditingController();
  final _resourceController = TextEditingController();

  @override
  void dispose() {
    _entityIdController.dispose();
    _authorityIdController.dispose();
    _actionController.dispose();
    _resourceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final input = QueryInput(
        entityId: _entityIdController.text.trim(),
        authorityId: _authorityIdController.text.trim(),
        action: _actionController.text.trim(),
        resource: _resourceController.text.trim(),
      );
      widget.onSubmit(input);
    }
  }

  void _clear() {
    _entityIdController.clear();
    _authorityIdController.clear();
    _actionController.clear();
    _resourceController.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _entityIdController,
            decoration: InputDecoration(
              labelText: 'Entity ID',
              hintText: 'did:example:entity123',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Entity ID is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _authorityIdController,
            decoration: InputDecoration(
              labelText: 'Authority ID',
              hintText: 'did:example:authority456',
              prefixIcon: const Icon(Icons.admin_panel_settings),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Authority ID is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _actionController,
            decoration: InputDecoration(
              labelText: 'Action',
              hintText: 'issue',
              prefixIcon: const Icon(Icons.arrow_forward),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Action is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _resourceController,
            decoration: InputDecoration(
              labelText: 'Resource',
              hintText: 'credential-type',
              prefixIcon: const Icon(Icons.inventory_2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Resource is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.search),
                  label: const Text('Query'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
