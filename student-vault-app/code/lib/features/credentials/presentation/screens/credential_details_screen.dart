import 'package:flutter/material.dart';
import 'package:student_vault_app/features/credentials/domain/entities/credential.dart';

class CredentialDetailsScreen extends StatelessWidget {
  const CredentialDetailsScreen({super.key, required this.credential});

  final Credential credential;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHK = credential.issuer.contains('hongkong');
    final logoAsset = isHK ? 'assets/logos/hk.png' : 'assets/logos/macau.png';
    final title =
        credential.credentialSubject['name'] as String? ?? credential.type;
    final institution =
        credential.credentialSubject['institution'] as String? ??
        'Unknown Institution';
    final field = credential.credentialSubject['field'] as String? ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credential Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Credential Card Render
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(logoAsset, fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        institution,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  if (field.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      field,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Georgia',
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      // horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(
                        0.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(credential.issuanceDate),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.verified,
                          color: theme.colorScheme.primary,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Metadata Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Credential Metadata',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _MetadataItem(
                    icon: Icons.fingerprint,
                    label: 'Credential ID',
                    value: credential.id,
                  ),
                  const SizedBox(height: 12),

                  _MetadataItem(
                    icon: Icons.category_outlined,
                    label: 'Type',
                    value: credential.type,
                  ),
                  const SizedBox(height: 12),

                  _MetadataItem(
                    icon: Icons.business_outlined,
                    label: 'Issuer',
                    value: credential.issuer,
                  ),
                  const SizedBox(height: 12),

                  _MetadataItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Issuance Date',
                    value: _formatFullDate(credential.issuanceDate),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Credential Subject',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...credential.credentialSubject.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _MetadataItem(
                        icon: Icons.info_outline,
                        label: _formatLabel(entry.key),
                        value: entry.value.toString(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatLabel(String key) {
    return key
        .split(RegExp(r'(?=[A-Z])'))
        .map((word) {
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}

class _MetadataItem extends StatelessWidget {
  const _MetadataItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
