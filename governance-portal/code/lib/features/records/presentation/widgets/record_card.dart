import 'package:flutter/material.dart';
import '../../domain/entities/trust_record.dart';

class RecordCard extends StatelessWidget {
  final TrustRecord record;
  final VoidCallback? onTap;

  const RecordCard({
    super.key,
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entity ID',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.entityId,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildStatusBadges(),
                ],
              ),

              const Divider(height: 24),

              // Details Grid
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      context,
                      'Authority ID',
                      record.authorityId,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailItem(
                      context,
                      'Action',
                      record.action,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _buildDetailItem(
                context,
                'Resource',
                record.resource,
              ),

              // Timestamps
              if (record.createdAt != null || record.updatedAt != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (record.createdAt != null) ...[
                      Icon(Icons.access_time,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Created: ${_formatDate(record.createdAt!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                    if (record.updatedAt != null) ...[
                      const SizedBox(width: 16),
                      Icon(Icons.update, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Updated: ${_formatDate(record.updatedAt!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatusBadges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: record.recognized ? Colors.green[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                record.recognized ? Icons.check_circle : Icons.cancel,
                size: 14,
                color: record.recognized ? Colors.green[700] : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                record.recognized ? 'Recognized' : 'Not Recognized',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      record.recognized ? Colors.green[700] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: record.authorized ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                record.authorized ? Icons.verified_user : Icons.block,
                size: 14,
                color: record.authorized ? Colors.blue[700] : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                record.authorized ? 'Authorized' : 'Not Authorized',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      record.authorized ? Colors.blue[700] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
