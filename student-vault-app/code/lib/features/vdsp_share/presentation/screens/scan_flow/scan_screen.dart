import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/infrastructure/loggers/app_logger/app_logger.dart';
import '../../../../../core/infrastructure/services/camera_service/camera_service.dart';
import '../../../../../core/infrastructure/utils/debug_logger.dart';
import '../../../data/vdsp_service/vdsp_service.dart';
import '../../dialogs/qr_code_picker/qr_code_picker.dart';
import 'scan_confirm_screen.dart';
import 'scan_result.dart';
import 'scanner_bottom_sheets.dart';

class ScannerScreen extends HookConsumerWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = useMemoized(() => AppLogger.instance);
    const logKey = 'SCANSCR';
    final qrCodeController = useTextEditingController();

    Future<bool?> showShareConfirmationBottomSheet(
      String operation,
      List<dynamic> credentials,
    ) async {
      return await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => ShareConfirmationBottomSheet(
          operation: operation,
          credentials: credentials.cast(),
          onConfirm: () {
            Navigator.of(context).pop(true); // Return true
          },
          onCancel: () {
            Navigator.of(context).pop(false); // Close share confirmation
            Navigator.of(context).pop(); // Close scan confirm screen
          },
        ),
      );
    }

    Future<void> showResultBottomSheet(VdspScanResult result) async {
      final isDismissible = result.isFailure;

      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: isDismissible,
        builder: (context) => ResultBottomSheet(
          result: result,
          onDone: () {
            Navigator.of(context).pop(); // Close result sheet
            // Navigate back to previous screen for both success and failure
            Navigator.of(context).pop(); // Close scan screen
          },
        ),
      );
    }

    Future<void> showQRCodeDetailsSheet(ScanResult details) async {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: false,
        builder: (context) => ScanConfirmScreen(
          details: details,
          onShareConfirmation: (requestBody, credentials) async {
            debugLog('share confirmation callback invoked with credentials');
            // Show share confirmation bottom sheet
            final result = await showShareConfirmationBottomSheet(
              requestBody.operation ?? 'Share Request',
              credentials,
            );
            // If user cancelled
            if (result != true) {
              return false;
            }

            return true;
          },
          onComplete: (VdspScanResult result) async {
            debugLog(
              'onComplete callback invoked with status: ${result.status}, message: ${result.message}',
            );

            Navigator.of(context).pop(); // Close scan confirm screen

            if (result.isSuccess || result.isFailure) {
              await showResultBottomSheet(result);
            }
          },
        ),
      );
    }

    void showParseError(String message) {
      logger.warning('Showing parse error to user: $message', name: logKey);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    void handleDetectedCode(String qrData) async {
      logger.info('QR code detected', name: logKey);
      try {
        final decoded = jsonDecode(qrData);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('QR Data is not a JSON object');
        }
        final result = ScanResult.fromJson(decoded);
        logger.info('Parsed scan QR data for id=${result.id}', name: logKey);

        //Show details sheet
        await showQRCodeDetailsSheet(result);
      } on FormatException catch (error) {
        logger.warning('Invalid QR data: ${error.message}', name: logKey);
        showParseError(error.message);
      } catch (_) {
        logger.error('Unexpected error parsing QR data', name: logKey);
        showParseError('Unable to read QR code. Please try again.');
      }
    }

    void handleManualQRInput() {
      final qrCode = qrCodeController.text.trim();
      if (qrCode.isEmpty) {
        showParseError('Please enter a QR Data');
        return;
      }
      logger.info('Using manually entered QR data', name: logKey);
      handleDetectedCode(qrCode);
    }

    Future<void> pasteFromClipboard() async {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        qrCodeController.text = clipboardData!.text!;
      } else {
        showParseError('Clipboard is empty');
      }
    }

    final isCameraAvailable = ref.watch(
      cameraServiceProvider.select((state) => state.isAvailable ?? false),
    );

    if (!isCameraAvailable) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan QR Code')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.qr_code_2, size: 96),
              const SizedBox(height: 24),
              const Text(
                'Camera not detected on this device. You can continue with a '
                'mock scan response instead.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: qrCodeController,
                decoration: InputDecoration(
                  labelText: 'Enter QR Code Data',
                  hintText: 'Paste QR code JSON here',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.paste),
                    onPressed: pasteFromClipboard,
                    tooltip: 'Paste from clipboard',
                  ),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                enableInteractiveSelection: true,
                autocorrect: false,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: handleManualQRInput,
                child: const Text('Submit QR Code'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: QrCodePicker(popOnDetect: false, onDetectCode: handleDetectedCode),
    );
  }
}
