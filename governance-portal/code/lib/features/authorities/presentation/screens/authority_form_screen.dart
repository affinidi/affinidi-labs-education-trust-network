import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:governance_portal/features/authorities/domain/entities/authority.dart';
import 'package:governance_portal/features/authorities/presentation/widgets/authority_form_widget.dart';

class AuthorityFormScreen extends ConsumerWidget {
  final bool isModal;
  final Authority? initialAuthority;

  const AuthorityFormScreen({
    super.key,
    this.isModal = false,
    this.initialAuthority,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isModal) {
      // For modal context
      return AuthorityFormWidget(
        initialAuthority: initialAuthority,
        showCancelButton: true,
        onCancel: () => Navigator.of(context).pop(),
        onSubmit: (data) => Navigator.of(context).pop(data),
      );
    }

    // For non-modal context (inline in empty state)
    return AuthorityFormWidget(
      initialAuthority: initialAuthority,
      showCancelButton: false,
      onSubmit: (data) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authority "${data['name']}" created'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }
}
