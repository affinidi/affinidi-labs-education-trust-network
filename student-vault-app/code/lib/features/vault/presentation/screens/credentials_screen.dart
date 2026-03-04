import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssi/ssi.dart';

import '../../../../core/design_system/flip_card/flip_card_controller.dart';
import '../../../../core/infrastructure/providers/app_logger_provider.dart';
import '../../../../core/infrastructure/utils/debug_logger.dart';
import '../../data/vault_service/vault_service.dart';
import '../../data/vault_service/vault_service_state.dart';
import '../widgets/generic_credential_card.dart';
import '../../../credentials/presentation/widgets/slider_credentials_widget.dart';
import '../../../../core/design_system/backgrounds/credentials_background.dart';

import '../../../credentials/presentation/widgets/edu_credentials_claim.widget.dart';

class CredentialsScreen extends ConsumerStatefulWidget {
  const CredentialsScreen({super.key});

  @override
  ConsumerState<CredentialsScreen> createState() => _CredentialsScreenState();
}

const _logKey = 'CERTIZEN_CREDENTIALS';

class _CredentialsScreenState extends ConsumerState<CredentialsScreen> {
  bool _hasRequestedCredentials = false;
  bool _isInitialLoading = false;
  String? _loadError;
  late final _logger = ref.read(appLoggerProvider);
  ProviderSubscription<VaultServiceState>? _vaultSubscription;
  final Set<String> _deletingCredentialIds = <String>{};
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    // Reset all flip card states to show front side by default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(flipCardControllerProvider.notifier).flipBack();
    });

    _vaultSubscription = ref.listenManual<VaultServiceState>(
      vaultServiceProvider,
      (previous, next) => _handleVaultState(next),
    );
    _handleVaultState(ref.read(vaultServiceProvider));
  }

  @override
  void dispose() {
    _vaultSubscription?.close();
    super.dispose();
  }

  void _handleVaultState(VaultServiceState state) {
    if (_hasRequestedCredentials || state.vault == null) {
      return;
    }
    _logger.debug(
      'Vault instance available. Loading credentials…',
      name: _logKey,
    );
    _hasRequestedCredentials = true;
    _loadError = null;
    setState(() {
      _isInitialLoading = true;
    });
    _triggerLoad();
  }

  Future<void> _triggerLoad() async {
    _logger.info('Requesting credentials from vault', name: _logKey);
    try {
      await ref.read(vaultServiceProvider.notifier).getCredentials(force: true);
      final count =
          ref.read(vaultServiceProvider).claimedCredentials?.length ?? 0;
      _logger.info('Loaded $count credential(s) from vault', name: _logKey);
      if (!mounted) return;
      setState(() {
        _loadError = null;
        _isInitialLoading = false;
      });
    } catch (error, stackTrace) {
      debugLog(
        'Failed to load credentials',
        name: _logKey,
        logger: _logger,
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      setState(() {
        _loadError = 'Unable to load credentials. Please try again.';
        _isInitialLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_loadError!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vaultState = ref.watch(vaultServiceProvider);
    final credentials = vaultState.claimedCredentials;

    debugLog(
      'Build: credentials count = ${credentials?.length ?? 0}',
      name: _logKey,
      logger: _logger,
    );

    final entries = credentials == null
        ? const <_CredentialEntry>[]
        : credentials
              .map((DigitalCredential digitalCredential) {
                try {
                  debugLog(
                    'Mapping credential: id=${digitalCredential.id}',
                    name: _logKey,
                    logger: _logger,
                  );
                  final verifiable =
                      digitalCredential.verifiableCredential
                          as ParsedVerifiableCredential;
                  final digitalId = digitalCredential.id;
                  debugLog(
                    'Successfully mapped credential: digitalId=$digitalId, type=${verifiable.type}',
                    name: _logKey,
                    logger: _logger,
                  );
                  return _CredentialEntry(
                    credential: verifiable,
                    digitalId: digitalId,
                  );
                } catch (e, stackTrace) {
                  debugLog(
                    'Error mapping credential: $e',
                    name: _logKey,
                    logger: _logger,
                    error: e,
                    stackTrace: stackTrace,
                  );
                  return null;
                }
              })
              .whereType<_CredentialEntry>()
              .toList();

    debugLog(
      'Build: entries count = ${entries.length}',
      name: _logKey,
      logger: _logger,
    );

    final isLoading = credentials == null || _isInitialLoading;

    debugLog(
      'Build: isLoading=$isLoading (credentials==null: ${credentials == null}, _isInitialLoading: $_isInitialLoading)',
      name: _logKey,
      logger: _logger,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFC470),
      // appBar: AppBar(
      //   title: const Text('Credentials'),
      //   backgroundColor: const Color(0xFFFFC470),
      //   elevation: 0,
      //   centerTitle: true,
      //   systemOverlayStyle: const SystemUiOverlayStyle(
      //     statusBarColor: Color(0xFFFFC470),
      //     statusBarIconBrightness: Brightness.dark,
      //     statusBarBrightness: Brightness.light,
      //   ),
      // ),
      body: Stack(
        children: [
          // Background layer
          const CredentialsBackground(),

          // Content layer
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _triggerLoad,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 16),
                    // show claimed credentials
                    // const SliderCredentialsWidget(),
                    // const SizedBox(height: 24),
                    _buildCredentialContent(entries, isLoading),
                    const SizedBox(height: 300), // Space for bottom sheet
                  ],
                ),
              ),
            ),
          ),

          // Bottom sheet style credential claim widget
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const EduCredentialsClaimWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialContent(
    List<_CredentialEntry> entries,
    bool isLoading,
  ) {
    debugLog(
      '_buildCredentialContent: isLoading=$isLoading, entries.length=${entries.length}',
      name: _logKey,
      logger: _logger,
    );

    if (isLoading) {
      debugLog(
        'Rendering: _CredentialsLoading',
        name: _logKey,
        logger: _logger,
      );
      return const _CredentialsLoading();
    } else if (entries.isEmpty) {
      debugLog(
        'No credentials - showing empty state',
        name: _logKey,
        logger: _logger,
      );
      return _buildEmptyState();
    } else {
      debugLog(
        'Rendering: _buildWalletStack with ${entries.length} entries',
        name: _logKey,
        logger: _logger,
      );
      return _buildWalletStack(entries);
    }
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                'My Credentials',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wallet_outlined,
                    size: 64,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No credentials yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Claim your first credential using the cards below',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletStack(List<_CredentialEntry> entries) {
    // Add section header
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                'My Credentials',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        _buildWalletStackContent(entries),
      ],
    );
  }

  Widget _buildWalletStackContent(List<_CredentialEntry> entries) {
    debugLog(
      '_buildWalletStackContent: entries=${entries.length}',
      name: _logKey,
      logger: _logger,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(entries.length, (index) {
          final isThisExpanded = _expandedIndex == index;
          final entry = entries[index];
          final isDeleting =
              entry.digitalId != null &&
              _deletingCredentialIds.contains(entry.digitalId);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              // Swipe down gesture on expanded card to collapse
              onVerticalDragEnd: isThisExpanded
                  ? (details) {
                      if (details.primaryVelocity != null &&
                          details.primaryVelocity! > 300) {
                        _collapseCard();
                      }
                    }
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: isThisExpanded ? null : () => _expandCard(index),
                        child: _buildCredentialCard(entry, isThisExpanded),
                      ),
                      // Delete button positioned on top right of card, centered in heading
                      if (!isThisExpanded)
                        Positioned(
                          top: 18,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: isDeleting
                                  ? null
                                  : () => _showDeleteConfirmation(
                                      entry.digitalId,
                                    ),
                              icon: isDeleting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.red,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                              tooltip: 'Delete credential',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Show additional details when expanded
                  if (isThisExpanded)
                    _buildCredentialDetails(entry.credential, entry.digitalId),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCredentialCard(_CredentialEntry entry, bool isExpanded) {
    final credential = entry.credential;
    return GenericCredentialCard(credential: credential);
  }

  Future<void> _deleteCredential(String? credentialId) async {
    if (credentialId == null || credentialId.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credential identifier missing. Cannot delete.'),
          ),
        );
      }
      return;
    }
    if (_deletingCredentialIds.contains(credentialId)) {
      return;
    }

    setState(() {
      _deletingCredentialIds.add(credentialId);
    });

    try {
      await ref
          .read(vaultServiceProvider.notifier)
          .deleteCredential(credentialId);
      _logger.info('Deleted credential $credentialId', name: _logKey);

      // Collapse the expanded view to show all credentials
      if (mounted) {
        setState(() {
          _expandedIndex = null;
        });
      }

      await _triggerLoad();
      if (!mounted) return;
      if (_loadError == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Credential deleted.')));
      }
    } catch (error, stackTrace) {
      _logger.error(
        'Failed to delete credential $credentialId',
        error: error,
        stackTrace: stackTrace,
        name: _logKey,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to delete credential. Please try again.'),
          ),
        );
      }
    } finally {
      if (!mounted) {
        _deletingCredentialIds.remove(credentialId);
      } else {
        setState(() {
          _deletingCredentialIds.remove(credentialId);
        });
      }
    }
  }

  Widget _buildCredentialDetails(
    ParsedVerifiableCredential credential,
    String? digitalId,
  ) {
    final details = _extractCredentialDetails(credential);
    if (details.isEmpty) return const SizedBox.shrink();

    final isDeleting =
        digitalId != null && _deletingCredentialIds.contains(digitalId);

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(
          top: 8,
          bottom: 100,
        ), // ← Reduced top margin from 16 to 8
        constraints: const BoxConstraints(
          maxHeight: 400, // Limit height to make it scrollable
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // Gradient border using a border with gradient
          border: Border.all(
            width: 3, // Medium thick border
            color: Colors.transparent, // Will be covered by gradient
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          // Gradient border effect
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
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3), // 30% opacity white
            borderRadius: BorderRadius.circular(
              13,
            ), // Slightly smaller to show gradient
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Credential Details',
                      style: TextStyle(
                        color: Colors.black, // Black text
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: isDeleting
                              ? null
                              : () => _showDeleteConfirmation(digitalId),
                          icon: isDeleting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.red,
                                  ),
                                )
                              : const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                          tooltip: 'Delete credential',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...details.map(
                  (detail) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          detail['icon'] as IconData,
                          size: 16,
                          color: Colors.black87, // Black for icons
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail['label'] as String,
                                style: const TextStyle(
                                  color: Colors.black87, // Black for labels
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                detail['value'] as String,
                                style: const TextStyle(
                                  color: Colors.black, // Black for values
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(String? credentialId) async {
    if (credentialId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Credential'),
          content: const Text(
            'Are you sure you want to delete this credential? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deleteCredential(credentialId);
    }
  }

  List<Map<String, dynamic>> _extractCredentialDetails(
    ParsedVerifiableCredential credential,
  ) {
    final details = <Map<String, dynamic>>[];

    try {
      // Common credential information (defined in main screen)
      details.add({
        'icon': Icons.fingerprint,
        'label': 'Credential ID',
        'value': credential.id.toString(),
      });

      details.add({
        'icon': Icons.business,
        'label': 'Issued by',
        'value': credential.issuer.id.toString(),
      });

      // Issuance date
      if (credential.validFrom != null) {
        try {
          final date = credential.validFrom!;
          details.add({
            'icon': Icons.calendar_today,
            'label': 'Issued on',
            'value': '${date.day}/${date.month}/${date.year}',
          });
        } catch (e) {
          // Handle date parsing error
        }
      }

      // Expiration date
      if (credential.validUntil != null) {
        try {
          final date = credential.validUntil!;
          details.add({
            'icon': Icons.event_available,
            'label': 'Expires on',
            'value': '${date.day}/${date.month}/${date.year}',
          });
        } catch (e) {
          // Handle date parsing error
        }
      }

      details.add({
        'icon': Icons.fingerprint,
        'label': 'Subject ID',
        'value': credential.credentialSubject[0]['id'].toString(),
      });

      details.addAll(
        GenericCredentialCard.extractCredentialDetails(credential),
      );
    } catch (e) {
      _logger.error('Error extracting credential details: $e', name: _logKey);
    }

    return details;
  }

  void _expandCard(int index) {
    setState(() {
      _expandedIndex = index;
    });
  }

  void _collapseCard() {
    // Flip the card back to front before collapsing
    ref.read(flipCardControllerProvider.notifier).flipBack();

    setState(() {
      _expandedIndex = null;
    });
  }
}

class _CredentialEntry {
  const _CredentialEntry({required this.credential, this.digitalId});

  final ParsedVerifiableCredential credential;
  final String? digitalId;
}

class _CredentialsLoading extends StatelessWidget {
  const _CredentialsLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Fetching credentials from your vault...'),
          ],
        ),
      ),
    );
  }
}
