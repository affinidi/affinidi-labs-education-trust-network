part of 'records_list_screen.dart';

class _StatusTag extends StatelessWidget {
  final String label;
  final bool isPositive;

  const _StatusTag({
    required this.label,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isPositive
        ? AppColors.semanticSuccessLight
        : AppColors.semanticErrorLight;
    final fg = isPositive
        ? AppColors.semanticSuccessDark
        : AppColors.semanticErrorDark;
    final border =
        isPositive ? AppColors.semanticSuccess : AppColors.semanticError;
    final icon = isPositive ? Icons.verified_user : Icons.block;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
