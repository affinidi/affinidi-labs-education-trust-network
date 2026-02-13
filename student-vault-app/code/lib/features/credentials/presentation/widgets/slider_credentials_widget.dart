import 'package:flutter/material.dart';
import 'package:student_vault_app/features/credentials/domain/entities/credential.dart';
import 'package:student_vault_app/features/credentials/presentation/screens/credential_details_screen.dart';

class SliderCredentialsWidget extends StatelessWidget {
  const SliderCredentialsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock credentials converted to Credential entities
    final credentials = [
      Credential(
        id: 'cred-macau-1',
        type: 'Master of Laws',
        issuer: 'did:peer:macau-school-of-law',
        issuanceDate: DateTime(2024, 6, 15),
        credentialSubject: {
          'name': 'Master of Laws',
          'institution': 'Macau School of Law',
          'field': 'International Business Law',
        },
      ),
      Credential(
        id: 'cred-macau-2',
        type: 'Master of Laws',
        issuer: 'did:peer:macau-school-of-law',
        issuanceDate: DateTime(2023, 12, 20),
        credentialSubject: {
          'name': 'Master of Laws',
          'institution': 'Macau School of Law',
          'field': 'Constitutional Law',
        },
      ),
      Credential(
        id: 'cred-hk-1',
        type: 'Bachelor of Law',
        issuer: 'did:peer:hongkong-university',
        issuanceDate: DateTime(2022, 5, 18),
        credentialSubject: {
          'name': 'Bachelor of Law',
          'institution': 'HK University',
          'field': 'General Law',
        },
      ),
    ];

    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: credentials.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _CredentialCard(credential: credentials[index]),
          );
        },
      ),
    );
  }
}

class _CredentialCard extends StatelessWidget {
  const _CredentialCard({required this.credential});

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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) =>
                  CredentialDetailsScreen(credential: credential),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Logo + Title
              Row(
                children: [
                  // Logo
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(logoAsset, fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          institution,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Content: Field of study
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      field,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
              ),

              // Footer: Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(credential.issuanceDate),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.verified,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
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
}
