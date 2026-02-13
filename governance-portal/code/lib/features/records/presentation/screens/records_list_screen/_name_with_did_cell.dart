part of 'records_list_screen.dart';

class _NameWithDidCell extends StatelessWidget {
  final String name;
  final String did;
  final double maxWidth;

  const _NameWithDidCell({
    required this.name,
    required this.did,
    this.maxWidth = 320,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.neutral500,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          Text(
            did,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.neutral400,
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
