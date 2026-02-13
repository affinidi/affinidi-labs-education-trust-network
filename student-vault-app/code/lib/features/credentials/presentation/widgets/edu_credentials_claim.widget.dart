import 'package:affinidi_tdk_vdip/affinidi_tdk_vdip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'credential_claim_card.dart';
import '../../../vault/data/vault_service/vault_service.dart';
import '../../../vdip_claim/data/repositories/vdip_service/vdip_service.dart';

import '../../../../core/infrastructure/providers/shared_preferences_provider.dart';

/// Widget that displays credential claim cards for universities
/// Credentials display is handled by the parent CredentialsScreen
class EduCredentialsClaimWidget extends ConsumerWidget {
  const EduCredentialsClaimWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch vault state to check for existing credentials
    final vaultState = ref.watch(vaultServiceProvider);
    final allCredentials = vaultState.claimedCredentials ?? [];

    debugPrint(
      '[EduCredentialsClaimWidget] Total credentials: ${allCredentials.length}',
    );
    for (var cred in allCredentials) {
      final issuerId = cred.verifiableCredential.issuer.id.toString();
      debugPrint('[EduCredentialsClaimWidget] Credential issuer: $issuerId');
    }

    // Check if credentials already exist for each university
    final hasHKCredential = allCredentials.any(
      (c) => c.verifiableCredential.issuer.id.toString().contains('hongkong'),
    );
    final hasMacauCredential = allCredentials.any(
      (c) => c.verifiableCredential.issuer.id.toString().contains('macau'),
    );

    debugPrint('[EduCredentialsClaimWidget] hasHKCredential: $hasHKCredential');
    debugPrint(
      '[EduCredentialsClaimWidget] hasMacauCredential: $hasMacauCredential',
    );

    // If both credentials exist, don't show the claim section at all
    if (hasHKCredential && hasMacauCredential) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6), // Subtle light yellow
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Credential Claim Cards
            Text(
              'Ready to claim your university credentials?',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Show HK card only if not claimed
            if (!hasHKCredential) ...[
              CredentialClaimCard(
                universityName: 'Hong Kong University',
                credentialType: 'HK University Credentials',
                description:
                    'Claim your StudentID, Transcript, or Degree from Hong Kong University',
                icon: Icons.school,
                color: Theme.of(context).primaryColor,
                onTap: () => _handleClaimCredential(context, ref, 'hk'),
              ),
              const SizedBox(height: 16),
            ],

            // Show Macau card only if not claimed
            if (!hasMacauCredential)
              CredentialClaimCard(
                universityName: 'Macau University',
                credentialType: 'Macau University Credentials',
                description:
                    'Claim your StudentID, Transcript, or Degree from Macau University',
                icon: Icons.school,
                color: Theme.of(context).primaryColor,
                onTap: () => _handleClaimCredential(context, ref, 'macau'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleClaimCredential(
    BuildContext context,
    WidgetRef ref,
    String universityId,
  ) async {
    try {
      // Check if credential already exists for this university
      final vaultService = ref.read(vaultServiceProvider.notifier);
      await vaultService.getCredentials();

      final vaultState = ref.read(vaultServiceProvider);
      final allCredentials = vaultState.claimedCredentials ?? [];

      final hasCredential = allCredentials.any(
        (c) => c.verifiableCredential.issuer.id.toString().contains(
          universityId == 'hk' ? 'hongkong' : 'macau',
        ),
      );

      if (hasCredential && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You already have a credential from ${universityId == "hk" ? "Hong Kong" : "Macau"} University',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (!context.mounted) return;

      // Show credential claim flow
      await _showCredentialClaimFlow(context, ref, universityId);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showCredentialClaimFlow(
    BuildContext context,
    WidgetRef ref,
    String universityId,
  ) async {
    final universityName = universityId == 'hk'
        ? 'Hong Kong University'
        : 'Macau University';

    // Show bottom sheet with credential claim UI
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => _CredentialClaimFlow(
        universityId: universityId,
        universityName: universityName,
      ),
    );
  }
}

class _CredentialClaimFlow extends ConsumerStatefulWidget {
  const _CredentialClaimFlow({
    required this.universityId,
    required this.universityName,
  });

  final String universityId;
  final String universityName;

  @override
  ConsumerState<_CredentialClaimFlow> createState() =>
      _CredentialClaimFlowState();
}

class _CredentialClaimFlowState extends ConsumerState<_CredentialClaimFlow> {
  bool _isProcessing = false;
  String? _statusMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Claim ${widget.universityName} Credential',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Description
          Text(
            'Request a verifiable credential from ${widget.universityName}. This credential will be securely stored in your vault.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Status message
          if (_statusMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0), // Light orange
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (_isProcessing)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    const Icon(Icons.info, color: Color(0xFFE88A05)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _statusMessage!,
                      style: const TextStyle(color: Color(0xFF6D4C00)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          const Spacer(),

          // Claim button
          ElevatedButton(
            onPressed: _isProcessing ? null : _claimCredential,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB300), // Orange/yellow theme
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _isProcessing ? 'Processing...' : 'Claim Credential',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _claimCredential() async {
    try {
      if (!mounted) return;

      setState(() {
        _isProcessing = true;
        _statusMessage = 'Initializing credential request...';
      });

      // Get user email from preferences - using listen to ensure provider is initialized
      setState(() {
        _statusMessage = 'Loading user information...';
      });

      debugPrint('[CredentialClaim] Reading sharedPreferencesProvider...');
      final prefs = await ref.read(sharedPreferencesProvider.future);
      debugPrint('[CredentialClaim] SharedPreferences loaded');

      final email = prefs.getString(SharedPreferencesKeys.email.name);
      debugPrint('[CredentialClaim] Email: $email');

      if (email == null || email.isEmpty) {
        throw Exception('Email not found. Please login again.');
      }

      // Set the provider based on university selection
      final providerName = widget.universityId == 'hk'
          ? 'Hong Kong University'
          : 'Macau University';

      debugPrint('[CredentialClaim] Setting provider: $providerName');
      await prefs.setString(SharedPreferencesKeys.provider.name, providerName);
      debugPrint('[CredentialClaim] Provider set successfully');

      if (!mounted) return;

      setState(() {
        _statusMessage = 'Connecting to credential service...';
      });

      debugPrint('[CredentialClaim] Reading vdipServiceProvider...');
      final vdipService = ref.read(vdipServiceProvider);
      debugPrint('[CredentialClaim] VdipService loaded');

      // Determine proposal ID based on university
      // These should match the credential types configured in your issuer
      final proposalId = widget.universityId == 'hk'
          ? 'HKUniversityCredential'
          : 'MacauUniversityCredential';

      if (!mounted) return;

      setState(() {
        _statusMessage = 'Preparing credential request...';
      });

      debugPrint(
        '[CredentialClaim] Creating credential request for: $proposalId',
      );
      final credentialsRequest = RequestCredentialsOptions(
        proposalId: proposalId,
        credentialMeta: CredentialMeta(
          data: {'email': email, 'university_id': widget.universityId},
        ),
      );

      debugPrint('[CredentialClaim] Calling requestCredential...');
      await vdipService.requestCredential(
        credentialsRequest: credentialsRequest,
        onProgress: (msg) async {
          if (mounted) {
            setState(() {
              _statusMessage = msg;
            });
          }
        },
        onComplete: (result) async {
          if (!mounted) return;

          if (result.isSuccess) {
            setState(() {
              _statusMessage = 'Credential received successfully!';
              _isProcessing = false;
            });

            // Wait for credential to be saved
            await Future<void>.delayed(const Duration(milliseconds: 500));

            if (!mounted) return;

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${widget.universityName} credential issued successfully!',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

            // Close the bottom sheet
            Navigator.of(context).pop();
          } else if (result.isFailure) {
            setState(() {
              _statusMessage =
                  'Failed to receive credential: ${result.message}';
              _isProcessing = false;
            });
          } else if (result.isCancelled) {
            setState(() {
              _statusMessage = 'Credential request was cancelled';
              _isProcessing = false;
            });
          }
        },
      );
    } catch (error, stackTrace) {
      debugPrint('[CredentialClaim] Error occurred: $error');
      debugPrint('[CredentialClaim] StackTrace: $stackTrace');

      if (!mounted) return;

      setState(() {
        _statusMessage = 'Error: $error';
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
