import 'dart:async';

import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ssi/ssi.dart';
import '../../../../../core/hooks/ct_notifier.dart';

import '../../../../../core/infrastructure/exceptions/app_exception.dart';
import '../../../../../core/infrastructure/loggers/app_logger/app_logger.dart';
import '../../../../../core/infrastructure/utils/debug_logger.dart';
import '../../../../authentication/data/login_service/issuer_connection_service.dart';
import '../../../../vdip_claim/data/repositories/issuer_connection/issuer_connection_service.dart';
import '../../../data/vdsp_service/vdsp_service.dart';
import '../../../domain/vdsp_trigger_request.dart';
import 'scan_result.dart';

class ScanConfirmScreen extends HookConsumerWidget {
  const ScanConfirmScreen({
    required this.details,
    required this.onShareConfirmation,
    required this.onComplete,
    super.key,
  });

  final ScanResult details;
  final Future<bool> Function(
    VdspQueryDataBody requestBody,
    List<ParsedVerifiableCredential<dynamic>> verifiableCredentials,
  )
  onShareConfirmation;
  final Future<void> Function(VdspScanResult result) onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = useMemoized(() => AppLogger.instance);
    const logKey = 'ScanConfirmScreen';

    final isProcessingNotifier = useCTNotifier(false);
    final isCheckingTrustNotifier = useCTNotifier(true);
    final isTrustedNotifier = useCTNotifier(false);
    final statusMessageNotifier = useCTNotifier<String?>(null);
    final isActiveProcessingNotifier = useCTNotifier(false);

    final isProcessing = useValueListenable(isProcessingNotifier);
    final isCheckingTrust = useValueListenable(isCheckingTrustNotifier);
    final isTrusted = useValueListenable(isTrustedNotifier);
    final statusMessage = useValueListenable(statusMessageNotifier);
    final isActiveProcessing = useValueListenable(isActiveProcessingNotifier);

    void updateProgress(String message, {bool isActive = true}) {
      debugLog(message, name: logKey, logger: logger);
      statusMessageNotifier.value = message;
      isActiveProcessingNotifier.value = isActive;
    }

    Future<void> updateProgressAsync(String message) async {
      updateProgress(message, isActive: true);
    }

    Future<bool> autoConfirmShare(
      VdspQueryDataBody requestBody,
      List<ParsedVerifiableCredential<dynamic>> verifiableCredentials,
    ) async {
      updateProgress('Auto-confirming credential share...');
      logger.info(
        'Auto-confirming share for trusted DID',
        name: 'ScanConfirmScreen',
      );
      // Add 300 milliseconds delay before auto-confirm share
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return true;
    }

    Future<void> onConfirmPressed(BuildContext context) async {
      if (isProcessing) return;

      isProcessingNotifier.value = true;
      logger.info(
        'Confirming scan for id=${details.id}',
        name: 'ScanConfirmScreen',
      );

      try {
        final vdspService = ref.read(vdspServiceProvider);

        updateProgress('Started processing scan confirmation...');
        await vdspService.confirmScan(
          scanId: details.id,
          recipientDid: details.permanentDid,
          oobUrl: details.oobUrl,
          triggerRequestBody: VpspTriggerRequestBody(
            type: 'VDSP Trigger Request',
            purpose: details.description.isEmpty
                ? 'Requesting access'
                : details.description,
          ),
          onProgress: updateProgressAsync,
          onShareConfirmation: isTrusted
              ? autoConfirmShare
              : onShareConfirmation,
          onComplete: onComplete,
        );

        updateProgress('Waiting for verifier to send sharing request...');
      } on AppException catch (error) {
        logger.error(
          'Verifier connection failed with app exception',
          error: error,
          name: 'ScanConfirmScreen',
        );
        updateProgress(error.message, isActive: false);
      } on TimeoutException catch (error) {
        logger.error(
          'Verifier connection timed out',
          error: error,
          name: 'ScanConfirmScreen',
        );
        updateProgress(
          'Verifier connection timed out. Please try again.',
          isActive: false,
        );
      } catch (error, stackTrace) {
        debugLog(
          'Scan QR Code error: $error',
          name: logKey,
          logger: logger,
          error: error,
          stackTrace: stackTrace,
        );
        logger.error(
          'Unexpected verifier connection failure',
          error: error,
          stackTrace: stackTrace,
          name: 'ScanConfirmScreen',
        );
        final message = error is AppException
            ? error.message
            : error.toString();
        updateProgress(
          'Something went wrong. Please try again. $message',
          isActive: false,
        );
      } finally {
        isProcessingNotifier.value = false;
      }
    }

    Future<void> checkTrustAndAutoConfirm() async {
      updateProgress('Checking trust status...');
      if (details.permanentDid.isEmpty) {
        logger.info(
          'No permanent DID found, skipping trust check',
          name: 'ScanConfirmScreen',
        );
        isCheckingTrustNotifier.value = false;
        return;
      }

      try {
        final issuerService = ref.read(issuerConnectionServiceProvider);
        debugLog(
          'details.permanentDid: ${details.permanentDid}',
          name: logKey,
          logger: logger,
        );
        final isTrustedResult = await issuerService.isTrustedDid(
          did: details.permanentDid,
          logKey: 'ScanConfirmScreen',
        );

        debugLog(
          'Trust check result for DID=${details.permanentDid}: $isTrustedResult',
          name: logKey,
          logger: logger,
        );

        isTrustedNotifier.value = isTrustedResult;

        if (isTrustedResult) {
          updateProgress(
            'This requester is part of the sweetlane-group trusted ecosystem. Auto-confirming...',
          );
          logger.info(
            'DID is trusted, auto-confirming scan after 1 second delay',
            name: 'ScanConfirmScreen',
          );
          // Add 300 milliseconds delay before auto-confirm
          await Future<void>.delayed(const Duration(milliseconds: 300));
          await onConfirmPressed(context);
        } else {
          updateProgress(
            'This requester is not part of the sweetlane-group trusted ecosystem.',
            isActive: false,
          );
          logger.info(
            'DID is not trusted, showing confirmation screen',
            name: 'ScanConfirmScreen',
          );
          isCheckingTrustNotifier.value = false;
        }
      } catch (error, stackTrace) {
        debugLog(
          'Error during trust check: $error',
          name: logKey,
          logger: logger,
          error: error,
          stackTrace: stackTrace,
        );
        updateProgress(
          'Error checking verifier trust status, proceeding with manual confirmation',
          isActive: false,
        );
        logger.error(
          'Error checking verifier trust status, proceeding with manual confirmation',
          error: error,
          stackTrace: stackTrace,
          name: 'ScanConfirmScreen',
        );
        isCheckingTrustNotifier.value = false;
      }
    }

    useEffect(() {
      logger.info(
        'ScanConfirmScreen mounted with DID=${details.permanentDid}',
        name: 'ScanConfirmScreen',
      );
      // checkTrustAndAutoConfirm();
      return null;
    }, []);

    final hasDetails =
        details.name.isNotEmpty || details.description.isNotEmpty;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Show loading indicator while checking trust
    // if (isCheckingTrust) {
    //   return Container(
    //     decoration: BoxDecoration(
    //       color: colorScheme.surface,
    //       borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    //     ),
    //     padding: const EdgeInsets.all(32),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const CircularProgressIndicator(),
    //         const SizedBox(height: 16),
    //         Text(
    //           statusMessage ?? 'Verifying trust status...',
    //           style: textTheme.bodyLarge,
    //           textAlign: TextAlign.center,
    //         ),
    //         const SizedBox(height: 32),
    //       ],
    //     ),
    //   );
    // }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 28,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      details.name,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (hasDetails)
                      Card(
                        color: colorScheme.surfaceContainerHigh,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (details.description.isNotEmpty) ...[
                                Text(
                                  'Description',
                                  style: textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  details.description,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    else
                      Card(
                        elevation: 0,
                        color: colorScheme.surfaceContainerHighest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'No scan details available.',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Status Message
                    if (statusMessage != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withValues(alpha: 0.15),
                              colorScheme.primary.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (isActiveProcessing)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colorScheme.primary,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.info_outline,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isActiveProcessing
                                        ? 'Processing'
                                        : 'Status',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    statusMessage,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom action buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isProcessing
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: isProcessing
                          ? null
                          : () => onConfirmPressed(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Proceed'),
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
}
