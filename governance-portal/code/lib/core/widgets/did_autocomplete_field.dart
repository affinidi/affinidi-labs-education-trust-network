import 'package:flutter/material.dart';

/// Model for DID autocomplete options
class DIDOption {
  final String name;
  final String did;

  const DIDOption({
    required this.name,
    required this.did,
  });

  @override
  String toString() => did;
}

/// Autocomplete widget for DID selection
/// Shows name as primary text and DID as secondary text in dropdown
class DIDAutocompleteField extends StatelessWidget {
  final TextEditingController controller;
  final List<DIDOption> options;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final bool enabled;
  final String? Function(String?)? validator;

  const DIDAutocompleteField({
    super.key,
    required this.controller,
    required this.options,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<DIDOption>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return options;
        }
        return options.where((DIDOption option) {
          final searchLower = textEditingValue.text.toLowerCase();
          return option.name.toLowerCase().contains(searchLower) ||
              option.did.toLowerCase().contains(searchLower);
        });
      },
      displayStringForOption: (DIDOption option) => option.did,
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController fieldController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        // Sync the field controller with our controller
        if (controller.text.isNotEmpty && fieldController.text.isEmpty) {
          fieldController.text = controller.text;
        }

        fieldController.addListener(() {
          if (controller.text != fieldController.text) {
            controller.text = fieldController.text;
          }
        });

        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: Icon(prefixIcon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          enabled: enabled,
          validator: validator,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<DIDOption> onSelected,
        Iterable<DIDOption> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 300,
                maxWidth: 600,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final DIDOption option = options.elementAt(index);
                  return ListTile(
                    title: Text(
                      option.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      option.did,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      onSelected(option);
                    },
                    dense: true,
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (DIDOption selection) {
        controller.text = selection.did;
      },
    );
  }
}
