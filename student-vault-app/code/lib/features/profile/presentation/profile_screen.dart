import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meeting_place_core/meeting_place_core.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/design_system/backgrounds/credentials_background.dart';

import '../../../core/infrastructure/configuration/environment.dart';
import '../../../core/infrastructure/providers/shared_preferences_provider.dart';
import '../../../core/infrastructure/utils/credential_helper.dart';
import '../../authentication/domain/auth_provider/auth_provider.dart';
import '../../mediator/data/repositories/channel_repository_drift_provider.dart';
import '../../settings/data/settings_service/settings_service.dart';
import '../../vault/data/vault_service/vault_service.dart';
import '../../vault/presentation/screens/debug_logs_screen.dart';

import '../../../core/navigation/routes/route_names.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _versionTapCount = 0;
  Timer? _versionTapTimer;
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
  }

  @override
  void dispose() {
    _versionTapTimer?.cancel();
    super.dispose();
  }

  Future<void> _performLogout() async {
    try {
      await ref.read(authProvider.notifier).logout();

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(RouteNames.authentication, (route) => false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout successful'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vaultState = ref.watch(vaultServiceProvider);
    final profile = vaultState.defaultProfile;

    // Determine verification and claimed status based on credentials
    final digitalCredentials = vaultState.claimedCredentials ?? [];

    final employmentCard = digitalCredentials.where((credential) {
      return credential.verifiableCredential.type.contains(
        CredentialHelper.employment,
      );
    }).firstOrNull;

    final employerCredentialSubject = employmentCard
        ?.verifiableCredential
        .credentialSubject[0]
        .toJson();

    final employer = employerCredentialSubject?['legalEmployer'];

    // Get email and displayName from shared preferences, with environment fallbacks
    final environment = ref.watch(environmentProvider);
    final sharedPrefsAsync = ref.watch(sharedPreferencesProvider);
    final userEmail = sharedPrefsAsync.when(
      data: (prefs) =>
          prefs.getString(SharedPreferencesKeys.email.name) ??
          environment.studentEmail,
      loading: () => environment.studentEmail,
      error: (_, _) => environment.studentEmail,
    );
    final displayName = sharedPrefsAsync.when(
      data: (prefs) =>
          prefs.getString(SharedPreferencesKeys.displayName.name) ??
          '${environment.studentFirstName} ${environment.studentLastName}',
      loading: () =>
          '${environment.studentFirstName} ${environment.studentLastName}',
      error: (_, _) =>
          '${environment.studentFirstName} ${environment.studentLastName}',
    );

    final effectiveName = displayName;

    if (profile == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFC470),
        // appBar: AppBar(
        //   backgroundColor: const Color(0xFFFFC470),
        //   elevation: 0,
        //   systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: Color(0xFFFFC470),
        //     statusBarIconBrightness: Brightness.dark,
        //     statusBarBrightness: Brightness.light,
        //   ),
        // ),
        body: Stack(
          children: [
            const CredentialsBackground(),
            Container(
              color: Colors.transparent,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFC470),
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFFFFC470),
      //   elevation: 0,
      //   systemOverlayStyle: const SystemUiOverlayStyle(
      //     statusBarColor: Color(0xFFFFC470),
      //     statusBarIconBrightness: Brightness.dark,
      //     statusBarBrightness: Brightness.light,
      //   ),
      // ),
      body: Stack(
        children: [
          const CredentialsBackground(overlayTop: 180),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Hello $effectiveName!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   'Manage your profile information',
                  //   style: theme.textTheme.bodyLarge?.copyWith(
                  //     color: Colors.grey.shade400,
                  //   ),
                  // ),
                  const SizedBox(height: 32),

                  // Profile Avatar
                  _FloatingAvatar(effectiveName: effectiveName, theme: theme),
                  const SizedBox(height: 32),

                  // Name Section
                  _buildInfoSection(
                    context: context,
                    label: 'Full Name',
                    icon: Icons.person_outline_rounded,
                    child: Text(
                      effectiveName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        // color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email Section
                  if (userEmail.isNotEmpty) ...[
                    _buildInfoSection(
                      context: context,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      child: Text(
                        userEmail,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          // color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // DID Section
                  _buildInfoSection(
                    context: context,
                    label: 'Decentralized Identifier (DID)',
                    icon: Icons.fingerprint_rounded,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.did,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              // color: Colors.grey.shade400,
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: profile.did));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('DID copied to clipboard'),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Organization Name
                  if (employer != null && employer['name'] != null) ...[
                    const SizedBox(height: 16),
                    _buildInfoSection(
                      context: context,
                      label: 'Organization Name',
                      icon: Icons.business_outlined,
                      child: Text(
                        (employer['name'] as String?) ?? 'N/A',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          // color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],

                  // Organization Identifier
                  if (employer != null && employer['identifier'] != null) ...[
                    const SizedBox(height: 16),
                    _buildInfoSection(
                      context: context,
                      label: 'Organization Identifier',
                      icon: Icons.verified_outlined,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              (employer['identifier'] as String?) ?? 'N/A',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                // color: Colors.grey.shade400,
                                fontFamily: 'monospace',
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            onPressed: () {
                              final identifier =
                                  employer['identifier'] as String?;
                              if (identifier != null) {
                                Clipboard.setData(
                                  ClipboardData(text: identifier),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Organization identifier copied to clipboard',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            style: IconButton.styleFrom(
                              foregroundColor: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),

                  // Meeting Place DID Section
                  _buildInfoSectionWithWrappedLabel(
                    context: context,
                    label:
                        'Connection Node Identity (Meeting Place Orchestration Node)',
                    icon: Icons.dns_outlined,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            ref.read(environmentProvider).serviceDid,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              // color: Colors.grey.shade400,
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          onPressed: () {
                            final serviceDid = ref
                                .read(environmentProvider)
                                .serviceDid;
                            Clipboard.setData(ClipboardData(text: serviceDid));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Meeting Place DID copied to clipboard',
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mediator DID Section
                  _buildInfoSectionWithWrappedLabel(
                    context: context,
                    label: 'Messaging Node Identity (DIDComm Mediator DID)',
                    icon: Icons.hub_outlined,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            ref.read(environmentProvider).mediatorDid,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              // color: Colors.grey.shade400,
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          onPressed: () {
                            final mediatorDid = ref
                                .read(environmentProvider)
                                .mediatorDid;
                            Clipboard.setData(ClipboardData(text: mediatorDid));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Mediator DID copied to clipboard',
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Version Info Section
                  _buildVersionInfoSection(),
                  const SizedBox(height: 16),

                  // Debug Logs Link
                  _buildDebugLogsLink(),
                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text(
                              'Are you sure you want to logout? This action is irreversible and will delete all your credentials.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context); // Close dialog first
                                  await _performLogout();
                                },
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600.withValues(
                          alpha: 0.2,
                        ),
                        foregroundColor: Colors.red.shade400,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.red.shade400,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceVariant.withAlpha(150),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildInfoSectionWithWrappedLabel({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                icon,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceVariant.withAlpha(150),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildChannelItem(Channel channel) {
    final displayName = _getChannelDisplayName(channel);
    final channelDid = channel.permanentChannelDid ?? '';
    final otherPartyDid = channel.otherPartyPermanentChannelDid ?? '';
    final isActive = channel.status == ChannelStatus.approved;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade500, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: isActive ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  displayName,
                  style: const TextStyle(
                    // color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: Colors.red.shade400,
                ),
                onPressed: () => _showDeleteChannelDialog(channel),
                tooltip: 'Delete channel',
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(32, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          if (channelDid.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'DID: ${_truncateDid(channelDid)}',
              style: const TextStyle(
                // color: Colors.grey.shade500,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ],
          if (otherPartyDid.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Their DID: ${_truncateDid(otherPartyDid)}',
              style: const TextStyle(
                // color: Colors.grey.shade500,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showDeleteChannelDialog(Channel channel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Channel'),
        content: Text(
          'Are you sure you want to delete the channel with ${_getChannelDisplayName(channel)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteChannel(channel);
    }
  }

  Future<void> _deleteChannel(Channel channel) async {
    try {
      final repository = await ref.read(channelRepositoryDriftProvider.future);
      await repository.deleteChannel(channel);

      // Refresh the channels list
      ref.invalidate(allChannelsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Channel deleted successfully'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete channel: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _showDeleteAllChannelsDialog(List<Channel> channels) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Channels'),
        content: Text(
          'Are you sure you want to delete all ${channels.length} channels? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteAllChannels(channels);
    }
  }

  Future<void> _deleteAllChannels(List<Channel> channels) async {
    try {
      final repository = await ref.read(channelRepositoryDriftProvider.future);

      // Delete all channels
      for (final channel in channels) {
        await repository.deleteChannel(channel);
      }

      // Refresh the channels list
      ref.invalidate(allChannelsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${channels.length} channels deleted successfully'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete channels: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _getChannelDisplayName(Channel channel) {
    final otherVCard = channel.otherPartyContactCard;
    if (otherVCard != null && otherVCard.contactInfo.isNotEmpty) {
      final firstName = otherVCard.contactInfo['n']?['given'] ?? 'Unnamed';
      final lastName = otherVCard.contactInfo['n']?['surname'] ?? '';
      return '$firstName $lastName';
    }
    return 'Unnamed Channel';
  }

  String _truncateDid(String did) {
    if (did.length <= 30) return did;
    return '${did.substring(0, 15)}...${did.substring(did.length - 15)}';
  }

  void _handleVersionTap() {
    setState(() {
      _versionTapCount++;

      _versionTapTimer?.cancel();
      _versionTapTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _versionTapCount = 0;
          });
        }
      });

      if (_versionTapCount >= 3) {
        ref.read(settingsServiceProvider.notifier).toggleDebugMode();

        final isDebugMode = ref.read(settingsServiceProvider).isDebugMode;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              !isDebugMode ? 'Debug mode enabled!' : 'Debug mode disabled',
            ),
            backgroundColor: isDebugMode ? Colors.green : Colors.orange,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        _versionTapCount = 0;
      }
    });
  }

  Widget _buildVersionInfoSection() {
    final theme = Theme.of(context);
    final appVersionName = ref.read(environmentProvider).appVersionName;
    final version = _packageInfo?.version ?? '0.0.0';
    final buildNumber = _packageInfo?.buildNumber ?? '0';

    return GestureDetector(
      onTap: _handleVersionTap,
      behavior: HitTestBehavior.translucent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, size: 16),
              SizedBox(width: 8),
              Text(
                'Version Information',
                style: TextStyle(
                  // color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade600, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F39F6), Color(0xFF9810FA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.android,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appVersionName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          // color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Version $version ($buildNumber)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          // color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.touch_app_outlined,
                  size: 20,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugLogsLink() {
    final theme = Theme.of(context);
    final isDebugMode = ref.watch(
      settingsServiceProvider.select((state) => state.isDebugMode),
    );

    if (!isDebugMode) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => const DebugLogsScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.bug_report_outlined,
                color: Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debug Logs',
                    style: theme.textTheme.titleMedium?.copyWith(
                      // color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'View application debug logs',
                    style: theme.textTheme.bodySmall?.copyWith(
                      // color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}

/// Radial gradient for circular avatars with a subtle off-axis glow.
/// - Off-axis center adds depth and avoids a flat, dead-center look.
/// - Automatically adapts to light/dark by blending with surface colors.
Gradient avatarRadialGradient(
  BuildContext context, {
  Alignment center = const Alignment(
    -0.18,
    -0.22,
  ), // top-left bias; tweak to taste
  double radius = 0.95,
}) {
  final scheme = Theme.of(context).colorScheme;
  final p = scheme.primary;
  final hsl = HSLColor.fromColor(p);

  // Tonal steps: soft inner glow, mid tint blended with surface, richer rim
  final inner = p.withOpacity(0.22);
  final mid = Color.alphaBlend(p.withOpacity(0.22), scheme.surface);
  final rim = hsl
      .withLightness((hsl.lightness * 0.70).clamp(0.0, 1.0))
      .toColor();

  // Tiny rim contrast; helps on both themes
  final rimAdjusted = Color.alphaBlend(
    rim.withOpacity(0.55),
    (scheme.brightness == Brightness.light ? Colors.black : Colors.white)
        .withOpacity(0.06),
  );

  return RadialGradient(
    center: center,
    radius: radius,
    // Optional: focal point to emphasize the off-axis hotspot
    focal: center + const Alignment(0.05, 0.04),
    focalRadius: 0.05,
    colors: [inner, mid, rimAdjusted],
    stops: const [0.08, 0.52, 1.0],
  );
}

/// Floating avatar widget with subtle animation
class _FloatingAvatar extends HookWidget {
  const _FloatingAvatar({required this.effectiveName, required this.theme});

  final String? effectiveName;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: avatarRadialGradient(context),
          border: Border.all(color: theme.colorScheme.secondary, width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4F39F6).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            effectiveName?[0].toUpperCase() ?? 'U',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
