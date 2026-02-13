import 'package:flutter/material.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';

/// App Modal Component
///
/// Half-screen centered modal following design system specs from 05-components.md
///
/// Features:
/// - 50% of content width (min 560px, max 720px)
/// - Semi-transparent overlay backdrop with shadow
/// - Close button (X) at top right
/// - Header with title
/// - Scrollable body
/// - Optional footer with actions
///
/// Usage:
/// ```dart
/// showAppModal(
///   context: context,
///   title: 'Create Record',
///   body: RecordFormContent(),
/// );
/// ```
class AppModal extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? footer;
  final String? subtitle;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const AppModal({
    super.key,
    required this.title,
    required this.body,
    this.footer,
    this.subtitle,
    this.showCloseButton = true,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    const baseInsetPadding = EdgeInsets.symmetric(horizontal: 40, vertical: 24);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: baseInsetPadding,
      child: AnimatedPadding(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final availableHeight = constraints.maxHeight;

            final maxWidth = availableWidth < 720.0 ? availableWidth : 720.0;
            final minWidth = availableWidth < 560.0 ? availableWidth : 560.0;
            final maxHeight = availableHeight < 800.0 ? availableHeight : 800.0;

            return ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: minWidth,
                maxWidth: maxWidth,
                maxHeight: maxHeight,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.navBackground.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: body,
                      ),
                    ),
                    if (footer != null) _buildFooter(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.neutral300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showCloseButton)
            Center(
              child: IconButton(
                icon: const Icon(Icons.close),
                iconSize: 24,
                color: AppColors.neutral500,
                tooltip: 'Close',
                padding: EdgeInsets.zero,
                onPressed: onClose ?? () => Navigator.of(context).pop(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.neutral300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [footer!],
      ),
    );
  }
}

/// Helper function to show AppModal
Future<T?> showAppModal<T>({
  required BuildContext context,
  required String title,
  required Widget body,
  Widget? footer,
  String? subtitle,
  bool showCloseButton = true,
  VoidCallback? onClose,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: AppColors.navBackground.withOpacity(0.5),
    builder: (context) => AppModal(
      title: title,
      subtitle: subtitle,
      body: body,
      footer: footer,
      showCloseButton: showCloseButton,
      onClose: onClose,
    ),
  );
}
