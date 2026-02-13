import 'package:flutter/material.dart';
import '../../domain/entities/query_input.dart';

class QueryHistoryList extends StatelessWidget {
  final List<QueryInput> history;
  final VoidCallback? onClearHistory;
  final Function(QueryInput)? onQuerySelected;

  const QueryHistoryList({
    super.key,
    required this.history,
    this.onClearHistory,
    this.onQuerySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Query History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (history.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear_all, size: 20),
                  onPressed: onClearHistory,
                  tooltip: 'Clear history',
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No history yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final query = history[index];
                    return _QueryHistoryItem(
                      query: query,
                      onTap: () => onQuerySelected?.call(query),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _QueryHistoryItem extends StatelessWidget {
  final QueryInput query;
  final VoidCallback onTap;

  const _QueryHistoryItem({
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField(context, 'Entity', query.entityId),
            const SizedBox(height: 4),
            _buildField(context, 'Authority', query.authorityId),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: _buildField(context, 'Action', query.action),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildField(context, 'Resource', query.resource),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: 10,
              ),
        ),
        Text(
          value.length > 30 ? '${value.substring(0, 30)}...' : value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
