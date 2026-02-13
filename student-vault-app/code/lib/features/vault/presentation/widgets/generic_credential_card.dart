import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ssi/ssi.dart';

import '../../../../core/design_system/flip_card/flip_card.dart';
import '../../../../core/infrastructure/utils/credential_helper.dart';
import '../../../../core/infrastructure/utils/debug_logger.dart';
import '../../../../core/navigation/routes/dashboard_routes.dart';

class GenericCredentialCard extends StatelessWidget {
  const GenericCredentialCard({
    super.key,
    required this.credential,
    this.canFlip = true,
  });

  final VerifiableCredential credential;
  final bool canFlip;

  @override
  Widget build(BuildContext context) {
    const borderRadius = 16.0;
    final theme = Theme.of(context);

    // Generate unique card ID from credential
    final cardId = 'credential_${credential.id?.toString()}';

    // Use the canFlip parameter to control flip behavior
    return FlipCard(
      cardId: cardId,
      canFlip: canFlip,
      frontSide: _buildFrontSide(borderRadius, theme, context),
      backSide: _buildBackSide(borderRadius, theme, context),
      onFlip: () => debugLog('Credential Card flipped'),
    );
  }

  /// Extract credential-specific details for the expanded view
  static List<Map<String, dynamic>> extractCredentialDetails(
    ParsedVerifiableCredential credential,
  ) {
    final details = <Map<String, dynamic>>[];

    try {
      final credentialSubject = credential.credentialSubject[0].toJson();

      // Education Credential
      final studentInfo =
          credentialSubject['student'] as Map<String, dynamic>? ?? {};
      final instituteInfo =
          credentialSubject['institute'] as Map<String, dynamic>? ?? {};
      final programInfo =
          credentialSubject['programNCourse'] as Map<String, dynamic>? ?? {};

      details.add({
        'icon': Icons.person,
        'label': 'Student Name',
        'value':
            '${studentInfo['givenName'] as String? ?? ''} ${studentInfo['familyName'] as String? ?? ''}'
                .trim(),
      });
      details.add({
        'icon': Icons.school,
        'label': 'Program',
        'value': programInfo['program'] as String? ?? '',
      });
      details.add({
        'icon': Icons.business,
        'label': 'University',
        'value': instituteInfo['legalName'] as String? ?? '',
      });
      details.add({
        'icon': Icons.verified,
        'label': 'Accredited By',
        'value': instituteInfo['accreditedBy'] as String? ?? '',
      });
    } catch (e) {
      debugLog('Error extracting credential details', error: e);
    }

    return details;
  }

  Widget _buildFrontSide(
    double borderRadius,
    ThemeData theme,
    BuildContext context,
  ) {
    final credentialSubject = credential.credentialSubject[0].toJson();

    String title;
    var attributes = <String, String>{};
    var icon = CredentialHelper.credentialIcon(credential.type.toList());

    if (credential.type.contains('EducationCredential')) {
      // Education Certificate
      final studentInfo =
          credentialSubject['student'] as Map<String, dynamic>? ?? {};
      final instituteInfo =
          credentialSubject['institute'] as Map<String, dynamic>? ?? {};
      final programInfo =
          credentialSubject['programNCourse'] as Map<String, dynamic>? ?? {};

      // Program Name is the main title (large, prominent)
      title = programInfo['program'] as String? ?? 'Education Certificate';

      // University Name and Accreditor are attributes
      attributes = {
        'Student':
            '${studentInfo['givenName'] as String? ?? ''} ${studentInfo['familyName'] as String? ?? ''}'
                .trim(),
        'University': instituteInfo['legalName'] as String? ?? 'N/A',
        'Accredited By': instituteInfo['accreditedBy'] as String? ?? 'N/A',
      };
      icon = Icons.school;
    } else {
      title = credential.type.last;
    }

    // Education credentials use a white card background
    const isWhiteCard = true;

    return Stack(
      children: [
        // Drop shadow container
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2), // ← Drop shadow
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          // Main card container with blobs
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              decoration: BoxDecoration(
                gradient: CredentialHelper.getGradientForCredentialType(
                  credential.type,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Stack(
                children: [
                  // Base layer: Solid white background for white cards
                  if (isWhiteCard)
                    Positioned.fill(child: Container(color: Colors.white)),
                  // 2nd layer: 5% opacity gradient blobs (decorative)
                  Positioned.fill(
                    child: Stack(
                      children: [
                        // Orange blob - top left
                        Positioned(
                          top: -50,
                          left: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(
                                    0xFFFF9800,
                                  ).withValues(alpha: 0.05), // Orange - 5%
                                  const Color(
                                    0xFFFF9800,
                                  ).withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Yellow blob - bottom right
                        Positioned(
                          bottom: -60,
                          right: -60,
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(
                                    0xFFFFEB3B,
                                  ).withValues(alpha: 0.05), // Yellow - 5%
                                  const Color(
                                    0xFFFFEB3B,
                                  ).withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content layer - restructured without negative margins
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header section with gradient background (pink to purple)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFE91E63), // Pink
                              Color(0xFF9C27B0), // Purple
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icon, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight
                                      .w900, // ← More bold (was bold/w700)
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Rest of content with padding
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          12,
                          12,
                          12,
                        ), // ← More left padding (20 instead of 12)
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Issuer
                            Text(
                              'ISSUED BY',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: const Color(
                                  0xFF607D8B,
                                ), // Medium grey-blue
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              credential.issuer.id.toString(),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: const Color(
                                  0xFF37474F,
                                ), // Dark grey-blue
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Attributes
                            ...attributes.entries.map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        entry.key,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: const Color(
                                                0xFF607D8B,
                                              ), // Medium grey-blue
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        entry.value,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: const Color(
                                                0xFF263238,
                                              ), // Dark grey-blue
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Border outline as topmost layer
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                width: 2,
                color: const Color(
                  0xFFBDBDBD,
                ).withValues(alpha: 0.5), // Light grey
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackSide(
    double borderRadius,
    ThemeData theme,
    BuildContext context,
  ) {
    final qrSize = CredentialHelper.qrCodeSize;

    // Generate QR data from credential
    final qrData = credential.toString();

    return Container(
      // Drop shadow wrapper for back side only
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.2,
            ), // ← Drop shadow for separation
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Outer container with gradient border
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFD54F), // Yellow
                  Color(0xFFF44336), // Red
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(3), // Border thickness
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius - 3),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: CredentialHelper.getGradientForCredentialType(
                      credential.type,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius - 3),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Credential type label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF455A64).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          CredentialHelper.getCredentialTypeName(
                            credential.type,
                            issuerId: credential.issuer.id.toString(),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF263238),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // QR Code centered
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: qrSize,
                          backgroundColor: Colors.white,
                          errorCorrectionLevel: QrErrorCorrectLevel.M,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // View JSON button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => CredentialJsonRoute(
                                $extra:
                                    credential
                                        as ParsedVerifiableCredential<dynamic>,
                              ).push<void>(context),
                              icon: const Icon(Icons.code_rounded, size: 12),
                              label: const Text(
                                'View JSON',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.15,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // View Details button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                CredentialViewRoute(
                                  $extra:
                                      credential
                                          as ParsedVerifiableCredential<
                                            dynamic
                                          >,
                                ).push<void>(context);
                              },
                              icon: const Icon(
                                Icons.info_outline_rounded,
                                size: 12,
                              ),
                              label: const Text(
                                'Details',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFFFB300,
                                ), // Orange/yellow theme
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
