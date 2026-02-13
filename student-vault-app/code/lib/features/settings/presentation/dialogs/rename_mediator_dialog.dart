import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/infrastructure/extensions/build_context_extensions.dart';

class RenameMediatorDialog extends HookConsumerWidget {
  const RenameMediatorDialog({super.key, required this.currentName});

  final String currentName;

  static Future<String?> show(
    BuildContext context, {
    required String currentName,
  }) {
    return showDialog<String>(
      context: context,
      builder: (ctx) => RenameMediatorDialog(currentName: currentName),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: currentName);

    void onDone() {
      final name = controller.text.trim();
      if (name.isEmpty) return;
      Navigator.of(context).pop(name); // return the new name
    }

    return AlertDialog(
      title: Text(context.l10n.setMediatorName),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: context.l10n.mediatorName,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            context.l10n.generalCancel,
            style: TextStyle(color: context.colorScheme.onSurface),
          ),
        ),
        ElevatedButton(
          onPressed: onDone,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(context.l10n.generalDone),
        ),
      ],
    );
  }
}
