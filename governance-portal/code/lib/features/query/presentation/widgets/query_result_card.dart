import 'package:flutter/material.dart';
import '../../domain/entities/query_result.dart';

class QueryResultCard extends StatelessWidget {
  final QueryResult result;

  const QueryResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[700], size: 32),
                const SizedBox(width: 12),
                Text(
                  'Query Result',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 32),

            // Recognized
            _buildResultRow(
              context,
              'Recognized',
              result.recognized,
              result.recognized ? Icons.check_circle : Icons.cancel,
              result.recognized ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 16),

            // Authorized
            _buildResultRow(
              context,
              'Authorized',
              result.authorized,
              result.authorized ? Icons.verified_user : Icons.block,
              result.authorized ? Colors.blue : Colors.red,
            ),

            const Divider(height: 32),

            // Timestamp
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Queried at: ${_formatTimestamp(result.timestamp)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),

            // Overall status
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getOverallStatusColor(result),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getOverallStatusIcon(result),
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getOverallStatusMessage(result),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
    BuildContext context,
    String label,
    bool value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? color.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value ? color : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: value ? color : Colors.grey[600], size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: value ? color : Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value ? 'Yes' : 'No',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: value ? color : Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getOverallStatusColor(QueryResult result) {
    if (result.recognized && result.authorized) {
      return Colors.green;
    } else if (result.recognized) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  IconData _getOverallStatusIcon(QueryResult result) {
    if (result.recognized && result.authorized) {
      return Icons.check_circle;
    } else if (result.recognized) {
      return Icons.warning;
    } else {
      return Icons.cancel;
    }
  }

  String _getOverallStatusMessage(QueryResult result) {
    if (result.recognized && result.authorized) {
      return 'Entity is recognized and authorized';
    } else if (result.recognized && !result.authorized) {
      return 'Entity is recognized but not authorized';
    } else if (!result.recognized && result.authorized) {
      return 'Entity is not recognized but marked as authorized';
    } else {
      return 'Entity is neither recognized nor authorized';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }
}
