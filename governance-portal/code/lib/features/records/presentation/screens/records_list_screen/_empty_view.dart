part of 'records_list_screen.dart';

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.neutral300,
          ),
          const SizedBox(height: 16),
          Text(
            'No records found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.neutral500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first record',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral400,
                ),
          ),
        ],
      ),
    );
  }
}
